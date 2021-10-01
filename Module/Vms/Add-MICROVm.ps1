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
        [string]$BaseImage,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$RamInGB
    )

    Process {
        $ImageNodeDirectories = @((Get-MICROConfigurationValue -Name "TheNodesLocalImageDirectory").split("|"))
        #$ImageNodeDirectory 
        $VMNamesStartWith = Get-MICROConfigurationValue -Name "VMNamesStartWith"

        $result = Invoke-Command -ComputerName $Node `
            -ArgumentList $ImageNodeDirectories, $VMNamesStartWith, $baseImage, $Node, $vmName, $RamInGB `
            -ScriptBlock {
                Param($ImageNodeDirectories, $MicroVMNamesStartWith, $baseImage, $node, $newVmName, $ramInGB)

                # The path, where the vm hard disks are created locally. This is a default of Hyper-V.
                #$disksPath = "C:\Users\Public\Documents\Hyper-V\Virtual hard disks"
                $disksPath = "D:\VirtualHardDisks"

                # Create disks path if we do not have it available
                if (-not (Test-Path $disksPath)) {
                    New-Item -Path $disksPath -ItemType Directory
                }

                # The path, where we have the base images distributed to
                # We can have multiple directories configured. We use the last one we find, in 
                # case we add hard-disks the bigger empty one is probably at the end
                $baseImagePath = $ImageNodeDirectories | ForEach-Object {
                    $ImageNodeDirectory = $_
                    Join-Path $ImageNodeDirectory "$baseImage.vhdx"
                } | Where-Object { Test-Path{ $_ } } |
                    Select-Object -Last 1

                $vmDiskPath = (Join-Path $disksPath "$newVmName")+".vhdx"

                # create a new differential disk
                New-VHD -Path $vmDiskPath -Differencing -ParentPath $baseImagePath | Out-Null

                # now we need to inject some stuff so the vm will talk to the main system
                Mount-DiskImage -ImagePath $vmDiskPath | Out-Null

                $DriveLetter = (Get-DiskImage -ImagePath $vmDiskPath | GET-DISK | GET-PARTITION).DriveLetter | Sort-Object -Descending | Select -First 1

                $integrationScript = $DriveLetter + ":\MicroCloud\integration.ps1"

                if ( Test-Path $integrationScript ) {
                    $content = Get-Content $integrationScript -Raw
                    $content = $content.Replace('$VMNAME$', $newVmName)
                    $content = $content.Replace('$APIURL$', "http://192.168.88.2:81") 
                    Set-Content -Value $content -Path $integrationScript   
                }

                Dismount-DiskImage -ImagePath $vmDiskPath | Out-Null

                # create vm
                $vm = New-VM -Name $newVmName -MemoryStartupBytes ($ramInGB*1GB) -VHDPath $vmDiskPath -SwitchName "external switch" -Generation 2 
                # more processing power
                $vm | Set-VMProcessor -Count 8
                # activate nested virtualization
                $vm | Set-VMProcessor -ExposeVirtualizationExtensions $true
                # in case we have the image of a linux distribution
                $vm | Set-VMFirmware -EnableSecureBoot Off
                # start it
                $vm | Start-VM 

                # wait for mac address ...
                Start-Sleep -Seconds 5

                # get the mac address
                $vmNetworkAdapter = Get-VMNetworkAdapter -VMName $newVmName
                $mac = $vmNetworkAdapter.MacAddress

                # in case we want to do more we return our new vm
                New-Object -TypeName PSObject -Property @{
                    Node = $node
                    VM = $vm
                    Mac = $mac
                }
            }

        Set-MICROVmHasBeenActivated -VMName $VMName -MacAddress ($result.mac | Out-String)

        $result
    }
}

