# Setting up a dev pc

When developing on the project I mostly do an ADD-MICROVM with a fresh Windows Server 2019 installation that has chocolatey already installed. Then I open an administrative shell and use the following script:

## install all the software needed

```powershell
choco install -y firefox vscode git.install tortoisegit
choco install -y visualstudio2019professional visualstudio2019-workload-netweb 
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

## create the database and database user

```powershell
C:\Projects\MicroCloud\Database\setup-or-migrate-database.sql
```

