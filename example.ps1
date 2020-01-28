<#
    .SYNOPSIS
    This script is my scratchbook for the things that are automated more or less well.

    .DESCRIPTION
    Use the lines or the full script

    # synchronize all images within the microcloud
    Sync-MICROImage
#>


Remove-Module MicroCloud*
Import-Module "C:\Projekte\MicroCloud\Module\MicroCloud.psm1"

<#
$session = New-SSHSession -ComputerName 192.168.88.1 -Credential (Get-Credential) -Verbose

(Invoke-SSHCommand -SSHSession $session -Command "/ip address print").Output
Invoke-SSHCommand -SSHSession $session -Command "print"

Remove-SSHSession $session
#>

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

1..18 | ForEach-Object {
    Add-MICROVM -BaseImage Basis-Windows-Server-2019-Image
} | Format-Table

Write-Output ""
Write-Output "- Retrieve an overview of available ram ressources" 
Get-MICRONodeStats | Format-Table

Write-Output ""
Write-Output "- Stop all MicroCloud VMs" 
Get-MICROVM | Stop-MICROVM 

Write-Output ""
Write-Output "- Remove all vms that are stopped right now" 
Clear-MICROHV 

$stop = Get-Date
$durationInSeconds = ($stop-$start).TotalSeconds
Write-Output "Total duration in seconds: $durationInSeconds"