USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2
GO

IF ( NOT EXISTS (SELECT Name FROM sys.databases WHERE name='MicroCloud') ) 
BEGIN
    CREATE DATABASE MicroCloud;
END
GO

CREATE LOGIN [MicroCloudUser] WITH PASSWORD=N'123123', DEFAULT_DATABASE=[MicroCloud], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
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