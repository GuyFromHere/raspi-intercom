import React from 'react';
import Button from '../Button';
import './style.css';
import API from '../../utils/api';

class Home extends React.Component {

    handleClick = () => {
        console.log('home handle click')
        console.log(' send a recording to other pi...')
        API.getMessages().then( result => {
            console.log(result);
        });
    }

    render() {

        return(
            <div className="home">
                <p>
                    Test page...
                    Create a simple upload button to test triggering record function.
                </p>
                <Button className="button" onClick={this.handleClick}>CLICK ME TO RECORD</Button>
            </div>
        )
    }
}

export default Home;