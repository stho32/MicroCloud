function Get-MICROVmWaitingForRemoval {
    <#
        .SYNOPSIS
        Grabs the list of vms waiting to be put off on a hyper-visor
    #>
    [CmdletBinding()]
    param (
    )
    
    process {
        Get-MICROSql -query "SELECT * FROM dbo.VirtualMachinesThatWaitForRemoval"
    }
}