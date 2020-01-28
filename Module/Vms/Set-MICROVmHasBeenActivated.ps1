function Set-MICROVmHasBeenActivated {
    <#
        .SYNOPSIS
        declares to the database that the given virtual machine has successfully been created
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$VmName
    )
    
    process {
        Invoke-MICROSql -query 'EXEC dbo.VmHasBeenActivated @VmName' -parameter @{
            VmName = $VmName
        }
    }
}