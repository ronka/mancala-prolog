/* Play framework */

/* start game and choose the level */
play(Level) :-
	initialize(Level, Position, Player),
	display_game_first_time(Position),
	play(Position, Player, _).

%there are no more stones to one of the players
play(Position, Player, Result) :-
	game_over(Position, Player, Result),
	!,
	finish(Result).

play(Position, Player, Result) :-
	choose_move(Position, Player, Move),
        move(Move, Position, Position1),
        display_game(Position1, Player),
        next_player(Player, Player1),
        !,
	play(Position1, Player1, Result).

%choosing a move by alpha beta
choose_move(Position, _, Move) :-
	settingsDepth(Depth),
	alpha_beta(Depth, Position, -1000, 1000, Move, _),
	format('~nSelected: ~w', [Move]).

% move/2 for AI - creates moves
move(Board, [Index|Others]) :-
        member(Index, [1,2,3,4,5,6]),
	stones_in_hole(Index, Board, Stones),
        extra_move(Stones, Index, Board, Others).
move(board(H, _, _, _), []):-zero(H).

% move/3 for User - performs moves
move([Index|Others], Board, FinalBoard) :-
       stones_in_hole(Index, Board, Stones),
       distribute_stones(Stones, Index, Board, TmpBoard),
       move(Others, TmpBoard, FinalBoard).
move([], Board, FinalBoard) :-
	swap(Board, FinalBoard).



%check the number of stones in an index
stones_in_hole(Index, board(BoardKhodi, _, _, _), Stones) :-
	nth1(Index, BoardKhodi, Stones),
	Stones > 0.

% if last stone doesn't land on a store-hole
extra_move(Stones, Index, _, []) :-
	Stones  mod 13 =\= (7-Index),
	!.
% TODO: sharti ke sangaye harifo miyare vase khodesh pak beshe
% sharti ke tu khune charkheshi harif oftad az khune ba'dish betune vardare ro bezarim

% if last stone lands on a store-hole
extra_move(Stones, M, Board, Ms) :-
	Stones mod 13 =:= (7-M) , !,
        distribute_stones(Stones, M, Board, Board1),
	move(Board1, Ms).

distribute_stones(Stones, Hole, board(Hs, K, Ys, L), board(FHs, FK, FYs, L)) :-
	board_struct(board(Hs, K, Ys, L), TmpBoard),% covert the board to a list
	perform_distribute_stones(Stones, Hole, Hole, TmpBoard, TmpFinal),
	struct_board(TmpFinal, board(FHs, FK, FYs, L)).%convert the list to a board

%returns last N elements in a list
lastN(L,N,R):-
	length(L,X),
	X1 is X-N,
	lastT(L,X1,R).
lastT(L,0,L):-!.
lastT([_|T],X,L):-
	X2 is X-1,
	lastT(T,X2,L).

%returns first N elements in a list
take(Src,N,L) :-
	findall(E, (nth1(I,Src,E), I =< N), L).

%convert the list to a board
struct_board(Board, board(Hs, K, Ys, _)) :-
	take(Board, 6, Hs),
	lastN(Board, 6, Ys),
	%lastN(Board, 6, TmpYs),
	%reverse(TmpYs, Ys),
	nth0(6, Board, K).

% covert the board to a list
board_struct(board(Hs, K, Ys, _), Board) :-
	conc(Hs, [K], Tmp),
	%reverse(Ys, YsPrime),
	%conc(Tmp, YsPrime, Board).
         conc(Tmp, Ys, Board).
% reversed task of board_struct
increase_by_index(Index, Board, FinalBoard):-
	nth1(Index, Board, Stones),
	ToSet is Stones + 1,
	replace(Board, Index, ToSet, FinalBoard).

