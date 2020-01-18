<#
    MICRO CLOUD 

    This module implements a simple domain & hyper-V based compute cloud.
#>
$ErrorActionPreference = "Stop"

Push-Location $PSScriptRoot

Get-ChildItem -Filter "*.ps1" -Recurse | 
	ForEach-Object {
		#Write-Host "Loading $($_.Name) ..."
		. ($_.Fullname)
}

Pop-Location