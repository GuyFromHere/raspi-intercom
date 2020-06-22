# raspi-intercom

Voice intercom system connecting two raspberry pis

# Description

My in laws built a house next door. We share a mesh wifi system between both houses. In my house we use the Amazon Echo "announce" feature frequently to rouse children from bed, let them know when dinner is ready or chores need doing, etc. My in laws don't want to put an Echo in their house but we still want a convenient method for communicating between the houses. I had a few old raspberry pis lying around and I thought it would be a fun project to design some kind of intercom system with them. It's a very specific use case but I'm making it public in hopes that it helps someone else with their project someday.

The goal is to create a simple React web page with a Node / Mongo backend. Both Pis will use the official Raspberry Pi [touchscreen](https://www.raspberrypi.org/products/raspberry-pi-touch-display/) (I haven't bought these yet!). Connecting to the web page from one Pi, you can record a short message that will be added to the other Pi's homepage via web sockets and saved to the database so it can be listened to at a later date. The Pis will authenticate with the web page and their messages will be retrieved by an account ID. 

The initial implementation will work like a voice mail box. Messages are posted to a web page that updates periodically and users will have to check the page for updates. Eventually I want it to work like a real analog intercom playing the messages in real time as they are recorded -- but also saving them so they can be replayed and deleted as desired. Since it will all be running on the same network you won't have to be standing at the Pi to send a message. You can use your phone as long as it's on the wifi.

Again, it's a very specific use case. But it was fun! I hope to make it more useful over time. 

# Instructions 

## Set up dev environment

For my development environment I'm using Hyper-V with two VMs running Raspbian Buster to simulate the hardware I'll be using. I am running them and the Node server from my laptop. The downside to using Linux VMs for this project is that I have not figured out how to passthrough a microphone. This means the MediaRecorder API does not load because it can't find a media device. And therefore, it's impossible to test the app on the dev VMs. So **I do not recommend using VMs.** They were helpful when I was getting everything set up initially, but as soon as I had a functioning prototype I had to switch to actual physical Pis. 

That being said, I've included the scripts I used to deploy the VMs for posterity. To provision the VMs and virtual switches I wrote the powershell script in **setup/Create-RaspbianVm.ps1**. Run it in an elevated window and it will pull in the included helper functions so long as they are all located in the same directory. All the properties for the VMs and the switches are defined in the top part of the script. Before running make sure you edit these to suit your own needs. Since I'm using my laptop I had to create internal virtual switches with a static NAT then set static IPs on the VMs. My home network is a Class A 10.x.x.x. so VM1 has an IP of 10.1.0.2 with a gateway of 10.1.0.1 (also the IP of the NAT interface). VM2 has an IP of 10.2.0.2 with a gateway of 10.2.0.1 (the IP of that NAT interface). 

In Raspbian Buster you need to set the static ip in **/etc/dhcpcd.conf**. In prior versions of Raspbian it was in /etc/interfaces so be aware that this could change depending on the build.

If you don't use VMs you can check out the instructions in **setup/Setup-Raspbian.md** for the steps I took to configure the Pis after installing them. Once SSH is enabled you can pretty much copy and paste all the code snippets and you'll be all set. 

# Technology Used

Node
MongoDB
React 
MediaRecorder API
WebSockets API
PowerShell
Raspbian Buster
Hyper-V

# Development Roadmap

Stage 1: 

Two pis running a database app with a simple React UI displayed on a touchscreen

The UI has functionality to select one or more devices (can also be used on a phone to send messages to both devices at once)

User selects which device dbs they want to broadcast to then clicks the record button

They have five or ten seconds to record a message

The device listening to that database updates its state to show that there are un-heard messages

A listener can listen to a message and mark it for deletion

Stage 2:

Websockets for real time messaging via the phone UI

Physical buttons on the pis so they act like analog intercoms
