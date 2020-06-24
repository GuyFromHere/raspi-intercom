import React from 'react';

class Login extends React.Component {
    render() {
        return (
            <div className="login-container">
                <form id="login-form">
                    <label for="login-username">Username:</label>
                    <input id="login-username" type="text"></input>
                    <label for="login-password">Password:</label>
                    <input id="login-password" type="text"></input>
                </form>
            </div>
        )
    }
}

export default Login;