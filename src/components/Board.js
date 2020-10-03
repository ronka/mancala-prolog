import React, { useState } from 'react';
import axios from 'axios';
import cn from 'classnames';
import Pit from './Pit';
import PlayerPit from './PlayerPit';
import { GameContext } from './Context';

import './Board.scss';

function Board({ depth, setRoute, setWinner, pebbels }) {
    const [board, setBoard] = useState((new Array(12)).fill(pebbels));
    const [score, setScore] = useState({ 'left': 0, 'right': 0 });
    const [playerTurn, setPlayerTurn] = useState(true);
    const [aiMoves, setAiMoves] = useState([]);
    const [loading, setLoading] = useState(false);

    const contextValue = {
        'board': board,
        'score': score,
        'playerTurn': playerTurn,
        'setBoard': setBoard,
        'setScore': setScore,
        'setPlayerTurn': setPlayerTurn
    }

    const playTurn = async (index, count) => {
        setLoading(true)
        await axios.post('/move', {
            'board': [...board.slice(0, 6), score.left, ...board.slice(6, 13), score.right],
            'depth': depth,
            'move': (index + 1)
        }).then(async ({ data }) => {
            (async () => {
                for (let i = 0; i < data.board.length; i++) {
                    setScore({
                        'left': data.board[i].slice(6,7)[0],
                        'right': data.board[i].slice(13,14)[0]
                    });

                    setBoard([...data.board[i].slice(0, 6), ...data.board[i].slice(7, 13)]);

                    if (!data.player.extraTurn && !data.winner) {
                        setPlayerTurn(false);
                        if (i !== data.board.length - 1) {
                            await timer(1500);
                        }
                    }
                }

                setAiMoves(data.ai.moves)
                setPlayerTurn(true);
                setLoading(false);

                if (data.winner) {
                    const latestBoard = data.board.pop()
                    console.log(latestBoard);
                    setTimeout(() => {
                        alert(`Score:${latestBoard.slice(6,7)[0]} - ${latestBoard.slice(13,14)[0]}`);
                    }, 300);
                    await timer(1500);
                    setWinner(data.winner);
                    setRoute('end');
                }
            })();
        }).catch(function (error) {
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

    const Title = () => {
        console.log(loading);
        return(
        <h1>
            { playerTurn ? "Your Turn" : "AI Turn" }
            { loading && ( <img alt="loading" src="images/loading.gif" />) }
        </h1>
    )}
    
    return (
        <GameContext.Provider value={contextValue}>
            <div id="board" className={cn(
                { "ai-turn": !playerTurn }
            )}>
                <Title />
                <PlayerPit side="left" />
                {setPits()}
                <PlayerPit side="right" />
                {
                    aiMoves.length > 0 && 
                        <div id="ai-moves">
                            AI Played pit { aiMoves.join(' and than ') }
                        </div>
                }
            </div>
        </GameContext.Provider>
    );
}

export default Board;

function timer(ms) { return new Promise(res => setTimeout(res, ms)); }