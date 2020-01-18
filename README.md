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