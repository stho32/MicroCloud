function Add-MICROVMIntent {
    <#
        .SYNOPSIS
        Adds a declaration for an upcoming vm that you wish for

        .DESCRIPTION
        The declaration of an "intent" for having a vm reserves system ressources.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$BaseImage
    )
    
    process {
        Get-MICROSql -query 'EXEC dbo.AddMicroVM @baseImage' -parameter @{
            baseImage = $BaseImage
        }
    }
}