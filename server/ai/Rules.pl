%%%%%%%%%%%%%%%%%%%%%%%%
% AI move rules
%%%%%%%%%%%%%%%%%%%%%%%%

%choosing a move by alpha beta
choose_move(Position, _, Move, Depth) :-
	alpha_beta(Depth, Position, -1000, 1000, Move, _).

% move/2 for AI - creates moves
move(Board, [Index|Others]):-
	member(Index, [1,2,3,4,5,6]),
	get_stones_greater_than_zero(Index, Board, Stones),
	extra_move(Stones, Index, Board, Others).
move(board(H, _, _, _), []):- zero(H).

% if last stone doesn't land on a store-hole
extra_move(Stones, Index, _, []) :-
	Stones mod 13 =\= (7-Index), !.

% if last stone lands on a store-hole
extra_move(Stones, Index, Board, Others) :-
	Stones mod 13 =:= (7-Index) , !,
	distribute_stones(Stones, Index, Board, Board1),
	move(Board1, Others).


%%%%%%%%%%%%%%%%%%%%%%%%
% User move rules
%%%%%%%%%%%%%%%%%%%%%%%%

perform_user_move(UserMove,Position, Player, FinalPosition,ExtraTurn) :-
	extra_user_move(UserMove,Position,FinalPosition, Player,ExtraTurn).

% move/3 - preform move and return board
move([Index|Others], Position, FinalPosition) :-
	get_stones_greater_than_zero(Index, Position, Stones),
	distribute_stones(Stones, Index, Position, TmpPosition),
	move(Others, TmpPosition, FinalPosition).

% when no more moves, swap
move([], Position, FinalPosition) :-
	swap(Position, FinalPosition).

extra_user_move(Index, Position, Position1,Player, ExtraTurn):-
	get_stones_greater_than_zero(Index, Position, Stones),
	extra_user_move(Index, Stones,Position, Position1, Player, ExtraTurn).

% if last stone doesn't land on a store-hole
extra_user_move(Index,Stones, Position, Position1, Player, false) :-
	Stones  mod 13 =\= (7-Index),!,
	distribute_stones(Stones, Index, Position, Position1).

% if last stone lands on a store-hole
extra_user_move(Index, Stones, Position, Position1, Player, true) :-
	Stones mod 13 =:= (7-Index) , !,
	distribute_stones(Stones, Index, Position, Position1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Game Over
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

finished(board(L, _, L1, _)):-
	zero(L); zero(L1).

% no winner yet
game_over(board(B, Player1Score, B1, Player2Score), Player, null) :-
	not(finished(board(B, Player1Score, B1, Player2Score))).

% if game over on AI turn
game_over(board(B, Player2Score, B1, Player1Score), player1, player2) :-
	finished(board(B, Player2Score, B1, Player1Score)),
	Player2Score > Player1Score, !.
game_over(board(B, Player2Score, B1, Player1Score), player1, player1) :-
	finished(board(B, Player2Score, B1, Player1Score)),
	Player2Score < Player1Score, !.

% if game over on player turn
game_over(board(B, Player2Score, B1, Player1Score), player2, player2) :-
	finished(board(B, Player2Score, B1, Player1Score)),
	Player2Score > Player1Score, !.
game_over(board(B, Player2Score, B1, Player1Score), player2, player1) :-
	finished(board(B, Player2Score, B1, Player1Score)),
	Player2Score < Player1Score, !.

game_over(board(B, PlayerScore, B1, PlayerScore), _, draw):-
    finished(board(B, PlayerScore, B1, PlayerScore)).


% for AI
game_over(board(B, PlayerScore, B1, PlayerScore)) :-
	finished(board(B, PlayerScore, B1, PlayerScore)).

game_over(board(B, Player1Score, B1, Player2Score)) :-
	finished(board(B, Player1Score, B1, Player2Score)),
	Player1Score > Player2Score, !.

game_over(board(B, Player1Score, B1, Player2Score)) :-
	finished(board(B, Player1Score, B1, Player2Score)),
	Player2Score > Player1Score.
