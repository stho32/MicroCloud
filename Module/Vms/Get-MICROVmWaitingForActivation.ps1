function Get-MICROVmWaitingForActivation {
    <#
        .SYNOPSIS
        Grabs the list of vms waiting to be put to life on a hyper-visor
    #>
    [CmdletBinding()]
    param (
    )
    
    process {
        Get-MICROSql -query "SELECT * FROM dbo.VirtualMachinesThatWaitForActivation"
    }
}