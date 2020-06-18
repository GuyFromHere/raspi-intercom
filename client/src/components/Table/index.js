import React from 'react';
import Row from '../Row';
import API from '../../utils/api';
import './style.css'

class Table extends React.Component {
    constructor () {
        super()
        this.state = {
            messages: []
        }

    }

    componentDidMount(){
        // get messages from DB and put them in the table with renderTable()
        API.getMessages().then(result => {
            console.log('TABLE COMPONENT call getMessages:');
            console.log(result.data)
            this.setState({messages: result.data}) 
            console.log('TABLE COMPONENT get state:')
            console.log(this.state.messages)
        })
    }

    render() {
        return (
            <div className="table-messages">
                <h3>Table of messages</h3>
                <table>
                    {this.state.messages ? this.state.messages.map(item => {
                        return (<tr className={item.played}>
                            <td>{item.date}</td>
                            <td><audio controls src={item.message}>Play</audio></td>
                            </tr>) 
                        }) : null
                    } 
                </table>
            </div>
        )
    }
}

export default Table;