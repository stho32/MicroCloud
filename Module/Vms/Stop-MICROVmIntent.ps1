function Stop-MICROVMIntent {
    <#
        .SYNOPSIS
        Stops the given Micro-Vm (given as intent-parameters)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Node,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$VMName
    )
    
    process {
        Invoke-Command -ComputerName $Node -ArgumentList $VMName -ScriptBlock {
            Param($vmName)

            $vm = Get-VM $vmName

            $vm | Stop-VM -Force

            try {
                Remove-Item (Get-VHD -VMId $vm.VMId).Path
            } catch {}

            Remove-VM -Name $vmName -Force
        }

        Remove-MICROVmIntent -Name $vmName
    }
}