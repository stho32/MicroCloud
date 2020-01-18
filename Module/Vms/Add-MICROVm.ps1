function Add-MICROVM {
    <#
        .SYNOPSIS
        Creates a VM from an image and boots it up
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Basis-Windows-Server-2019-Image")]
        $BaseImage
    )

    Process {
        <# Find us the most empty node to create the next vm there.
           We find this node by our scarest resource, the memory.  
           There is no resource limit check yet implemented. 
        #>
        $mostEmptyNode = (Get-MICRONodeStats | Sort-Object -Property RamTotalGB -Descending | Select -First 1).Node

        Invoke-Command -ComputerName $mostEmptyNode `
            -ArgumentList $global:MICROCLOUD_ImageNodeDirectory, $global:MICROCLOUD_VMNamesStartWith `
            -ScriptBlock {
                Param($ImageNodeDirectory, $MicroVMNamesStartWith)

                # The path, where the vm hard disks are created locally. This is a default of Hyper-V.
                $disksPath = "C:\Users\Public\Documents\Hyper-V\Virtual hard disks"
                # The path, where we have the base images distributed to
                $baseImagePath = Join-Path $ImageNodeDirectory "$baseImage.vhdx"

                $guid = [Guid]::NewGuid().ToString()
                $newVmName = $MicroVMNamesStartWith + $guid

                $vmDiskPath = (Join-Path $disksPath "$newVmName")+".vhdx"

                # create a new differential disk
                $vmDisk = New-VHD -Path $vmDiskPath -Differencing -ParentPath $baseImagePath

                # create vm
                $vm = New-VM -Name $newVmName -MemoryStartupBytes 4GB -VHDPath $vmDiskPath -SwitchName "external switch" -Generation 2 
                # more processing power
                $vm | Set-VMProcessor -Count 8
                # start it
                $vm | Start-VM 

                # in case we want to do more we return our new vm
                $vm
            }
    }
}

<#
    We want to be able to tab through the available list of base images
#>
Register-ArgumentCompleter -CommandName Add-MICROVM -ParameterName BaseImage -ScriptBlock {
    (Get-ChildItem -Path Join-Path $global:MICROCLOUD_ImageNodeDirectory -Filter "*-image.vhdx" | Select-Object -ExpandProperty Name).Replace(".vhdx", "")
}
