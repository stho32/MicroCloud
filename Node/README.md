# Node

The nodes of the system are actually simply Installations of Microsoft Hyper-V Server 2019 which can be obtained from the internet. 

To install a node manually use the following instructions:

## 1. on the node

  - [ ] You need to download the ISO of Hyper-V Server 2019 here (https://www.microsoft.com/de-de/evalcenter/evaluate-hyper-v-server-2019). This is a windows core server specialized for Hyper-V only. 
  - [ ] Use https://rufus.ie/ rufus to create a bootable usb stick for your node.
  - [ ] After the installation, there is sconfig running on the server. Using this you may activate remote desktop connections. I use this later if everything is falling apart. Actually I do not have many computers in my network, so its kinda an easy way to find all nodes. (I just look how many computers are there with remote desktop enabled).
  - [ ] start powershell on that node and type `Enable-PSRemoting`.
  
## 2. on the master

  - [ ] use this article to enable ps-remoting to that host from your "master": https://stackoverflow.com/questions/40248408/powershell-remoting-to-a-workgroup-computer

## 3. on the node again

  - [ ] connect to the node using Powershell-Remoting
  - [ ] install chocolatey on the node (you can copy this over into the Ps Session: `Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`)
  - [ ] through the Powershell Remoting session we won't be able to approve every package one by one. To be able to install software through choco we therefor need to execute the following statement: `choco feature enable -n allowGlobalConfirmation`
  - [ ] we need an easy way to make the powershell of this git repo available on the system, thus we install git : `choco install git.install`
  - [ ] we create a home directory and check out this repository there.
    - [ ] create a folder `C:\Projekte`, you can name it anyway you want. (That's my default project folder.)
    - [ ] run `git clone https://github.com/stho32/MicroCloud.git`

*(to be continued)*