# architecture

  - at the outest edge there is internet
  - A dsl router follows which creates a local network, lets call it "cloud-external network". It is the network where the cloud ressources will be available. We find our users computers here, lets call them "developer01", "developer02" and "developer03".
  - There is a router connected to the "cloud-external network". Lets call it "Entrance-Router". [Its a mikrotik router.](configure-mikrotik-entrance-router.md). It uses the "cloud-external network" the same way as your local network does with the internet. It is a NAT-firewall and it seperates the cloud-external network from the cloud-internal network. 
  - The cloud-internal network has an ip range of 192.168.88.0/24 . It contains our "cloud" domain which consists of a master and two nodes as described in the readme.md. They construct the VMs for us and talk to the entrance router to enable and disable ports.

## setting the master up 

  - Installation of Windows Server 2019 Standard
  - Activate the roles Hyper-V, Active Directory, IIS (.Net 4.7 enabled)
  - Install SQL Server Express (set up a [database](database.sql))
  
