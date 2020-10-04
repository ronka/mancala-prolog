import React, { useContext, useEffect, useState } from 'react';
import cn from 'classnames';
import { GameContext } from './Context';

import './Pit.scss';

function Pit({ index, value, playTurn }) {
    const { board,
        score,
        playerTurn,
        setBoard,
        setScore } = useContext(GameContext);

    const [pebbelsCnt, setPebbelsCnt] = useState(board[index]);

    let isDisabled = true;
    
    if( playerTurn && index < 6 ) {
        isDisabled = false;
    }

    const isPitEmpty = pebbelsCnt === 0

    /* eslint-disable react-hooks/exhaustive-deps */
    useEffect(() => {
        setPebbelsCnt(board[index])
        setBoard(board);
        setScore(score);
    }, [playerTurn])
    /* eslint-enable react-hooks/exhaustive-deps */

    return (
        <button
            className={cn(
                "pit",
                "pit-" + index,
                { 'pit-empty': isPitEmpty },
                { 'pit-disabled': isDisabled }
            )}
            onClick={() => playTurn(index, value)}
            disabled={isDisabled}
        >
            <span>{value}</span>
            {/* {pebbels} */}
        </button>
    );
}

export default Pit;