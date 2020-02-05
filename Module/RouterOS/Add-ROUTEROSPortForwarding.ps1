function Add-ROUTEROSPortForwarding {
    <#
        .SYNOPSIS
        Adds a port forwarding to the routers table
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [int]$ExternalPort,
        [Parameter(Mandatory=$true)]
        [string]$LocalTargetIP,
        [Parameter(Mandatory=$true)]
        [int]$LocalTargetPort
    )

    Process {
        $ExternalNetworkIP = Get-MICROConfigurationValue -Name EntranceRouterExternalIP

        $addNAT = "/ip firewall nat add chain=dstnat action=dst-nat "
        $addNAT += "to-addresses=$LocalTargetIP "
        $addNAT += "to-ports=$LocalTargetPort "
        $addNAT += "protocol=tcp "
        $addNAT += "dst-address=$ExternalNetworkIP "
        $addNAT += "dst-port=$ExternalPort "

        Invoke-ROUTEROS -command $addNAT
    }
}
