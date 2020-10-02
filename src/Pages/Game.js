import React from 'react';
import Board from '../components/Board';

import './Game.scss';

function Game({ depth, setRoute, setWinner }) {
    return (
        <Board depth={depth} setWinner={setWinner} setRoute={setRoute}  />
    );
}

export default Game;