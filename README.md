# raspi-intercom

Voice intercom system connecting two raspberry pis

# Description

My in laws built a house next door. We bought a mesh wifi system to share our internet connection and we would like to have a convenient and efficient method of communicating between the houses. 

My tentative plan is to build a Node application that runs on two raspberry pis connected to the same network. A user can record a short message and send it to the other pi's "inbox" where it can be played back, saved, or deleted. There will need to be some kind of user interface eventually...probably a small touchscreen. I haven't gotten that far in the planning stages yet. Alternatively I could look in to something like web sockets to send a message in real time like a genuine analog intercom but I thought recording a message would be as easier place to start. I guess we'll find out pretty soon if I was right!

# Workflow

Pi A resides in House A. Use connects to local server running on that device and records a message. Pi A connects to the DB server on Pi B and uploads the message. Pi B's state changes to show the message waiting to be heard / read.