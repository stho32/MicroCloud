function Get-MICRONodeRealStats {
    <#
        .SYNOPSIS
        collects stats needed for vm distribution

        .DESCRIPTION
        This cmdlet collects information about available RAM by connecting to the "real machines"
        and asking them for the amount of ram. 

        This is more accurate as the database method but has disadvantages because Powershell 
        Remoting is slow and the results are dependent on the state of the vms and the system 
        which may be bad for concurrency.
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



