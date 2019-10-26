# MicroCloud

A micro Hyper-V cloud hold together by powershell and a sql server

## Why?

I want to have my own very small cloud system which I can use for different purposes. 

While researching for problems we had at work I found that Intel NUC systems have a nice performance and 32 GB of RAM which are within my financial reach (~1tsd. EUR for a node with 8 logical CPUs, 32GB RAM and 1Gig of disk space). I figured I could use those to create a little cloud that should be able to spawn linux and windows systems of my choice. 

Then I found out that the Hyper-V Server 2019 from Microsoft is actually free now. (Thanks for that!)

Of cause I do not want to simply use Hyper-V. I could do this from the start. But I want a hand full of commandlets and a database inmidst of it all to be able to comfortably control that micro-cloud. Also because it will probably used as a revolutionary item in an environment, where I can connect to the network but not to the domain. 

One of the ideas I have for the future is to build a small web app from which the vms then can be requested by everyone that needs one.

## Master

The master is the computer you control your micro hyper-v cloud. 

## Node

You have of cause several nodes in this environment. At the moment I have just one node available, but as soon as this concept works I may add a bunch of them and support e.g. trainings at work with it. Can't wait...