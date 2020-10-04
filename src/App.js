import React, { useState } from 'react';

import Game from './Pages/Game';
import Start from './Pages/Start';
import End from './Pages/End';

import './App.css';

function App() {
  const [route, setRoute] = useState('start');
  const [depth, setDepth] = useState('easy');
  const [winner, setWinner] = useState(null);
  const [pebbels, setPebbels] = useState(4);

  const Page = () => {
    switch (route) {
      case 'game':
        return <Game setWinner={setWinner} depth={depth} setRoute={setRoute} pebbels={pebbels} />;
      case 'end':
        return <End setWinner={setWinner} setRoute={setRoute} winner={winner} />;
      case 'start':
      default:
        return <Start setDepth={setDepth} setRoute={setRoute} setPebbels={setPebbels} />;
    }
  }

  return (
    <div className="App">
      <div id="board-wrapper">
        <Page />
      </div>
    </div>
  );
}

export default App;
