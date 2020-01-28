function Set-MICROVmIntentStop {
    <#
        .SYNOPSIS
        Does not stop the Vm yet, but declares, that we wish that this is done
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Name
    )
    
    process {
        Invoke-MICROSql -query "UPDATE dbo.VirtualMachine SET RemoveThisVm = 1 WHERE Name = @Name" -parameter @{
            Name = $Name
        }
    }
}