CREATE TABLE VirtualMachineImage (
	Id INT NOT NULL PRIMARY KEY IDENTITY, 
	Name VARCHAR(200) NOT NULL DEFAULT '',
	IstAktiv BIT NOT NULL DEFAULT 1
)
