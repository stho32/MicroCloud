# MicroCloud

A micro Hyper-V cloud hold together by powershell

## Why?

I want to have my own very small cloud system which I can use for different purposes. 

While researching for problems we had at work I found that Intel NUC systems have a nice performance and 32 GB of RAM which are within my financial reach (~1tsd. EUR for a node with 8 logical CPUs, 32GB RAM and 1Gig of disk space). I figured I could use those to create a little cloud that should be able to spawn linux and windows systems of my choice. 

Then I found out that the Hyper-V Server 2019 from Microsoft is actually free now. (Thanks for that!)

Of cause I do not want to simply use Hyper-V. I could do this from the start. But I want a hand full of commandlets to be able to comfortably control that micro-cloud. 

## Master

The master is the computer you control your micro hyper-v cloud. 
Images are created on this computer and distributed into the cloud. 

This system is installed with a Windows Server 2019 (Standard) as Domain Controller and Hyper-V server. It happens to be the visual interface into the "cloud". And the computer I write all those scripts at this time. 

## Node

You have of cause several nodes in this environment. They are all the same - Microsoft Hyper-V 2019 Servers.



### Entrance Router Config (MikroTik rb951g-2HnD)

```
# jan/02/1970 00:24:18 by RouterOS 6.40.4
# software id = 82QZ-DS00
#
# model = 951G-2HnD
# serial number = 8A7008DD3EE3
/interface wireless
set [ find default-name=wlan1 ] ssid=MikroTik
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp_pool1 ranges=192.168.1.2-192.168.1.254
/ip dhcp-server
add address-pool=dhcp_pool1 disabled=no interface=ether2 lease-time=3d name=dhcp1
/ip address
add address=192.168.1.1/24 interface=ether2 network=192.168.1.0
/ip dhcp-client
add dhcp-options=hostname,clientid disabled=no interface=ether1
/ip dhcp-server network
add address=192.168.1.0/24 dns-server=4.2.2.2 gateway=192.168.1.1
/ip dns static
add address=192.168.88.1 name=router.lan
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/system identity
set name=EntranceRouter
/system ntp client
set enabled=yes primary-ntp=50.19.122.125

```
