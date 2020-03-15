<#
    This script checks if the database already exists.
    If not it will create everything needed.

    Then it will look at the migration state and look for migrations that need execution.
    If it finds a few of them, they will be executed.
#>
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$databaseExists = Invoke-Sqlcmd -ServerInstance ".\SQLEXPRESS" "
    SELECT Name FROM sys.databases WHERE name='MicroCloud'
"

if ( ![bool]$databaseExists ) {
    Invoke-Sqlcmd -ServerInstance ".\SQLEXPRESS" -InputFile create-database-and-login.sql
    Invoke-Sqlcmd -ServerInstance ".\SQLEXPRESS" -Database "MicroCloud" -InputFile database.sql
}

$migrations = Get-ChildItem .\migrations -Filter *.sql

# enter all found migrations into the database if they do not yet exist
$migrations | ForEach-Object {
    $filename = $_.Name
    $sql = "
        IF (NOT EXISTS(SELECT 1 FROM DatabaseMigrations WHERE Filename = '$filename'))
        BEGIN
	        INSERT INTO DatabaseMigrations (Filename)
	        VALUES ('$filename')
        END    
    "
    Invoke-Sqlcmd -ServerInstance ".\SQLEXPRESS" -Database "MicroCloud" $sql
}

# execute migrations that have not been executed yet
$migrationsThatNeedExecution = Invoke-Sqlcmd -ServerInstance ".\SQLEXPRESS" -Database "MicroCloud" "SELECT * FROM DatabaseMigrations WHERE HasBeenExecuted = 0 ORDER BY Filename"

$migrationsThatNeedExecution | ForEach-Object {
    $migration = $_
    $pathToSqlFile = Join-Path .\migrations $_.Filename
    $migrationId = $migration.Id
    Write-Host " - migrating $pathToSqlFile ..." -ForegroundColor Yellow
    Invoke-Sqlcmd -ServerInstance ".\SQLEXPRESS" -Database "MicroCloud" -InputFile $pathToSqlFile

    Invoke-Sqlcmd -ServerInstance ".\SQLEXPRESS" -Database "MicroCloud" "
        UPDATE DatabaseMigrations
           SET HasBeenExecuted = 1, 
               TimestampOfExecution = GETDATE()
         WHERE Id = $migrationId
    "
}

Write-Host "Everything up and ok... :)" -ForegroundColor Green