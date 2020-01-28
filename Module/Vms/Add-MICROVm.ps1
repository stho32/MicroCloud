function Add-MICROVM {
    <#
        .SYNOPSIS
        Creates a VM from an image and boots it up
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        $BaseImage
    )

    Process {
        <# Find us the most empty node to create the next vm there.
           We find this node by our scarest resource, the memory.  
        #>
        $mostEmptyNode = (Get-MICRONodeStats | Sort-Object -Property RamTotalGB -Descending | Select-Object -First 1)

        $ramNeededInGb = 4
        if ($mostEmptyNode.RamTotalGB -lt $ramNeededInGb) {
            throw "Not enough RAM for another VM..."
        }

        $ImageNodeDirectory = Get-MICROConfigurationValue -Name "TheNodesLocalImageDirectory"
        $VMNamesStartWith = Get-MICROConfigurationValue -Name "VMNamesStartWith"

        Invoke-Command -ComputerName $mostEmptyNode.Node `
            -ArgumentList $ImageNodeDirectory, $VMNamesStartWith, $baseImage, $mostEmptyNode.Node `
            -ScriptBlock {
                Param($ImageNodeDirectory, $MicroVMNamesStartWith, $baseImage, $node)

                # The path, where the vm hard disks are created locally. This is a default of Hyper-V.
                $disksPath = "C:\Users\Public\Documents\Hyper-V\Virtual hard disks"
                # The path, where we have the base images distributed to
                $baseImagePath = Join-Path $ImageNodeDirectory "$baseImage.vhdx"

                $guid = [Guid]::NewGuid().ToString()
                $newVmName = $MicroVMNamesStartWith + $guid

                $vmDiskPath = (Join-Path $disksPath "$newVmName")+".vhdx"

                # create a new differential disk
                New-VHD -Path $vmDiskPath -Differencing -ParentPath $baseImagePath | Out-Null

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
    }
}

