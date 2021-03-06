function Get-MICROConfigurationValue {
    <#
        .SYNOPSIS
        get the configuration value for the given name
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet(
            "VMNamesStartWith", 
            "TheMastersLocalImageDirectoryBeforeDistribution", 
            "TheNodesLocalImageDirectory",
            "EntranceRouterInternalIP",
            "EntranceRouterExternalIP",
            "MasterIP",
            "EntranceRouterPortRangeStart",
            "EntranceRouterPortRangeEnd",
            "EntranceRouterUsername", 
            "EntranceRouterPassword")]
        [string]$Name
    )
    
    process {
        Get-MICROSql -query "SELECT Value FROM Configuration WHERE Name=@Name" -parameter @{
            Name = $Name
        } | Select-Object -ExpandProperty Value
    }
}