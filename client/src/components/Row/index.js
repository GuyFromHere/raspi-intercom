import React from 'react';
import Button from '../Button';

class Row extends React.Component {
    constructor(props) {
        super(props)
        console.log('ROW');
    }

    handleDelete = (id) => {
        console.log('row component delete id = ' + this.id);
    }

    render() {
        return (
            <tr className={this.props.played}>
                <td>{this.props.date}</td>
                <td><audio src={this.props.message}></audio></td>
                <td><Button id={this.props.id} className="delete" onClick={this.handleDelete(this.props.id)}>DELETE</Button></td>
            </tr>
        )
    }
}

export default Row;