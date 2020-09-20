import React, { useContext } from 'react';
import cn from 'classnames';
import { GameContext } from './Context';

import Pebble from './Pebble';

import './PlayerPit.scss';

function PlayerPit({ side }) {
    const { board,
        score,
        playerTurn,
        setBoard,
        setScore,
        setPlayerTurn } = useContext(GameContext);

    return (
        <div className={cn('player-pit', 'player-pit-' + side)}>
            <span>{score[side]}</span>
        </div>
    );
}

export default PlayerPit;