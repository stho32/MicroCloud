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

# Accesses the "real" ressources
#Write-Output "- Grab yourself an overview of all running vms on all nodes" 
#Get-MICROVM | Format-Table

Get-MicroVMIntent | Format-Table

Write-Output ""
Write-Output "- Add intents to add 18 machines..." 

1..18 | ForEach-Object {
    Add-MICROVMIntent -BaseImage "Basis-Windows-Server-2019-Image"
} | Format-Table

Write-Output ""
Write-Output "- Retrieve an overview of available ram ressources" 
Get-MICRONodeStats | Format-Table

Write-Output ""
Write-Output "- Invoke a processing step to perform all necessary tasks on the nodes" 

Invoke-MICROProcessingStep

# declare the intent to stop all micro cloud vms
Get-MICROVmIntent | Set-MICROVmIntentStop

Invoke-MICROProcessingStep

$stop = Get-Date
$durationInSeconds = ($stop-$start).TotalSeconds
Write-Output "Total duration in seconds: $durationInSeconds"

