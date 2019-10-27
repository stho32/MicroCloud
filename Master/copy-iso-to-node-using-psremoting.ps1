<#
    Copy ISO files to nodes
#>

$node = "192.168.178.53"

$credentials = Get-Credential

$nodeSession = New-PSSession -ComputerName $node -Credential $credentials

Invoke-Command -Session $nodeSession -ScriptBlock {
    if ( !(Test-Path C:\Projekte\ISOs) ) {
        New-Item "C:\Projekte\ISOs" -ItemType Directory
    }
}

Copy-Item -Path "C:\Projekte\ISOs\de_windows_10_business_editions_version_1903_updated_oct_2019_x64_dvd_64a2e8fd.iso" -Destination "C:\Projekte\ISOs" -ToSession $nodeSession

Remove-PSSession $nodeSession
