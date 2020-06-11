const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const MessageSchema = new Schema({
	fileName: {
		type: String,
		required: false,
	},
	text: {
		type: String,
		required: false
	},
	type: {
		type: String,
		required: true,
	},
});

const Message = mongoose.model("Message", MessageSchema);

module.exports = Message;