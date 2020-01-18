<#
    
    Sets up external switches on all Hyper-V nodes
    
#>

Get-ADComputer -Filter * | Where-Object Name -like 'NODE*' | ForEach-Object {

    Write-Host "- processing $($_.Name)..." -ForegroundColor Cyan

    Invoke-Command -ComputerName $_.Name -ScriptBlock {
        $availableSwitches = Get-VMSwitch
        Write-Host " - check for external vm switch"
        if ( !([bool]$availableSwitches) ) {
            Write-Host "   - no switch found"
            <# we need to create a new external switch. Every new VM will use it. #>
    
            # find the active network adapter:
            # we assert that every node has only one adapter connected to the network
            $activeNetworkAdapter = Get-NetAdapter | Where-Object Status -eq "Up" 
            Write-Host "     -> found active network adapter $($activeNetworkAdapter.Name)"
            Write-Host "     -> create new external switch called 'external switch'"

            New-VMSwitch -name "external switch" -NetAdapterName ($activeNetworkAdapter.Name) -AllowManagementOs $true
        } else {
            Write-Host "   - ok"
        }
    }

}