function Get-MICRONodeHavingVMs {
    <#
        .SYNOPSIS
        retrieves the list of nodes with currently registered virtual machines
    #>
    [CmdletBinding()]
    param (
    )
    
    process {
        Get-MICROSql -query "SELECT * FROM NodesWithVirtualMachines"        
    }
}