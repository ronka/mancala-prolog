%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Game helpers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%choosing a move by alpha beta
choose_move(Position, _, Move, Depth) :-
	alpha_beta(Depth, Position, -1000, 1000, Move, _).

%choosing a move by alpha beta
choose_move(Position, _, Move) :-
	settingsDepth(Depth),
	alpha_beta(Depth, Position, -1000, 1000, Move, _),
	format('~nSelected: ~w', [Move]).

distribute_stones(Stones, Index, board(Hs, K, Ys, L), board(FHs, FK, FYs, L)) :-
	board_struct(board(Hs, K, Ys, L), TmpBoard), % covert the board to a list
	perform_distribute_stones(Stones, Index, Index, TmpBoard, TmpFinal),
	get_other_player_stones(Stones, Index, TmpFinal, FinalBoard),
	struct_board(FinalBoard, board(FHs, FK, FYs, L)). %convert the list to a board

% reversed task of board_struct
increase_by_index(Index, Board, FinalBoard):-
	nth1(Index, Board, Stones),
	ToSet is Stones + 1,
	replace(Board, Index, ToSet, FinalBoard).

/* kheyli tamiz o mamani miyad index migire az un be ba'do por mikone */
perform_distribute_stones(0, _, _, Board, Board):-!.

perform_distribute_stones(Stones, StartingIndex, StartingIndex, Board, FinalBoard) :-
	I is StartingIndex + 1,
	replace(Board, StartingIndex, 0, TmpBoard),
	perform_distribute_stones(Stones, StartingIndex, I, TmpBoard, FinalBoard), !.

perform_distribute_stones(Stones, StartingIndex, Index, Board, FinalBoard):-
	RemainingStones is Stones - 1,
	I is ((Index) mod 13)+1,
	increase_by_index(Index, Board, TmpBoard),
	perform_distribute_stones(RemainingStones, StartingIndex, I, TmpBoard, FinalBoard),!.

get_other_player_stones(Stones, Index, Board, FinalBoard):-
	NewIndex is ( ( Index + Stones ) mod 13 ),
	NewIndex < 7,
	
	nth1(NewIndex, Board, NewIndexStones),
	NewIndexStones =:= 1,
	
	OtherSideIndex is ( ( NewIndex + 2 * ( 7 - NewIndex ) ) mod 13 ),
	
	nth1(OtherSideIndex, Board, OtherSideStones),
	OtherSideStones > 0, !,
 
	nth1(7, Board, UserScore),
	NewUserScore is UserScore + OtherSideStones + 1,

	replace(Board, NewIndex, 0, TmpBoard),
	replace(TmpBoard, OtherSideIndex, 0, TmpBoard1),
	replace(TmpBoard1, 7, NewUserScore, FinalBoard).

get_other_player_stones(Stones, Index, Board, Board):-
	NewIndex is ( ( Index + Stones ) mod 13 ),
	NewIndex < 7,
	
	nth1(NewIndex, Board, NewIndexStones),
	NewIndexStones =:= 1,

	nth1(OtherSideIndex, Board, OtherSideStones),
	OtherSideStones =:= 0, !.

get_other_player_stones(Stones, Index, Board, Board):-
	NewIndex is ( ( Index + Stones ) mod 13 ),
	NewIndex < 7,
	
	nth1(NewIndex, Board, NewIndexStones),
	NewIndexStones =\= 1, !.

get_other_player_stones(Stones, Index, Board, Board):-
	NewIndex is ( ( Index + Stones ) mod 13 ),
	NewIndex >= 7, !.

%check the number of stones in an index with board
get_stones_greater_than_zero(Index, board(Side, _, _, _), Stones) :-
	nth1(Index, Side, Stones),
	Stones > 0.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General helpers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set element in I index to be X
replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]):-
	I > 0,
	NI is I-1,
	replace(T, NI, X, R), !.
replace(L, _, _, L).

% convert the list to a board
% [_,_,_,_,_,_,Score2,_,_,_,_,_,_,Score1] -> board([_,_,_,_,_,_],Score2,[_,_,_,_,_,_],Score1)
struct_board(Board, board(Hs, K, Ys, _)) :-
	firstN(Board, 6, Hs),
	lastN(Board, 6, Ys),
	nth0(6, Board, K).

% covert the board to a list
% board([_,_,_,_,_,_],Score2,[_,_,_,_,_,_],Score1) -> [_,_,_,_,_,_,Score2,_,_,_,_,_,_,Score1]
board_struct(board(Hs, K, Ys, _), Board) :-
	conc(Hs, [K], Tmp),
	conc(Tmp, Ys, Board).

%returns last N elements in a list
lastN(Src,N,L) :-
    length(Src,X),
	findall(E, (nth1(I,Src,E), I > (X-N)), L).

%returns first N elements in a list
firstN(Src,N,L) :-
	findall(E, (nth1(I,Src,E), I =< N), L).

% swap between locations
swap(board(Hs,K,Ys,L), board(Ys,L,Hs,K)).

conc([], L, L).
conc([X|L1], L2, [X|L3]) :-
	conc(L1, L2, L3).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLI Input/Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

get_move(Index):-
	repeat,
	write('choose a move between 1-6'),nl,
	(
		read(Index),member(Index, [1,2,3,4,5,6]),!
	;
		write('invalid choice.'),nl,fail
	).

% end of the game
finish(draw) :-
	format('-- TIE --', []), !.
finish(PlayerName) :-
	format('The winner is ~w~n', [PlayerName]).

display_game(Position, ai) :-
	show(Position, ai).
display_game(Position, player) :-
	swap(Position, Position1), show(Position1, player).

display_game_first_time(Position) :- show(Position).

%print the board
show(board(H,K,Y,L)) :-
	reverse(H, HR),
	format('~nPlayer Board: ~w ~n(P2)~w : ~w(P1)~nBoard of AI: ~w ~n~n-----------------', [HR, K, L, Y]).

show(board(H,K,Y,L), PlayerName) :-
	reverse(H, HR),%%%%%and change H to HR in the format line
	format('~nTurn: ~w ~nPlayer Board: ~w ~n(P2)~w : ~w(P1)~nBoard of AI: ~w ~n~n-----------------', [PlayerName, HR, K, L, Y]).