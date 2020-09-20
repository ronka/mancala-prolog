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
	
	const fetchPlay = () => {
		axios.post('/difficulty/10', {
			firstName: 'Fred',
			lastName: 'Flintstone'
		})
		.then(function (response) {
			console.log(response);
		})
		.catch(function (error) {
			console.log(error);
		});
	}

    const playTurn = async (index, count) => {
		await fetchPlay();

        board[index] = 0;

        for (let i = 1; i <= count; i++) {
            index++;
            if (playerTurn) {
                if (index >= 12) {
                    score.right += 1;
                    count--;

                    index = 0
                }

                board[index] += 1;
            } else {
                if (index === 6) {
                    score.left += 1;
                    count--;
                }

                if (index >= 12) {
                    index = 0
                }

                board[index] += 1;
            }
        }


        setPlayerTurn(!playerTurn);
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