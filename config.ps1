<#
    .SYNOPSIS
    This happens to be a sample configuration

    .DESCRIPTION
    These global variables are declared by the module. 
    With a configuration like this you can adapt them to changing needs.
#>

$global:MICROCLOUD_VMNamesStartWith = "Test-"
$global:MICROCLOUD_MicroNodes = "MASTER", "NODE01", "NODE02"

$global:MICROCLOUD_ImageDirectory = "C:\Users\Public\Documents\Hyper-V\Virtual hard disks"
$global:MICROCLOUD_ImageNodeDirectory = "C:\Projekte\Images"
