# MicroCloud

A thin management layer for a bunch of hyper-v hosts to create a small, automatable powershell driven private cloud

In this article:

- [Motivation](#motivation)
- [Installation](#installation)
- [Examples and Screenshots](#examplesandscreenshots)
- [Documentation](#documentation)
- [Contributions](#contributions)
## Motivation 

The aim of the project is to support the needed code to share a bunch of hyper-v computers with some amount of RAM in a group of peers privatly.

More specifically:

- Give smaller groups of developers a way of creating test database servers, email-servers, web-hosting servers etc. on the fly and/or automate builds and deployments in an infrastructure that is controlable by code.

- Make it easy to support computer trainings on e.g. windows server, coding or networking: Everyone of the people taking part should have an 1..n virtual machines to apply whatever is tought to learn fast and pratical.

- Enable easy experimentation on software by making it easy to get a computer for a few minutes and destroy it afterwards.


Everyone should be able to just grab the compute they need for the time they need it. Thus maximizing the return on investment on the shared hardware.


## Installation 

- When developing on the project I mostly do an ADD-MICROVM with a fresh Windows Server 2019 installation that has chocolatey already installed. Then I open an administrative shell and use the following script:

```powershell
choco install -y firefox vscode git.install tortoisegit
choco install -y visualstudio2019professional visualstudio2019-workload-netweb 
choco install -y nuget.commandline
choco install -y sql-server-management-studio
choco install -y sql-server-express
cd c:\
mkdir Projects
cd Projects
git clone https://github.com/stho32/MicroCloud.git
git clone https://github.com/stho32/MicroCloudApi.git
git clone https://github.com/stho32/MicroCloudCloudSidePS.git
git clone https://github.com/stho32/MicroCloudClientPS.git
Install-WindowsFeature -name Web-Server -IncludeManagementTools
Install-WindowsFeature -name Web-Asp-Net45
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Offline -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Online -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-Clients -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell -All -NoRestart

Restart-Computer
```
- create the database and database user

```powershell
C:\Projects\MicroCloud\Database\setup-or-migrate-database.sql
```

## Examples and Screenshots

### Drawing of the infrastructure in “external networking” mode : 

In external networking mode the users computers are placed outside of the microcloud network.


![external-networking-mode](https://user-images.githubusercontent.com/68638710/122115373-b2de7500-ce24-11eb-8452-954c633fa73f.png)

In external networking mode you have the advantage that the microcloud is more encapsulated.

What is done in the cloud “stays in the cloud” so e.g. the cloud internal ip addresses of the virtual computers are less interesting.

Users can only reach the virtual computers using their shared ports, which are explicitly arranged.

<br>

### drawing of the infrastructure in “internal networking” mode : 

In internal networking mode the users computers are placed inside the microcloud network.

This enables advanced usage scenarios e.g. developers can create images for virtual computers that contain test-databases, web hosts and so on. Every developer can then add copies to his own environment. He/she can list her/his own virtual computers with GET-MICROVm and sees the cloud internal ip address. Using this and ports that are open on the virtual computers firewalls they can connect and use them.

Since we have IP addresses here its much more easy to redirect access from production to test environment. Just add `192.168.88.xxx productionServerName` to your local hosts file and all traffic that you would normally throw at production becomes redirected to the test server(s).

![internal-networking-mode](https://user-images.githubusercontent.com/68638710/122115902-3b5d1580-ce25-11eb-8a90-eed5d7bbd186.jpg)


### Get a list of VMs currently running for you : 

![get-microvm-2020-03-12-202348](https://user-images.githubusercontent.com/68638710/122116018-6182b580-ce25-11eb-88bd-d89456bc777c.png)

With the cmdlet Get-MICROVm you can request a list of virtual machines that are currently running and connected to your api key. Every user of the microcloud gets an own api key.

## Documentation

You can find the full documentaion also [here](https://stho32.github.io/MicroCloud/)


## Contributions

Software contributions are welcome. If you are not a dev, testing and reproting bugs can also be very helpful!


