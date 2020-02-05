function Get-ROUTEROSNextFreeExternalPort {
    <#
        .SYNOPSIS
        Finds the next free port that is not in use within the given range and considering the existing port forwardings
    #>
    [CmdletBinding()]
    Param(
        [PSObject]$ExistingPortForwardings,
        [Parameter(Mandatory=$true)]
        [int]$PortRangeStart,
        [Parameter(Mandatory=$true)]
        [int]$PortRangeEnd
    )

    Process {
        $PortRangeStart..$PortRangeEnd | 
            Where-Object { $_ -notin $ExistingPortForwardings.DstPort } | 
            Sort-Object | 
            Select-Object -First 1
    }
}