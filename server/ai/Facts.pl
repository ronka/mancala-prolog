/*
Facts of the Game
*/
:- dynamic settingsDepth/1.


/* Non-zero list means */
non_zero(Hs) :- Hs \== [0,0,0,0,0,0].

/* Zero list means */
zero([0,0,0,0,0,0]).

/* Set game difficulty */
settings(treeDepth, 1, easy).
settings(treeDepth, 3, medium).
settings(treeDepth, 5, hard).



/* Set number of stones */
settings(stones, 1).

/* Set duration time */
settings(pauseDuration, 2).

/* Change player */
next_player(player1, player2).
next_player(player2, player1).
