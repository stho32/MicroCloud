Remove-Module MicroCloud*
Import-Module "C:\Projekte\MicroCloud\Module\MicroCloud.psm1"

$portForwardings = Get-ROUTEROSPortForwarding 
$nextFreePort = Get-ROUTEROSNextFreeExternalPort -ExistingPortForwardings $portForwardings 

Add-ROUTEROSPortForwarding -ExternalPort $nextFreePort -LocalTargetIP "192.168.88.194" -LocalTargetPort 3389

#Remove-ROUTEROSPortForwarding -number 3



