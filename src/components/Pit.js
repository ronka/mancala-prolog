import React, { useContext, useEffect, useState, useMemo } from 'react';
import cn from 'classnames';
import Pebble from './Pebble';
import { GameContext } from './Context';

import './Pit.scss';

function Pit({ index, value, playTurn }) {
    const { board,
        score,
        playerTurn,
        setBoard,
        setScore } = useContext(GameContext);

    const [pebbelsCnt, setPebbelsCnt] = useState(board[index]);

    let pebbels = getPebbels(pebbelsCnt);

    const isDisabled = !((6 / (index + 1)) >= 1) === playerTurn
    const isPitEmpty = pebbelsCnt === 0

    useEffect(() => {
        setPebbelsCnt(board[index])
        setBoard(board);
        setScore(score);
    }, [playerTurn])

    useEffect(() => {
        pebbels = getPebbels(pebbelsCnt);
    }, [pebbelsCnt])

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

function getPebbels(cnt) {
    let pebbles = [];

    for (let i = 0; i < cnt; i++) {
        pebbles.push(<Pebble key={i} index={i} />);
    }

    return pebbles;
}

export default Pit;