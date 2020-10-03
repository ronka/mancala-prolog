import React from 'react';
import axios from 'axios';

import './Start.scss';

function Start({ setRoute, setDepth, setPebbels }) {

    const onClick = async (e, depth) => {
        e.preventDefault();

        // set how many pebbels in each pit
        await axios.get('/play').then( ({data}) => setPebbels(data.board[0]) )

        setDepth(depth);
        setRoute('game');
    }

    return (
        <div id="start-page">
            <h1>Mancala</h1>
            <h3>Powered by Prolog</h3>
            <p>Made By Ron Kantor & Avishag Shapira</p>
            <div id="diffucility">
                <h3>Choose The Diffucility And Start The Game</h3>
                <button onClick={ (e) => { onClick(e, 'easy') } }>Easy 😇</button>
                <button onClick={ (e) => { onClick(e, 'medium') } }>Medium 😁</button>
                <button onClick={ (e) => { onClick(e, 'hard') } }>Hard 😈</button>
            </div>
            <div id="footer">
                <a href="https://www.ymimports.com/pages/how-to-play-mancala" target="_blank">How to play 🎓</a>
            </div>
        </div> 
    );
}

export default Start;