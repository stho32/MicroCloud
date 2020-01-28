function Get-MICRONodeStats {
    <#
        .SYNOPSIS
        collects stats needed for vm distribution (derived from database calculation)

        .DESCRIPTION
        This cmdlet retrieves statistical information based on the data we have in our database.
        This is not as perfect as getting the real stats from the physical computers but has several
        advantages, too:

        - the results are not dependent on the status of the virtual machines (aka if they actually run or not)
        - the results are generated much faster
    #>
    [CmdletBinding()]
    Param()

    Process {
        Get-MICROSql -query "SELECT * FROM MICRONodeStats"
    }
}



