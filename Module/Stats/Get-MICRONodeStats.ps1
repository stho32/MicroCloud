function Get-MICRONodeStats {
    <#
        .SYNOPSIS
        collects stats needed for vm distribution
    #>
    [CmdletBinding()]
    Param()

    Process {
        $vmsOnTheMaster = Get-MICROVM -NoFilter

        $global:MICROCLOUD_MicroNodes | ForEach-Object {
            $node = $_

            $ramTotal = Invoke-Command -ComputerName $node -ScriptBlock {
                (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb
            }

            $reservedRAMPerNode = 6 # GB

            $usedByVMsGB = ((($vmsOnTheMaster | Where-Object Node -eq $node).VM.MemoryAssigned) | Measure-Object -Sum).Sum/1GB

            New-Object -TypeName PSObject -Property @{
                Node = $node
                RamTotalGB = $ramTotal - $reservedRAMPerNode - $usedByVMsGB
            }
        }
    }
}

