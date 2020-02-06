Import-Module "C:\Projekte\MicroCloud\Module\MicroCloud.psm1"

Start-Sleep -Seconds 1

Write-Host "[$(Get-Date)] checking for port forwarding todos ..."

# get me a list of port forwardings, that are valid at this very moment
$portForwardingsDefined = Get-MICROSql -query "
SELECT pf.Id, VirtualMachineId, LocalPort, PortOnEntranceRouter, 
       vm.Name AS VMName, CloudInternalIP 
  FROM VirtualMachinePortForwarding pf
  JOIN VirtualMachine vm ON pf.VirtualMachineId = vm.Id
 WHERE RemoveThis = 0
   AND CloudInternalIP <> ''
"
# get the list of port forwardings that exist at this very moment
$portForwardingsExisting = Get-ROUTEROSPortForwarding 

# create new ones, if they are not existing yet
$portForwardingsDefined | ForEach-Object {
    $portForwarding = $_

    $check = $portForwardingsExisting | Where-Object { $_.ToPort -eq $portForwarding.LocalPort -and $_.ToAddress -eq $portForwarding.CloudInternalIP }
    if ( ![bool]$check ) {
        
        # defined but not existing = create

        $nextFreePort = Get-ROUTEROSNextFreeExternalPort -ExistingPortForwardings $portForwardingsExisting
        Add-ROUTEROSPortForwarding -ExternalPort $nextFreePort -LocalTargetIP $portForwarding.CloudInternalIP -LocalTargetPort $portForwarding.LocalPort

        Invoke-MICROSql -query "
            UPDATE dbo.VirtualMachinePortForwarding
               SET IsEnabled = 1,
                   PortOnEntranceRouter = @nextFreePort
             WHERE Id = @Id" -parameter @{
                nextFreePort = $nextFreePort
                Id = $portForwarding.Id
            }

        Write-Host "  - created port $nextFreePort forwarding to" $portForwarding.CloudInternalIP $portForwarding.LocalPort -ForegroundColor Green
        exit # only perform 1 change every round
    }
}

# remove ones that are not needed anymore
$portForwardingsExisting | ForEach-Object {
    $portForwarding = $_
    
    $check = $portForwardingsDefined | Where-Object { $_.LocalPort -eq $portForwarding.ToPort -and $_.CloudInternalIP -eq $portForwarding.ToAddress }
    if ( -not ([bool]$check) ) {

        # not defined but existing = remove

        Remove-ROUTEROSPortForwarding -number $portForwarding.Number

        Write-Host "  - removed port $($portForwarding.DstPort) forwarding to" $portForwarding.ToAddress $portForwarding.ToPort -ForegroundColor yellow
        exit
    }
}


