function Sync-MICROImage {
    <#
        .SYNOPSIS
        Replicates the base disk images to every node
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$SourcePath,
        [Parameter(Mandatory=$true)]
        [string]$TargetPath
    )

    Process {
        $MicroNodes | ForEach-Object {
            $node = $_

            Write-Host "- ensuring target directory exists on $node ..."
            Invoke-Command -ComputerName $node -ArgumentList $TargetPath -ScriptBlock {
                Param([string]$TargetPath)
                if ( -not (Test-Path $TargetPath) ) {
                    New-Item -Path $TargetPath -Force -ItemType Directory | Out-Null
                }
            }

            Write-Host "- Removing old images from $node ..."
            Invoke-Command -ComputerName $node -ScriptBlock {
                Get-ChildItem $TargetPath -Filter *.vhdx | Remove-Item
            }

            Write-Host "- Copying images to $node ..."
            Get-ChildItem $SourcePath -Filter *-image.vhdx | ForEach-Object {
                $filename = $_.FullName
                $session = New-PSSession -ComputerName $node
                try
                {
                    Copy-Item $filename -Destination $TargetPath -ToSession $session
                } finally {
                    Remove-PSSession $session
                }
            }
        }
    }
}