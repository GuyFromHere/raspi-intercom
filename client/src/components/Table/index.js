import React from 'react';
/* import Row from '../Row'; */
import './style.css'

class Table extends React.Component {
    constructor (props) {
        super(props)
        this.state = {
            messages: []
        }
    }

    playMessage = (id) => {
        console.log('length = ' + document.getElementById(id).duration);
        //document.getElementById(id).play();
        let progressBar = 0;
        const progress = document.getElementById(id).nextElementSibling.firstElementChild;
        // playback progress bar
        const timer = setInterval(() => {
            progress.style.width = `${progressBar}%`;
            progressBar += 25;
        }, 1000);

        setTimeout(() => {
            clearInterval(timer);
            document.getElementById(id).play();
        }, 5000);
    }

    render(props) {
        return (
            <div className="table-messages container">
                <table>
                    <tbody>
                    {this.props.passedMessages.length ? this.props.passedMessages.map(item => {
                        return (<tr key={item.id} className={item.played ? "played" : "unplayed"}>
                                <div className="row">
                                    {item.date}
                                {/* <td><audio controls src={item.message}>Play</audio></td> */}
                                    <i className="fas fa-play play" onClick={() => this.playMessage(item.id)}></i>
                                    <audio id={item.id} src={item.message}></audio>
                                    <div className="progress"><div className="progress-bar" ></div></div>
                                    <i className="fas fa-trash-alt" onClick={() => this.props.handleDelete(item.id)}></i>
                                </div>  
                            </tr>) 
                        }) : null
                    }
                    </tbody>
                </table>
            </div>
        )
    }
}

export default Table;