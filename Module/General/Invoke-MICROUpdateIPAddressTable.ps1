function Invoke-MICROUpdateIPAddressTable {
    <#
        .SYNOPSIS
        Uses information about MAC Addresses retrieved from the VM and the router to find out about the IP Addresses within the network

        .DESCRIPTION
        This way virtual machines do not have to talk to the main system to declare their IPs.
    #>
    [CmdletBinding()]
    param (
    )
    
    process {
        $vmsThatNeedTheirIP = Get-MICROVmIntent | 
            Where-Object CloudInternalIP -eq "" 
        
        if ([bool]$vmsThatNeedTheirIP) {
            $dhcpLeases = Get-ROUTEROSDhcpLeases | 
                Select-Object @{ Label="MacAddress"; Expression={ $_.MacAddress.Replace(":", "").ToUpper().Trim() } },
                    Address
        
            $vmsThatNeedTheirIP | ForEach-Object {
                $vmIntent = $_
                $ip = ($dhcpLeases | Where-Object { $_.MacAddress.Trim() -eq $vmIntent.MacAddress.Trim() } | Select-Object -Last 1).Address
                
                if ([bool]$ip) {
                    Invoke-MICROSql -query "
                        UPDATE dbo.VirtualMachine 
                        SET CloudInternalIP = @Address
                        WHERE Name = @VmName" -parameter @{
                            VmName = $vmIntent.Name
                            Address = $ip
                        }
                }
            }
        }
    }
}