$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Import-Module "..\Module\MicroCloud.psm1"
. ..\config.ps1


While ($true) {
    Start-Sleep -Seconds 1
    
    . .\Activate-and-remove-virtual-machines.ps1
    . .\Port-Forwardings.ps1
}