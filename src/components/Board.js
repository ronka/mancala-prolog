import React, { useState } from 'react';
import axios from 'axios';
import cn from 'classnames';
import Pit from './Pit';
import PlayerPit from './PlayerPit';
import { GameContext } from './Context';

import './Board.scss';

function Board() {
    const [board, setBoard] = useState((new Array(12)).fill(4));
    const [score, setScore] = useState({ 'left': 0, 'right': 0 });
    const [playerTurn, setPlayerTurn] = useState(true);

    const contextValue = {
        'board': board,
        'score': score,
        'playerTurn': playerTurn,
        'setBoard': setBoard,
        'setScore': setScore,
        'setPlayerTurn': setPlayerTurn
    }

    const playTurn = async (index, count) => {
        await axios.post('/move', {
            'board': [...board.slice(0, 6), score.left, ...board.slice(6, 13), score.right],
            'move': (index + 1)
        })
        .then(function ({ data }) {
            const newBoard = data.board.pop()
            setScore({
                left: newBoard.splice(6,1)[0],
                right: newBoard.pop()
            })
            setBoard(newBoard);
		})
        .catch(function (error) {
            console.log(error);
        });

        // setPlayerTurn(!playerTurn);
    }

    const setPits = () => board.map((count, index) => <Pit
        key={index}
        index={index}
        value={count}
        playTurn={playTurn}
    />)

    const turnTitle = playerTurn ? <h1>Your Turn</h1> : <h1>AI Turn<img src="images/loading.gif" /></h1>

    return (
        <GameContext.Provider value={contextValue}>
            <div id="board-wrapper" className={cn(
                { "ai-turn": !playerTurn }
            )}>
                {turnTitle}
                <PlayerPit side="left" />
                {setPits()}
                <PlayerPit side="right" />
            </div>
        </GameContext.Provider>
    );
}

export default Board;

function rightPlayerMove(index, board) {

}