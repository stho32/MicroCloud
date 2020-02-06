function Remove-MICROVmIntent {
    <#
        .SYNOPSIS
        Removes the intent from the database
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Name
    )
    
    process {
        Invoke-MICROSql -query "
            DELETE FROM VirtualMachinePortForwarding
             WHERE VirtualMachineId IN 
                    ( SELECT Id FROM VirtualMachine WHERE Name = @Name )" -parameter @{
            Name = $Name
        }

        Invoke-MICROSql -query "DELETE dbo.VirtualMachine WHERE RemoveThisVm = 1 AND Name = @Name" -parameter @{
            Name = $Name
        }
    }
}