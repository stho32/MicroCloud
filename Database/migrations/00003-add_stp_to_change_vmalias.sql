CREATE PROCEDURE dbo.SetVmAlias (@Id INT, @Alias VARCHAR(200))
	AS
BEGIN
	/*
		Sets the alias of the vm
	*/
	UPDATE dbo.VirtualMachine
	   SET Alias = @Alias
	 WHERE Id = @Id
END