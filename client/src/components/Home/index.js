import React from 'react';
/* import Button from '../Button'; */
import Table from '../Table';
import './style.css';
import API from '../../utils/api';
import socketApi from '../../utils/socketApi';
import socketIOClient from "socket.io-client";

var socket;
class Home extends React.Component {
    constructor() {
        super();
        this.state = {
            chat: []
        };
        let endpoint = 'http://i7590:3001/';
        socket = socketIOClient(endpoint);
      }

    handleChat = e => {
        e.preventDefault();
        const chatMessage = document.getElementById('input-chat');
        //socketApi.subscribeToChat(chatMessage);
        socket.emit('chat message', chatMessage.value);
        chatMessage.value = "";
    }

    recieveMessage = (msg) => {
        let chatHistory = this.state.chat;
        chatHistory.push(<li>{msg}</li>)
        this.setState({chat: chatHistory});
    }

    componentDidMount() {
        socket.on("chat message", this.recieveMessage);
        //socket.on("intercom message", this.recieveRecording);
    }

    render() {
        return(
            <div className="home container">
                <div className="chat-container">
                    <input type="text" id="input-chat"></input><button id="btn-chat" onClick={(e) => this.handleChat(e)}>Send</button>
                </div>
                <ul id="message-go-here">{this.state.chat}</ul>
            </div>
        )
    }
}

export default Home;