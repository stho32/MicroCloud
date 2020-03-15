<#
    
    Start this script as administrator to update your cloud instance to the newest version

#>
Set-Location $PSScriptRoot
$ErrorActionPreference = "Stop"

Remove-Item "*.zip" -Force

Invoke-WebRequest -Uri "http://realmbender.de/microcloud/Database.zip" -OutFile "database.zip"

if ( Test-Path "Database" ) {
    Remove-Item "Database" -Recurse -Force
}
Expand-Archive "database.zip" -DestinationPath ".\Database"

.\Database\Database\setup-or-migrate-database.ps1

Set-Location $PSScriptRoot

Invoke-WebRequest -Uri "http://realmbender.de/microcloud/MicroCloud.API.ClientSide.zip" -OutFile "MicroCloud.API.ClientSide.zip"
Expand-Archive "MicroCloud.API.ClientSide.zip" -DestinationPath "C:\inetpub\" -Force

Invoke-WebRequest -Uri "http://realmbender.de/microcloud/MicroCloud.API.CloudSide.zip" -OutFile "MicroCloud.API.CloudSide.zip"
Expand-Archive "MicroCloud.API.CloudSide.zip" -DestinationPath "C:\inetpub\" -Force

Set-Location $PSScriptRoot
cd ..
cd MicroCloud

git pull
