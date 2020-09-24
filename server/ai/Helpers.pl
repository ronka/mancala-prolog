%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Game helpers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

distribute_stones(Stones, Index, board(Hs, K, Ys, L), board(FHs, FK, FYs, L)) :-
	board_struct(board(Hs, K, Ys, L), TmpBoard), % covert the board to a list
    perform_distribute_stones(Stones, Index, Index, TmpBoard, FinalBoard),
    % get_other_player_stones(Stones, Index, TmpFinal, FinalBoard),
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
    get_stones_greater_than_zero_2( NewIndex, Board, NewIndexStones),
    NewIndexStones =:= 1, !,

    OtherSideIndex is ( ( Index + Stones + 7 ) mod 13 ),
    OtherSideIndex > 7, !,

    nth1(OtherSideIndex, Board, OtherSideStones),
    nth1(7, Board, UserScore),
    NewUserScore is UserScore + OtherSideStones,

    replace(Board, OtherSideIndex, 0, TmpBoard),
    replace(TmpBoard, 7, NewUserScore, FinalBoard).

get_other_player_stones(Stones, Index, Board, Board):-
    NewIndex is ( ( Index + Stones ) mod 13 ),
    get_stones_greater_than_zero_2( NewIndex, Board, NewIndexStones),
    NewIndexStones =\= 1, !.

get_other_player_stones(Stones, Index, Board, Board):-
    NewIndex is ( ( Index + Stones ) mod 13 ),
    get_stones_greater_than_zero_2( NewIndex, Board, NewIndexStones),
    
    NewIndexStones =:=  1, !,

    OtherSideIndex is ( ( Index + Stones + 7 ) mod 13 ),
    OtherSideIndex =< 7, !.


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
	take(Board, 6, Hs),
	lastN(Board, 6, Ys),
	nth0(6, Board, K).

% covert the board to a list
% board([_,_,_,_,_,_],Score2,[_,_,_,_,_,_],Score1) -> [_,_,_,_,_,_,Score2,_,_,_,_,_,_,Score1]
board_struct(board(Hs, K, Ys, _), Board) :-
	conc(Hs, [K], Tmp),
	conc(Tmp, Ys, Board).

% swap between locations
swap(board(Hs,K,Ys,L), board(Ys,L,Hs,K)).

conc([], L, L).
conc([X|L1], L2, [X|L3]) :-
	conc(L1, L2, L3).

%check the number of stones in an index
get_stones_greater_than_zero(Index, board(BoardKhodi, _, _, _), Stones) :-
	nth1(Index, BoardKhodi, Stones),
	Stones > 0.

%check the number of stones in an index
get_stones_greater_than_zero_2(Index, Board, Stones) :-
	nth1(Index, Board, Stones),
	Stones > 0.

%check the number of stones in an index
% if_zero_stones(Index, board(BoardKhodi, _, _, _), Stones) :-
% 	nth1(Index, BoardKhodi, Stones),
% 	Stones =:= 0.
