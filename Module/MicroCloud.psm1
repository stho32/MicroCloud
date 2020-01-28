<#
    MICRO CLOUD 

    This module implements a simple domain & hyper-V based compute cloud.
#>
$ErrorActionPreference = "Stop"

$global:MICROCLOUD_VMNamesStartWith = "MicroVM-"
$global:MICROCLOUD_MicroNodes = "MASTER", "NODE01", "NODE02"

$global:MICROCLOUD_ImageDirectory = "C:\Users\Public\Documents\Hyper-V\Virtual hard disks"
$global:MICROCLOUD_ImageNodeDirectory = "C:\Projekte\Images"

$global:MICROCLOUD_SQLServer = ".\SQLEXPRESS"
$global:MICROCLOUD_SQLUsername = "MicroCloudUser"
$global:MICROCLOUD_SQLPassword = "123123"
$global:MICROCLOUD_SQLDatabase = "MicroCloud"

# This module is needed to access the router using SSH.
[Reflection.Assembly]::LoadFile("C:\Program Files\WindowsPowerShell\Modules\Posh-SSH\2.2\Assembly\Renci.SshNet.dll")
Import-Module Posh-SSH

Push-Location $PSScriptRoot

Get-ChildItem -Filter "*.ps1" -Recurse | 
	ForEach-Object {
		#Write-Host "Loading $($_.Name) ..."
		. ($_.Fullname)
}

Pop-Location