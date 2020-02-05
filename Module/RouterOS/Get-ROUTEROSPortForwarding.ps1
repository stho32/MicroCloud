function Get-ROUTEROSPortForwarding {
    <#
        .SYNOPSIS
        Reads all port forwardings from ROUTEROS device
    #>
    [CmdletBinding()]
    Param(
    )
    
    Process {
        $masterNodeIP = Get-MICROConfigurationValue -Name MasterIP
        $natRules = Invoke-ROUTEROS -command "/ip firewall nat print terse"
        Import-ROUTEROSPortForwarding -portForwardingsTerse $natRules |
            Where-Object chain -eq "dstnat" | # only dstnat = not the masquerading rule
            Where-Object { -not ($_.ToAddress -eq $masterNodeIP) } # not the port forwardings of the master node
    }
}