<#
    .SYNOPSIS
    This script is my scratchbook for the things that are automated more or less well.

#>

Remove-Module MicroCloud*
Import-Module "C:\Projekte\MicroCloud\Module\MicroCloud.psm1"

Clear

Write-Output ""
Write-Output "- Retrieve an overview of available ram ressources" 
$stats = Get-MICRONodeStats
$stats | Format-Table

Write-Output "- Grab yourself an overview of all running vms on all nodes" 
Get-MICROVM | Format-Table

Write-Output ""
Write-Output "- Create a new virtual machine based on an image as long as we have ressources" 

$ramPerVmNeededGB = 4
While ( (($stats.RamTotalGB)|Measure-Object -Maximum).Maximum -ge $ramPerVmNeededGB ) {
    Add-MICROVM -BaseImage Basis-Windows-Server-2019-Image | Format-Table

    $stats = Get-MICRONodeStats
}

Write-Output ""
Write-Output "- Retrieve an overview of available ram ressources" 
Get-MICRONodeStats | Format-Table

Write-Output ""
Write-Output "- Stop all MicroCloud VMs" 
Get-MICROVM | Stop-MICROVM 

Write-Output ""
Write-Output "- Remove all vms that are stopped right now" 
Clear-MICROHV | Format-Table
