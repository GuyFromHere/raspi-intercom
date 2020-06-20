import React from 'react';
import Row from '../Row';
import API from '../../utils/api';
import './style.css'

class Table extends React.Component {
    constructor (props) {
        super(props)
        console.log('table props');
        console.log(props)
        this.state = {
            messages: []
        }
    }

    playMessage = (id) => {
        console.log('playing ' + id);
        console.log('length = ' + document.getElementById(id).duration);
        document.getElementById(id).play();
        
    }

    refreshMessages = () => {
        // get messages from DB and put them in the table with renderTable()
        API.getMessages().then(result => {
            this.setState({messages: result.data}) 
        })
    }

    componentDidMount(){
        this.refreshMessages();
    }

    render(props) {
        return (
            <div className="table-messages">
                <table>
                    <tbody>
                    {//this.state.messages ? this.state.messages.map(item => {
                    //    return (<tr key={item._id} className={item.played ? "played" : "unplayed"}>
                    //        <td>{item.date}</td>
                    //        {/* <td><audio controls src={item.message}>Play</audio></td> */}
                    //        <td>
                    //            <audio id={item._id} src={item.message}></audio>
                    //            <button onClick={() => this.playMessage(item._id)}>Play</button> 
                    //        </td>
                    //        </tr>) 
                    //    }) : null
                    }
                    {this.props.passedMessages ? this.props.passedMessages.map(item => {
                        return (<tr key={item._id} className={item.played ? "played" : "unplayed"}>
                            <td>{item.date}</td>
                            {/* <td><audio controls src={item.message}>Play</audio></td> */}
                            <td>
                                <audio id={item._id} src={item.message}></audio>
                                <button onClick={() => this.playMessage(item._id)}>Play</button> 
                            </td>
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