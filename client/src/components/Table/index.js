import React from 'react';
/* import Row from '../Row'; */
import API from '../../utils/api';
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
        document.getElementById(id).play();
    }

    /* deleteMessage = (id) => {
        console.log('Table delete message id');
        console.log(id)
        API.deleteMessage(id).then((result) => {
            console.log('Table delete message result');
            console.log(result);
            //this.refreshMessages();
            API.getMessages().then(result => {
                this.setState({messages: result.data}) 
            })
        });
    } */

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
                    {this.props.passedMessages ? this.props.passedMessages.map(item => {
                        return (<tr key={item.id} className={item.played ? "played" : "unplayed"}>
                            <td>{item.date}</td>
                            {/* <td><audio controls src={item.message}>Play</audio></td> */}
                            <td>
                                <audio id={item.id} src={item.message}></audio>
                                <button onClick={() => this.playMessage(item.id)}>Play</button> 
                                <button onClick={() => this.props.handleDelete(item.id)}>Delete</button>
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