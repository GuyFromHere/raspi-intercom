import React from 'react';
import Home from './components/Home';
import Login from './components/Login';
import { BrowserRouter as Router, Route } from "react-router-dom";

function App() {
	return (
		<div className="App">
			<Router>
				<Route path="/login" component={Login} />
				<Route path="/" component={Home} />
			</Router>
		</div>
  	);
}

export default App;
