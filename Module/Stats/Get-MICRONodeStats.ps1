function Get-MICRONodeStats {
    <#
        .SYNOPSIS
        collects stats needed for vm distribution
    #>
    [CmdletBinding()]
    Param()

    Process {
        $vmsOnTheMaster = Get-MICROVM -NoFilter

        $MicroNodes | ForEach-Object {
            $node = $_

            $ramTotal = Invoke-Command -ComputerName $node -ScriptBlock {
                (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb
            }

            $reservedRAMPerNode = 4 # GB

            $usedByVMsGB = ((($vmsOnTheMaster | Where-Object Node -eq $node).VM.MemoryAssigned/1GB) | Measure-Object -Sum).Sum

            New-Object -TypeName PSObject -Property @{
                Node = $node
                RamTotalGB = $ramTotal - $reservedRAMPerNode - $usedByVMsGB
            }
        }
    }
}

