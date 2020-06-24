
const express = require("express");
const mongoose = require("mongoose");
const path = require("path");
const config = require("config");
const app = express();
const http = require('http').createServer(app);
const io = require('socket.io')(http);

const port = process.env.PORT || 3001;

// socket.io section
io.on('connection', (socket) => {

    console.log('a user connected');

    socket.on('disconnect', () => {
        console.log('user disconnected');
    });

    
    // Get chat message and broadcast it to the client
    // io.emit('chat message', msg); will send the message to all connected clients
    // socket.broadcast.emit('chat message', msg); Will exclude the sender when returning result to clients 
    socket.on('chat message', (msg) => {
        console.log('server message: ' + msg);
        io.emit('chat message', msg);
        //socket.broadcast.emit('chat message', msg);
    });

    // Gets base64 encoded message data from the client and broadcasts it
    // Find a way to broadcast to specific clients...i.e. send user id in msg object from client
    // Probably need to figure out authentication first.
    socket.on('intercom message', (msg) => {
        console.log('intercom msg received. Now broadcasting');
        //console.log(msg);
        // use io.emit for testing:
        //socket.broadcast.emit('intercom message', msg);
        io.emit('intercom message', msg);
    });
});


// normal express section
// Body Parser middleware
// Limit the size of the body to 5mb
app.use(express.json({ limit: "5mb" }));

// connect to DB
mongoose.connect(process.env.MONGODB_URI || config.get("MONGODB_URI"), {
		useNewUrlParser: true,
		useCreateIndex: true,
		useUnifiedTopology: true,
	})
	.then(() => console.log("mongodb connected"))
	.catch((err) => console.log(err));

// use routes
app.use("/api/message", require("./routes/message_api"));

// Server static assets if we're in production
if (process.env.NODE_ENV === "production") {
	// Exprees will serve up production assets
	app.use(express.static(path.join(__dirname, "client/build")));

	// Express serve up index.html file if it doesn't recognize route
	app.get("*", (req, res) => {
		res.sendFile(path.join(__dirname, "client", "build", "index.html"));
	});
}

// app.listen(port, () => {
http.listen(port, () => {
  console.log(`listening on *:${port}`);
});