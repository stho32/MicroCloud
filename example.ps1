<#
    .SYNOPSIS
    This script is my scratchbook for the things that are automated more or less well.

#>

Remove-Module MicroCloud*
Import-Module "C:\Projekte\MicroCloud\Module\MicroCloud.psm1"

Clear

$start = Get-Date

Write-Output ""
Write-Output "- Retrieve an overview of available ram ressources" 
$stats = Get-MICRONodeStats
$stats | Format-Table

Write-Output "- Grab yourself an overview of all running vms on all nodes" 
Get-MICROVM | Format-Table

Write-Output ""
Write-Output "- Create a new virtual machines based on an image..." 

$creationJobs = 1..18 | ForEach-Object {
    Add-MICROVM -BaseImage Basis-Windows-Server-2019-Image
} 
$creationJobs | Wait-Job | Receive-Job | Format-Table

Write-Output ""
Write-Output "- Retrieve an overview of available ram ressources" 
Get-MICRONodeStats | Format-Table

Write-Output ""
Write-Output "- Stop all MicroCloud VMs" 
Get-MICROVM | Stop-MICROVM 

Write-Output ""
Write-Output "- Remove all vms that are stopped right now" 
Clear-MICROHV | Format-Table

$stop = Get-Date
$durationInSeconds = ($stop-$start).TotalSeconds
Write-Output "Total duration in seconds: $durationInSeconds"