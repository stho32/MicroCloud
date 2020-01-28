function Get-MICROVM {
    <#
        .SYNOPSIS
        lists all micro vms

        .DESCRIPTION
        Use the function with the -NoFilter switch if you want to list all VMs on all the nodes without 
        restricting them to the ones which are managed by MicroCloud.
    #>
    [CmdletBinding()]
    Param(
        [Switch]$NoFilter # Get absolutely any VM on the system, e.g. for system resource management
    )

    Process {
        if ( $NoFilter )
        {
            Get-MICRONode | Where-Object IsActive -eq $true | ForEach-Object {
                $node = $_

                Get-VM -ComputerName $node | ForEach-Object {
                    $vm = $_

                    New-Object -TypeName PSObject -Property @{
                        Node = $node
                        VM = $vm
                    }
                }
            } 

            return
        }

        Get-MICRONode | Where-Object IsActive -eq $true | ForEach-Object {
            $node = $_

            Get-VM -ComputerName $node -Name ($global:MICROCLOUD_VMNamesStartWith + "*") | ForEach-Object {
                $vm = $_

                New-Object -TypeName PSObject -Property @{
                    Node = $node
                    VM = $vm
                }
            }
        }
    }
}