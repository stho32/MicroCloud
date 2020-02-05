function Remove-ROUTEROSPortForwarding {
    <#
        .SYNOPSIS
        Adds a port forwarding to the routers table
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [int]$number
    )

    Process {
        $command = "/ip firewall nat remove numbers=$number"

        Invoke-ROUTEROS -command $command
    }
}