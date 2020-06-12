import axios from "axios";

export default {
    // Get all messages from the database.
    getMessages: function () {
        console.log('client api getMessages')
        return axios.get('/api/message');
    },
    // Send a new message to the destination database.
    sendMessage: function (message) {
        return axios.post('/api/message/send', message)
    },
    // Clear a message once it has been listened to.
    deleteMessage: function (id) {
        return axios.post('/api/message/' + id)
    }
}