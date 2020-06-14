# raspi-intercom

Voice intercom system connecting two raspberry pis

# Description

My in laws built a house next door. We bought a mesh wifi system to share our internet connection and we would like to have a convenient and efficient method of communicating between the houses. 

My plan is to start with the pieces I think I can accomplish with my current skills and build out the features I really want after I have a functional solution.

# Instructions 

## Set up dev environment

For my development environment I'm using Hyper-V with two VMs running Raspbian Buster to simulate the hardware I'll be using. I am running them and the Node server from my laptop. This means I need to set up virtual switches with a static NAT so they can use my wireless card without disrupting my internet connection. The alternative would be using an internal switch bound to a spare NIC. That could work if I stayed at my desk at all times, but I like to work from my couch. There's better dog-snuggling over there. 

To provision the VMs and switches I wrote the powershell script in **setup/Create-RaspbianVm.ps1**. All the properties for the VMs and the switches are defined in the top part of the script. Before running make sure you edit these to suit your own needs. 

The VMs will boot to the specified Raspbian ISO when the script finishes. You'll need to walk through the installer and configure the static IPs to match the given subnet. 

In Raspbian Buster you need to set a static ip in **/etc/dhcpcd.conf**. Make sure you're setting it on the correct interface! eth0 should be assigned to the private switch since that's the one we're attaching in the New-VM command. eth1 is the one that needs a static IP on your NAT switch. I've included a script that will auto create a new dhcpcd.conf file on a mounted Raspbian image in WSL2. If you don't have WSL2 (or access to any other means to mount, edit, then convert the img file) you will have to manually change the file after installing Raspbian.

# Basic functionality

Stage 1: 

Two pis running a database app with a simple React UI displayed on a touchscreen

The UI has functionality to select one or more devices (can also be used on a phone to send messages to both devices at once)

User selects which device dbs they want to broadcast to then clicks the record button

They have five or ten seconds to record a message

When they take their hand off the button the message is posted to the target database

The device listening to that database updates its state to show that there are un-heard messagesT

A listener can listen to a message and mark it for deletion

Stage 2:

Websockets for real time messaging via the phone UI

Physical buttons on the pis so they act like analog intercoms
