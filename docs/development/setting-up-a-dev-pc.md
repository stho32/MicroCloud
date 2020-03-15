# Setting up a dev pc

When developing on the project I mostly do an ADD-MICROVM with a fresh Windows Server 2019 installation that has chocolatey already installed. Then I open an administrative shell and use the following script:

```powershell
choco install -y firefox vscode git.install tortoisegit
choco install -y visualstudio2019professional visualstudio2019-workload-netweb 
choco install -y sql-server-management-studio
choco install -y sql-server-express
cd c:\
mkdir Projects
cd Projects
git clone https://github.com/stho32/MicroCloud.git
git clone https://github.com/stho32/MicroCloudApi.git
git clone https://github.com/stho32/MicroCloudCloudSidePS.git
git clone https://github.com/stho32/MicroCloudClientPS.git
Install-WindowsFeature -name Web-Server -IncludeManagementTools
Install-WindowsFeature -name Web-Asp-Net45
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Offline -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Online -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-Clients -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell -All -NoRestart

Invoke-Sqlcmd -ServerInstance ".\SQLEXPRESS" "
USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2
GO
CREATE LOGIN [MicroCloudUser] WITH PASSWORD=N'123123', DEFAULT_DATABASE=[MicroCloud], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

IF ( NOT EXISTS (SELECT Name FROM sys.databases WHERE name='MicroCloud') ) 
BEGIN
    CREATE DATABASE MicroCloud;
END

GO
use [MicroCloud];
GO
CREATE USER [MicroCloudUser] FOR LOGIN [MicroCloudUser]
GO
ALTER USER [MicroCloudUser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [MicroCloudUser]
GO

CREATE TABLE DatabaseMigrations (
	Id INT NOT NULL PRIMARY KEY IDENTITY,
	Filename VARCHAR(1000) NOT NULL DEFAULT '',
	HasBeenExecuted BIT NOT NULL DEFAULT 0,
	TimestampOfExecution DATETIME 
)
" 

Restart-Computer
```