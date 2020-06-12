# raspi-intercom

Voice intercom system connecting two raspberry pis

# Description

My in laws built a house next door. We bought a mesh wifi system to share our internet connection and we would like to have a convenient and efficient method of communicating between the houses. 

My plan is to start with the pieces I think I can accomplish with my current skills and build out the features I really want after I have a functional solution.

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