/* kheyli tamiz o mamani miyad index migire az un be ba'do por mikone */
perform_distribute_stones(0, _, _, Board, Board):-!.
%bepashun(1, StartingIndex, Index, Board, FinalBoard):-
%	%format('~nindex:~w',[Index]),
%	increase_by_index(Index, Board, TmpBoard),
%	Tmp is Index +1,
%	ToPick is ((Tmp) mod 13)+1,
%	8 =< ToPick , ToPick =< 13,
%	nth1(ToPick, TmpBoard, Stones),
%	replace(TmpBoard, ToPick, 0, TmpFinal),
%	bepashun(Stones, ToPick, ToPick, TmpFinal, FinalBoard), !.
perform_distribute_stones(Stones, StartingIndex, StartingIndex, Board, FinalBoard) :-
	I is StartingIndex + 1,
	replace(Board, StartingIndex, 0, TmpBoard),
	perform_distribute_stones(Stones, StartingIndex, I, TmpBoard, FinalBoard), !.
perform_distribute_stones(Stones, StartingIndex, Index, Board, FinalBoard):-
	RemainingStones is Stones - 1,
	I is ((Index) mod 13)+1,
	increase_by_index(Index, Board, TmpBoard),
	perform_distribute_stones(RemainingStones, StartingIndex, I, TmpBoard, FinalBoard),!.

/* (done) */
finished(board(L, _, L1, _)):-
	zero(L); zero(L1).

/* (done) */
game_over(board(B, AnbarMosavi, B1, AnbarMosavi), _, draw) :-
	finished(board(B, AnbarMosavi, B1, AnbarMosavi)).
game_over(board(B, AnbarAvvali, B1, AnbarDovvomi), Player, Player) :-
	finished(board(B, AnbarAvvali, B1, AnbarDovvomi)),
	AnbarAvvali > AnbarDovvomi, !.
game_over(board(B, AnbarAvvali, B1, AnbarDovvomi), Player, Opponent) :-
	finished(board(B, AnbarAvvali, B1, AnbarDovvomi)),
	AnbarDovvomi > AnbarAvvali,
	next_player(Player, Opponent).

%for AI
game_over(board(B, AnbarMosavi, B1, AnbarMosavi)) :-
	finished(board(B, AnbarMosavi, B1, AnbarMosavi)).
game_over(board(B, AnbarAvvali, B1, AnbarDovvomi)) :-
	finished(board(B, AnbarAvvali, B1, AnbarDovvomi)),
	AnbarAvvali > AnbarDovvomi, !.
game_over(board(B, AnbarAvvali, B1, AnbarDovvomi)) :-
	finished(board(B, AnbarAvvali, B1, AnbarDovvomi)),
	AnbarDovvomi > AnbarAvvali.
%%game_over(board(Hs, K, Ys, L)) :-
%%%	finished(board(Hs, K, Ys, L)).


% end of the game
finish(draw) :-
	format('-- TIE --', []), !.
finish(PlayerName) :-
	format('The winner is ~w~n', [PlayerName]).

%replace an element by a new value
replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]):-
	I > 0,
	NI is I-1,
	replace(T, NI, X, R), !.
replace(L, _, _, L).


swap(board(Hs,K,Ys,L), board(Ys,L,Hs,K)).

conc([], L, L).
conc([X|L1], L2, [X|L3]) :-
	conc(L1, L2, L3).

display_game(Position, player1) :-
	show(Position, player1).
display_game(Position, player2) :-
	swap(Position, Position1), show(Position1, player2).

display_game_first_time(Position) :- show(Position).

%print the board
show(board(H,K,Y,L)) :-
	reverse(H, HR),
	format('~nBoard of Player2: ~w ~n(P2)~w : ~w(P1)~nBoard of
	Player1: ~w ~n~n-----------------', [HR, K, L, Y]).

show(board(H,K,Y,L), PlayerName) :-
	reverse(H, HR),%%%%%and change H to HR in the format line
	format('~nTurn: ~w ~nBoard of Player2: ~w ~n(P2)~w :
	~w(P1)~nBoard of Player1: ~w ~n~n-----------------',
	[PlayerName, HR, K, L, Y]).

%initialize state
initialize(Level, board([S,S,S,S,S,S], 0, [S,S,S,S,S,S], 0), player2) :-
	settings(stones, S),
	retractall(settingsDepth(_)),
	settings(treeDepth,TreeDepth,Level), assert(settingsDepth(TreeDepth)).










