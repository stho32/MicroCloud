function Invoke-MICROUpdateVMStatusInformation {
    <#
        .SYNOPSIS
        retrieves the hyper-v states from the virtual machines and updates the database
    #>
    [CmdletBinding()]
    param (
    )
    
    process {
        Get-MICRONodeHavingVMs | ForEach-Object {
            $node = $_.Name
        
            $states = Invoke-Command -ComputerName $node -ScriptBlock {
                Get-VM | Select-Object Name, State
            }
        
            $states | ForEach-Object {
                $stateinfo = $_
                Update-MICROVmStatus -VmName $stateinfo.Name -State $stateinfo.State
            }
        }
    }
}