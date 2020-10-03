%%%%%%%%%%%%%%%%%%%%%%%%
% AI move rules
%%%%%%%%%%%%%%%%%%%%%%%%

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



%%%% CLI extra user move

choose_and_perform_move_user(Position, Player, Position1) :-
	extra_user_move_cli(Position,Position1, Player).

extra_user_move_cli(Position, Position,_):-finished(Position),!.
extra_user_move_cli(Position, Position1,Player):-
	get_move(Index),
	get_stones_greater_than_zero(Index, Position, Stones),
	extra_user_move_cli(Index, Stones,Position, Position1, Player).

% if last stone doesn't land on a store-hole
extra_user_move_cli(Index,Stones, Position, Position1, Player) :-
	Stones  mod 13 =\= (7-Index),!,
	distribute_stones(Stones, Index, Position, Position1),
	swap(Position1, Position2),
	display_game(Position2, Player).

% if last stone lands on a store-hole
extra_user_move_cli(Index, Stones, Position, Position3, Player) :-
	Stones mod 13 =:= (7-Index) , !,
	distribute_stones(Stones, Index, Position, Position1),
	swap(Position1, Position2),
	display_game(Position2, Player),
	extra_user_move_cli(Position1, Position3, Player).



%%%% GUI extra move

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

is_game_over(board(B, PlayerScore, B1, AIScore)):-
	finished(board(B, PlayerScore, B1, AIScore)).

% % no winner yet
game_over(board(B, PlayerScore, B1, AIScore), Player, null) :-
	not(finished(board(B, PlayerScore, B1, AIScore))).

/* (done) */
game_over(board(B, Score, B1, Score), _, draw) :-
	finished(board(B, Score, B1, Score)).
game_over(board(B, PlayerScore, B1, AIScore), Player, Player) :-
	finished(board(B, PlayerScore, B1, AIScore)),
	PlayerScore > AIScore, !.
game_over(board(B, PlayerScore, B1, AIScore), Player, Openent) :-
	finished(board(B, PlayerScore, B1, AIScore)),
	AIScore > PlayerScore,
	next_player(Player, Openent).


% for AI
game_over(board(B, PlayerScore, B1, PlayerScore)) :-
	finished(board(B, PlayerScore, B1, PlayerScore)).

game_over(board(B, PlayerScore, B1, AIScore)) :-
	finished(board(B, PlayerScore, B1, AIScore)),
	PlayerScore > AIScore, !.

game_over(board(B, PlayerScore, B1, AIScore)) :-
	finished(board(B, PlayerScore, B1, AIScore)),
	PlayerScore > AIScore.
