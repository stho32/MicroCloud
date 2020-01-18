function Stop-MICROVM {
    <#
        .SYNOPSIS
        Stops the Micro Cloud VM on whatever host it may be
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Node,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [PSObject]$VM
    )
    
    process {
        if ( $VM.State -ne "Off" ) {
            Write-Host "- stopping $($VM.VMName) on $Node ..."
            Invoke-Command -ComputerName $Node -ArgumentList $VM.VMName -ScriptBlock {
                Param($vmName)

                Get-VM $vmName | Stop-VM -Force
            }
        }
    }
}