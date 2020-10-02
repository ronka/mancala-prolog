import React, { useState } from 'react';
import axios from 'axios';
import cn from 'classnames';
import Pit from './Pit';
import PlayerPit from './PlayerPit';
import { GameContext } from './Context';

import './Board.scss';

function Board({ depth, setRoute, setWinner }) {
    const [board, setBoard] = useState((new Array(12)).fill(1));
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
            'depth': depth,
            'move': (index + 1)
        })
        .then(async ({ data }) => {
            (async () => {
                for (let i = 0; i < data.board.length; i++) {
                    
                    setScore({
                        'left': data.board[i].splice(6, 1)[0],
                        'right': data.board[i].pop()
                    });
                    setBoard(data.board[i]);

                    if( ! data.player.extraTurn && ! data.winner ) {
                        setPlayerTurn(false);
                        if( i !== data.board.length - 1 ) {
                            await timer(1500);
                        }
                    }
                }

                if( data.winner ) {
                    setWinner( data.winner );
                    console.log(score);
                    setRoute('end');
                }

                console.log('ai moves', data.ai.moves);
                setPlayerTurn(true);
            })();
        })
        .catch(function (error) {
            alert('אופס משהו השתשבש! נא להתחיל את השרת מחדש ולרענן')
            console.log(error);
        });
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
            <div id="board" className={cn(
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

function timer(ms) { return new Promise(res => setTimeout(res, ms)); }