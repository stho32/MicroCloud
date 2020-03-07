function Invoke-MICROStartingAndStoppingVms {
    <#
        .SYNOPSIS
        Starts and stops the virtual machines as requested by the users
    #>
    [CmdletBinding()]
    param (
    )
    
    process {
        Get-MICROVmIntent | 
            Where-Object { ($_.StopThisVm -eq 1) -and ($_.Status -eq "Running") } | 
            ForEach-Object {
                $vm = $_
                $node = Get-MICRONode | Where-Object Id -eq $vm.CreatedOnNode
        
                Invoke-MICROSql -query "
                    UPDATE dbo.VirtualMachine 
                    SET StopThisVm = 0
                    WHERE Id = @Id" -parameter @{
                        Id = $vm.Id
                    }
        
                Invoke-Command -ComputerName $node.Name -ArgumentList $vm.Name -ScriptBlock {
                    Param($vmName)
        
                    Stop-VM -VMName $vmName -Force
                }
            }
        
        Get-MICROVmIntent | 
            Where-Object { ($_.StartThisVm -eq 1) -and ($_.Status -eq "Off") } | 
            ForEach-Object {
                $vm = $_
                $node = Get-MICRONode | Where-Object Id -eq $vm.CreatedOnNode
        
                Invoke-MICROSql -query "
                    UPDATE dbo.VirtualMachine 
                    SET StopThisVm = 0
                    WHERE Id = @Id" -parameter @{
                        Id = $vm.Id
                    }
        
                Invoke-Command -ComputerName $node.Name -ArgumentList $vm.Name -ScriptBlock {
                    Param($vmName)
        
                    Start-VM -VMName $vmName
                }
            }
    }
}

