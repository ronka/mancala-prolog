import React from 'react';

import './End.scss';

function End({ setWinner, setRoute, winner }) {
    const Title = () => {
        if (winner === 'player') {
            return (
                <h1>You Won The Game! 🎉</h1>
            )
        } else if (winner === 'ai') {
            return (
                <h1>The AI Won! 🤖</h1>
            )
        } else {
            return (
                <h1>It Was A Draw! 🔥</h1>
            )
        }
    }

    return (
        <div id="end-page">
            <Title />
            <button onClick={(e) => {
                setRoute('start'); setWinner(null)
            }}>Play Again</button>
        </div>
    );
}

export default End;