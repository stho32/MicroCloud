function Get-MICRONode {
    <#
        .SYNOPSIS
        retrieves the list of all nodes
    #>
    [CmdletBinding()]
    param (
    )
    
    process {
        Get-MICROSql -query "SELECT * FROM Node"
    }
}