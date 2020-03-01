function Get-ROUTEROSDhcpLeases {
    <#
        .SYNOPSIS
        Download the list of dhcp leases from RouterOS
    #>
    [CmdletBinding()]
    param (
    )
    
    process {
        $dhcpLeasesUnparsed = Invoke-ROUTEROS "/ip dhcp-server lease print terse"

        function SimpleParseValue($valueName, $values) {
            $values | Where-Object {[bool]$_ } | Where-Object {$_.StartsWith("$valueName=")} | Foreach-Object { $_.Replace("$ValueName=", "") }
        }
                
        for ($i = 0; $i -lt $dhcpLeasesUnparsed.Count; $i++) {
            $values = $dhcpLeasesUnparsed[$i].Trim().Split(" ")
            if ($values.Length -gt 4) {
                $number = $values[0]
                $address = SimpleParseValue "address" $values 
                $macAddress = SimpleParseValue "mac-address" $values  
                
                New-Object -TypeName PSObject -Property @{
                    Number     = $number
                    Address    = $address
                    MacAddress = $macAddress
                }
            }
        }

    }
    
}

