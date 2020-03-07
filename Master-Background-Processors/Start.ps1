﻿$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Import-Module "..\Module\MicroCloud.psm1"
. ..\config.ps1
[int]$roundCounter = 0

While ($true) {
    Start-Sleep -Seconds 1
    
    . .\Activate-and-remove-virtual-machines.ps1
    . .\Port-Forwardings.ps1

    # every 5th round we update the state information
    if ( $roundCounter % 5 ) {
        Invoke-MICROUpdateVMStatusInformation
    }

    $roundCounter += 1
}