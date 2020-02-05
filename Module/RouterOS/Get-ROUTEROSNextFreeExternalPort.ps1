function Get-ROUTEROSNextFreeExternalPort {
    <#
        .SYNOPSIS
        Finds the next free port that is not in use within the given range and considering the existing port forwardings
    #>
    [CmdletBinding()]
    Param(
        [PSObject]$ExistingPortForwardings
    )

    Process {
        $PortRangeStart = [int](Get-MICROConfigurationValue -Name EntranceRouterPortRangeStart)
        $PortRangeEnd = [int](Get-MICROConfigurationValue -Name EntranceRouterPortRangeEnd)

        $PortRangeStart..$PortRangeEnd | 
            Where-Object { $_ -notin $ExistingPortForwardings.DstPort } | 
            Sort-Object | 
            Select-Object -First 1
    }
}