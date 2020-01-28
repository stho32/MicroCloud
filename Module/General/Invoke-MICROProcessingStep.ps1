function Invoke-MICROProcessingStep {
    <#
        .SYNOPSIS
        Perform 1 step of tasks that are needed to be performed judging by the contents of the database
    
    #>
    [CmdletBinding()]
    param (
    )
    
    process {
        # activate all vms that wait for activation
        Get-MICROVmWaitingForActivation | Add-MICROVM
        # deactivate and remove vms that wait for that
        Get-MICROVmWaitingForRemoval | Stop-MICROVMIntent
    }
}