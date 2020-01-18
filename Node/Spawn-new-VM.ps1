
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

