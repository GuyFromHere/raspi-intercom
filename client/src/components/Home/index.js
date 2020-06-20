import React from 'react';
import Button from '../Button';
import Table from '../Table';
import './style.css';
import API from '../../utils/api';

class Home extends React.Component {
    constructor() {
        super();
        this.state = {
          messages: []
        };
      }

    getBase64Audio = (file) => {
        console.log('I am not a function')
        var reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onloadend = () => {
            var base64data = reader.result;
            console.log(base64data);
        }
    }

    updateTable = (messages) => {
        this.setState({messages: messages.data}) 
    }

    componentDidMount() {
        const record = document.querySelector('#record');
        //const play = document.querySelector('.play');
        const stopBtn = document.querySelector('#stop');
        //const soundClips = document.querySelector('.sound-clips');
        // Array to hold the audio chunks
        let chunks = [];
        const constraints = { audio: true };

         // get microphone and create mediarecorder when the page loads
         navigator.mediaDevices.getUserMedia(constraints).then(stream => {
            const mediaRecorder = new MediaRecorder(stream);

            // Start recording when the record button is clicked
            // Stop automatically after five seconds.
            record.onclick = () => {
                mediaRecorder.start();
                setTimeout(function() {
                    mediaRecorder.stop();
                }, 5000);     
            }

            // Process audio when the recording stops
            mediaRecorder.onstop = (e) => {
                var blob = new Blob(chunks, { 'type' : 'audio/ogg; codecs=opus' });
                chunks = [];
                // Use FileReader to convert the blob data to base64 so we can store it as a string
                let reader = new FileReader();
                reader.readAsDataURL(blob);
                reader.onloadend = () => {
                    const base64data = reader.result;
                    // send the recording to the API
                    API.sendMessage(base64data).then(() => {
                        console.log('home sendMessage');
                        API.getMessages().then(result => {
                            console.log('home getMessages')
                            this.updateTable(result);
                        })
                    });
                }
            }

            mediaRecorder.ondataavailable = (e) => {
               chunks.push(e.data);
               
            }
        }).catch(function(err) {
            console.log('The following error occurred: ' + err);
        });

        API.getMessages().then(result => {
            this.setState({messages: result.data})
        })
    }

    render() {

        return(
            <div className="home">
                <div className="control-container">
                    <span>Click to Record:</span>
                    <button id="record" className="control" onClick={this.startRecord}></button>
                </div>
                <Table passedMessages={this.state.messages}/>
            </div>
        )
    }
}

export default Home;