// http://172.18.119.223:3000
const express = require("express");
const mongoose = require("mongoose");
const path = require("path");
const config = require("config");
const app = express();

const port = process.env.PORT || 3001;

// Body Parser middleware
app.use(express.json({ limit: "5mb" }));

// connect to DB
mongoose
	.connect(process.env.MONGODB_URI || config.get("mongoURI"), {
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

app.listen(port, () => console.log(`Server started on port ${port}`));