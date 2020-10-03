import React from 'react';
import Board from '../components/Board';

import './Game.scss';

function Game({ depth, setRoute, setWinner, pebbels }) {
    return (
        <Board depth={depth} setWinner={setWinner} setRoute={setRoute} pebbels={pebbels}  />
    );
}

export default Game;