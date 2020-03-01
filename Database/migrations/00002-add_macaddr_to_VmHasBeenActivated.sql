ALTER PROCEDURE VmHasBeenActivated (@Name VARCHAR(200), @MacAddress VARCHAR(200))
    AS
BEGIN
	/*
		This STP is called when the vm has been created and started on the hyper-visor.
		We need to update our data now, so we know it has been activated.
	*/
	UPDATE dbo.VirtualMachine
	   SET IsActivated = 1,
           MacAddress = @MacAddress
	 WHERE Name = @Name
END