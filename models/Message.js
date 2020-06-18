const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const MessageSchema = new Schema({
	// messageUri stores the Base64 encoded binary stream data 
	message: {
		type: String,
		required: true,
	},
	date: {
		type: Date,
		required: true,
		default: Date.now
	},
	played: {
		type: Boolean,
		required: true,
	},
});

const Message = mongoose.model("Message", MessageSchema);

module.exports = Message;