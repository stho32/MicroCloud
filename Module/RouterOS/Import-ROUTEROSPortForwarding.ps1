function Import-ROUTEROSPortForwarding {
    <#
        .SYNOPSIS
        Import Router-OS port forwardings from "/ip firewall nat print terse"
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        $portForwardingsTerse
    )

    Process {
        function SimpleParseValue($valueName, $values) {
            $values | Where-Object {[bool]$_ } | Where-Object {$_.StartsWith("$valueName=")} | Foreach-Object { $_.Replace("$ValueName=", "") }
        }
        
        for ($i = 0; $i -lt $portForwardingsTerse.Count; $i++) {
            $values = $portForwardingsTerse[$i].Trim().Split(" ")
            if ($values.Length -gt 4) {
                $number = $values[0]
                $chain = SimpleParseValue "chain" $values 
                $toAddresses = SimpleParseValue "to-addresses" $values  
                $toPorts = SimpleParseValue "to-ports" $values  
                $dstPort = SimpleParseValue "dst-port" $values
                
                New-Object -TypeName PSObject -Property @{
                    Number    = $number
                    Chain     = $chain
                    ToAddress = $toAddresses
                    ToPort    = $toPorts
                    DstPort   = $dstPort
                }
            }
        }
    }
}
