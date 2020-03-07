CREATE PROCEDURE dbo.UpdateMicroVMStatus (@VmName VARCHAR(200), @Status VARCHAR(200))
    AS
BEGIN
	/*
		Updates the Hyper-V-Status for a virtual machine
	*/

	UPDATE dbo.VirtualMachine
	   SET Status = @Status
	 WHERE Name = @VmName
END