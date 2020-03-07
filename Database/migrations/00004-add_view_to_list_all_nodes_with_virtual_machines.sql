CREATE VIEW NodesWithVirtualMachines
    AS
	/*
		Get a list of nodes with registered virtual machines
	*/
	SELECT n.Id, n.Name
	  FROM Node n
	  JOIN VirtualMachine vm ON vm.CreatedOnNode = n.Id
	 GROUP BY n.Id, n.Name
