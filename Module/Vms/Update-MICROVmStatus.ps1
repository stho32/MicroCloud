function Update-MICROVmStatus {
    <#
        .SYNOPSIS
        Updates the state information for a virtual machine
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$VmName,
        [Parameter(Mandatory=$true)]
        [string]$State
    )
    
    process {
        Invoke-MICROSql -query "EXEC dbo.UpdateMicroVMStatus @VmName, @State" -parameter @{
            VmName = $VmName
            State = $State
        }
    }
}