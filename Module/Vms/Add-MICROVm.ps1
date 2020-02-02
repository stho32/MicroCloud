function Add-MICROVM {
    <#
        .SYNOPSIS
        Creates a VM from an image and boots it up
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$VMName,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Node,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$BaseImage
    )

    Process {
        $ImageNodeDirectory = Get-MICROConfigurationValue -Name "TheNodesLocalImageDirectory"
        $VMNamesStartWith = Get-MICROConfigurationValue -Name "VMNamesStartWith"

        Invoke-Command -ComputerName $Node `
            -ArgumentList $ImageNodeDirectory, $VMNamesStartWith, $baseImage, $Node, $vmName `
            -ScriptBlock {
                Param($ImageNodeDirectory, $MicroVMNamesStartWith, $baseImage, $node, $newVmName)

                # The path, where the vm hard disks are created locally. This is a default of Hyper-V.
                $disksPath = "C:\Users\Public\Documents\Hyper-V\Virtual hard disks"
                # The path, where we have the base images distributed to
                $baseImagePath = Join-Path $ImageNodeDirectory "$baseImage.vhdx"

                $vmDiskPath = (Join-Path $disksPath "$newVmName")+".vhdx"

                # create a new differential disk
                New-VHD -Path $vmDiskPath -Differencing -ParentPath $baseImagePath | Out-Null

                # now we need to inject some stuff so the vm will talk to the main system
                Mount-DiskImage -ImagePath $vmDiskPath

                $DriveLetter = (Get-DiskImage -ImagePath $vmDiskPath | GET-DISK | GET-PARTITION).DriveLetter | Sort-Object -Descending | Select -First 1

                $integrationScript = $DriveLetter + "\MicroCloud\MicroCloud\integration.ps1"

                if ( Test-Path $integrationScript ) {
                    $content = Get-Content $integrationScript -Raw
                    $content = $content.Replace('$VMNAME$', $newVmName)
                    $content = $content.Replace('$APIURL$', "http://192.168.88.2:81") 
                    Set-Content -Value $content -Path $integrationScript   
                }

                Dismount-DiskImage -ImagePath $vmDiskPath

                # create vm
                $vm = New-VM -Name $newVmName -MemoryStartupBytes 4GB -VHDPath $vmDiskPath -SwitchName "external switch" -Generation 2 
                # more processing power
                $vm | Set-VMProcessor -Count 8
                # in case we have the image of a linux distribution
                $vm | Set-VMFirmware -EnableSecureBoot Off
                # start it
                $vm | Start-VM 

                # in case we want to do more we return our new vm
                New-Object -TypeName PSObject -Property @{
                    Node = $node
                    VM = $vm
                }
            }

        Set-MICROVmHasBeenActivated -VMName $VMName
    }
}

