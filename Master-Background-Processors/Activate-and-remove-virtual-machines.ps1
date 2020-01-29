<#
    .SYNOPSIS
    Invokes the processor that     

#>
Set-Location $PSScriptRoot

Import-Module "..\Module\MicroCloud.psm1"
. ..\config.ps1

while ($true) {
    Write-Host "[$(Get-Date)] checking for new todos..."
    Invoke-MICROProcessingStep
    Start-Sleep -Seconds 1
}