
// socket.io code
import openSocket from 'socket.io-client';
const socket = openSocket('http://localhost:3001');

function subscribeToChat(cb) {
    console.log('socketApi')
    socket.on('chat', msg => cb(msg));
    socket.emit('subscribeToChat');
}

export default { subscribeToChat };