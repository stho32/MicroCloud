ALTER VIEW [dbo].[RAMOccupiedPerNode]
    AS
	/* 
		sums up the ram used per node
	 */

	SELECT CreatedOnNode, SUM(RAMInGB) AS RAMOccupiedInGB
	  FROM VirtualMachine v
	 WHERE v.Status <> 'Off'
     GROUP BY CreatedOnNode 
GO
