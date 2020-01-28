function Get-MICROVmIntent {
    <#
        .SYNOPSIS
        lists all micro vms (actually their intents)
    #>
    [CmdletBinding()]
    Param(
    )

    Process {
        Get-MICROSql -query "SELECT * FROM VirtualMachine"
    }
}