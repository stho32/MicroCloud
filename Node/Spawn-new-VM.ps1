function Add-MICROVM {
    <#
        .SYNOPSIS
        Creates a VM from an image and boots it up
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Basis-Windows-Server-2019-Image")]
        $baseImage
    )

    Process {
        $mostEmptyNode = (Get-MICRONodeStats | Sort-Object -Property RamTotalGB -Descending | Select -First 1).Node

        Invoke-Command -ComputerName $mostEmptyNode `
            -ArgumentList $ImageNodeDirectory `
            -ScriptBlock {
                Param($ImageNodeDirectory)
                $disksPath = "C:\Users\Public\Documents\Hyper-V\Virtual hard disks"
                $baseImagePath = "C:\Users\Public\Documents\Hyper-V\Virtual hard disks\$baseImage.vhdx"

                $guid = [Guid]::NewGuid().ToString()
                $newVmName = $MicroVMNamesStartWith + $guid

                $vmDiskPath = (Join-Path $disksPath "$newVmName")+".vhdx"

                # create a new differential disk
                $vmDisk = New-VHD -Path $vmDiskPath -Differencing -ParentPath $baseImagePath

                $vm = New-VM -Name $newVmName -MemoryStartupBytes 4GB -VHDPath $vmDiskPath -SwitchName "external switch" -Generation 2 

                $vm | Set-VMProcessor -Count 8

                $vm | Start-VM 

                $vm
            }
    }
}

function Get-MICROVM {
    <#
        .SYNOPSIS
        lists all micro vms
    #>
    [CmdletBinding()]
    Param(
        [Switch]$NoFilter # Get absolutely any VM on the system, e.g. for system resource management
    )

    Process {
        if ( $NoFilter )
        {
           $MicroNodes | ForEach-Object {
                $node = $_

                Get-VM -ComputerName $node | ForEach-Object {
                    $vm = $_

                    New-Object -TypeName PSObject -Property @{
                        Node = $node
                        VM = $vm
                    }
                }
            } 

            return
        }

        $MicroNodes | ForEach-Object {
            $node = $_

            Get-VM -ComputerName $node -Name ($MicroVMNamesStartWith + "*") | ForEach-Object {
                $vm = $_

                New-Object -TypeName PSObject -Property @{
                    Node = $node
                    VM = $vm
                }
            }
        }
    }
}

function Clear-MICROHV {
    <#
        .SYNOPSIS
        removes all shut down test vms
    #>
    [CmdletBinding()]
    Param()

    Process {
        $vms = Get-MICROVM | Where State -eq "Off" 
        
        $vms | ForEach-Object {
            try {
                Remove-Item (Get-VHD -VMId $_.VMId).Path
            } catch {}

            $_ | Remove-VM -Force
        }
    }
}


function Get-MICRONodeStats {
    <#
        .SYNOPSIS
        collects stats needed for vm distribution
    #>
    [CmdletBinding()]
    Param()

    Process {
        $vmsOnSystem= Get-MICROVM -NoFilter

        $MicroNodes | ForEach-Object {
            $node = $_

            $ramTotal = Invoke-Command -ComputerName $node -ScriptBlock {
                (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb
            }

            $reservedRAMPerNode = 4 # GB

            $usedByVMsGB = ((($vmsOnSystem | Where-Object Node -eq $node).VM.MemoryAssigned/1GB) | Measure-Object -Sum).Sum

            New-Object -TypeName PSObject -Property @{
                Node = $node
                RamTotalGB = $ramTotal - $reservedRAMPerNode - $usedByVMsGB
            }
        }
    }
}

