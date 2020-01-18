<#
    MICRO CLOUD 

    This module implements a simple domain & hyper-V based compute cloud.
#>
$ErrorActionPreference = "Stop"

$global:MICROCLOUD_VMNamesStartWith = "Test-"
$global:MICROCLOUD_MicroNodes = "MASTER", "NODE01", "NODE02"

$global:MICROCLOUD_ImageDirectory = "C:\Users\Public\Documents\Hyper-V\Virtual hard disks"
$global:MICROCLOUD_ImageNodeDirectory = "C:\Projekte\Images"

Push-Location $PSScriptRoot

Get-ChildItem -Filter "*.ps1" -Recurse | 
	ForEach-Object {
		#Write-Host "Loading $($_.Name) ..."
		. ($_.Fullname)
}

Pop-Location