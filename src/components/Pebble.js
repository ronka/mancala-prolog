import React from 'react';

import './Pebble.scss';

function Pebble({ index }) {
    const plusOrMinus = () => index % 2 ? -1 : 1;

    const getRandomMove = () => plusOrMinus() * index * 5;

    return (
        <div className="pebble" style={{
            top: (35 + getRandomMove()) + "%",
            // marginBottom: getRandomMove(),
            left: (40 + getRandomMove()) + "%",
        }}> </div>
    );
}

export default Pebble;

function getRandomInt(max) {
    return Math.floor(Math.random() * Math.floor(max));
}