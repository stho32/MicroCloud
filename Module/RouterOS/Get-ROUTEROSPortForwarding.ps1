function Get-ROUTEROSPortForwarding {
    <#
        .SYNOPSIS
        Reads all port forwardings from ROUTEROS device
    #>
    [CmdletBinding()]
    Param(
    )
    
    Process {
        $natRules = Invoke-ROUTEROS -command "/ip firewall nat print terse"
        Import-ROUTEROSPortForwarding -portForwardingsTerse $natRules
    }
}