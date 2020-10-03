import React, { useContext } from 'react';
import cn from 'classnames';
import { GameContext } from './Context';

import './PlayerPit.scss';

function PlayerPit({ side }) {
    const { score } = useContext(GameContext);

    return (
        <div className={cn('player-pit', 'player-pit-' + side)}>
            <span>{score[side]}</span>
        </div>
    );
}

export default PlayerPit;