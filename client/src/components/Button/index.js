import React from 'react';
import './style.css';


class Button extends React.Component {
    constructor(props){
        super(props)
    }
    render(props) {
        return (
            <button {...this.props}>{this.props.children}</button>
        )
    }
}

export default Button;