/*
Facts of the Game
*/
:- dynamic settingsDepth/1.

/* Change player */
next_player(ai, player).
next_player(player, ai).

/* Set game difficulty */
settings(treeDepth, 1, easy).
settings(treeDepth, 3, medium).
settings(treeDepth, 5, hard).

/* Non-zero list means */
non_zero(X) :- X \== [0,0,0,0,0,0].

/* Zero list means */
zero([0,0,0,0,0,0]).

/* Set number of stones */
settings(stones, 1).

/* Set duration time */
settings(pauseDuration, 2).
