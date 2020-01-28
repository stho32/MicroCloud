function Clear-MICROHV {
    <#
        .SYNOPSIS
        removes all shut down microcloud vms from all nodes of the microcloud
    #>
    [CmdletBinding()]
    Param()

    Process {
        $vms = Get-MICROVM | Where-Object { $_.Vm.State -eq "Off" }
        
        $vms | ForEach-Object {
            $vm = $_

            Write-Host "- removing $($vm.vm.Name) from $($vm.Node) which is not needed anymore..."

            Invoke-Command -ComputerName $vm.Node -ArgumentList $vm.vm.VMId, $vm.vm.Name -ScriptBlock {
                Param($vmID, $vmName)

                try {
                    Remove-Item (Get-VHD -VMId $vmID).Path
                } catch {}

                Remove-VM -Name $vmName -Force
            }
        }
    }
}
