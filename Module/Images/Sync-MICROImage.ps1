function Sync-MICROImage {
    <#
        .SYNOPSIS
        Replicates the base disk images to every node

        .DESCRIPTION
        This cmdlet is run on the MASTER to distribute all VHDX, which follow the convention
        of ending with -image.vhdx to the folder where all the vhdx are saved for "production".

        "Production" in this case means, that there is a folder where the base images for the 
        upcoming vms are connected / created from. 
        
    #>
    [CmdletBinding()]
    Param(
    )

    Process {
        $SourcePath = $global:MICROCLOUD_ImageDirectory
        $TargetPath = $global:MICROCLOUD_ImageNodeDirectory

        Get-MICRONode | Where-Object IsActive -eq $true | ForEach-Object {
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