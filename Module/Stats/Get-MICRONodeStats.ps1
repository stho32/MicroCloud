function Get-MICRONodeStats {
    <#
        .SYNOPSIS
        collects stats needed for vm distribution
    #>
    [CmdletBinding()]
    Param()

    Process {
        $vmsOnTheMaster = Get-MICROVM -NoFilter

        $ramTotalJobs = Get-MICRONode | Where-Object IsActive -eq $true | ForEach-Object {
            $node = $_
        
            Start-Job -ArgumentList $node -ScriptBlock {
                Param($node)
                $RamGB = Invoke-Command -ComputerName $node -ScriptBlock {
                    (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb
                }

                New-Object -TypeName PSObject -Property @{
                    Node = $node
                    RamGB = $RamGB
                }
            }
        }
        
        $ramTotal = $ramTotalJobs | Wait-Job | Receive-Job

        Get-MICRONode | Where-Object IsActive -eq $true | ForEach-Object {
            $node = $_

            $ramTotalNode = ($ramTotal | Where-Object Node -eq $node).RamGB

            $reservedRAMPerNode = 6 # GB

            $usedByVMsGB = ((($vmsOnTheMaster | Where-Object Node -eq $node).VM.MemoryAssigned) | Measure-Object -Sum).Sum/1GB

            New-Object -TypeName PSObject -Property @{
                Node = $node
                RamTotalGB = $ramTotalNode - $reservedRAMPerNode - $usedByVMsGB
            }
        }
    }
}



