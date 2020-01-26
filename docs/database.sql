/* 
	This scripts creates or recreates the database.
*/

/* ------------------------------------------------------------------------------------------

	For every node in our system we have an entry in this table. 

*/	
 

IF (EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'Node'))
BEGIN
	DROP TABLE Node;
END
GO

CREATE TABLE Node (
	Id INT NOT NULL PRIMARY KEY IDENTITY,
	Name VARCHAR(200) NOT NULL,
	RAMReservedForOtherOperationsInGb DECIMAL(15,2) NOT NULL DEFAULT 0,
	IstActive BIT NOT NULL DEFAULT 1
)
GO

/* ------------------------------------------------------------------------------------------

	General configuration is kept in the database as well

*/	


IF (EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'Node'))
BEGIN
	DROP TABLE Configuration;
END
GO

GO
CREATE TABLE Configuration (
	Id INT NOT NULL PRIMARY KEY IDENTITY, 
	Name VARCHAR(200) NOT NULL DEFAULT '',
	Value VARCHAR(1000) NOT NULL DEFAULT '',
	Description VARCHAR(2000) NOT NULL DEFAULT ''
)
GO


/* ------------------------------------------------------------------------------------------

	We have a list of disk images, that are available on the master in a separate
	path. (The master is a node, just one with more tasks to perform.)

*/	


CREATE TABLE DiskImage (
	Id INT NOT NULL PRIMARY KEY IDENTITY,
	Name VARCHAR(200) NOT NULL,
	SourcePathOnMaster VARCHAR(1000) NOT NULL DEFAULT '',
	IsActive BIT NOT NULL DEFAULT 1
)
GO

/* ------------------------------------------------------------------------------------------

	All of those disk images have to be distributed to all nodes.

*/	

CREATE TABLE DiskImageReplication (
	Id INT NOT NULL PRIMARY KEY IDENTITY,
	Node INT NOT NULL REFERENCES Node(Id),
	PathOnNode VARCHAR(1000) NOT NULL DEFAULT '',
	CopyingStartedAt DATETIME NULL,
	CopyingCompletedAt DATETIME NULL
)

GO

/* ------------------------------------------------------------------------------------------

	At last, we have virtual machines. 
	Every row in this table is actually an "intent" that there should be 

*/	
CREATE TABLE VirtualMachine (
	Id INT NOT NULL PRIMARY KEY IDENTITY,
	Name VARCHAR(200) NOT NULL DEFAULT '',
	Alias VARCHAR(200) NOT NULL DEFAULT '',
	Status VARCHAR(200) NOT NULL DEFAULT '',
	RAMinGB DECIMAL(15,4) NOT NULL DEFAULT 4,
	CloudInternalIP VARCHAR(200) NOT NULL DEFAULT '',
	CreatedOnNode INT NOT NULL REFERENCES Node(Id),
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	IsActive BIT NOT NULL DEFAULT 0
)

/* ------------------------------------------------------------------------------------------

	We declare port forwardings for every virtual machine.
	There is a background process on the master that takes the contents of this
	table and communicates with the router to ensure everyone
	has all the ports available they need.

	When a virtual machine is deactivated, all port forwardings are deleted.

*/	
CREATE TABLE VirtualMachinePortForwarding (
	Id INT NOT NULL PRIMARY KEY IDENTITY,
	Comment VARCHAR(200) NOT NULL DEFAULT '',
	LocalPort INT NOT NULL DEFAULT 0,
	PortOnEntranceRouter INT NOT NULL DEFAULT 0,

)
