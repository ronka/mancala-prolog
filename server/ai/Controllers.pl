%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI Controllers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% user plays
% play(board([0,0,0,0,0,1],0,[1,1,1,1,1,1],0), player, 6, AfterBoard, ExtraTurn, Winner)
% board([playerBoard],playerScore,[AIBoard],AIScore)
play(Board, player, Move, FinalBoard, ExtraTurn, Winner) :-
	perform_user_move(Move, Board, player, FinalBoard,ExtraTurn), !,
	game_over(FinalBoard, player, Winner).

% AI plays
% play(board([0,0,0,0,0,1],0,[1,1,1,1,1,1],0), ai, 1, AfterBoard, Move, Winner)
% board([playerBoard],playerScore,[AIBoard],AIScore)
play(Board, ai, Depth, FinalBoard, Move, Winner) :-
	swap(Board, SwappedBoard),
	choose_move(SwappedBoard, ai, Move, Depth),
	move(Move, SwappedBoard, FinalBoard), !,
	game_over(FinalBoard, ai, Winner).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLI Controllers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize state
initialize(Level, board([S,S,S,S,S,S], 0, [S,S,S,S,S,S], 0), player) :-
	settings(stones, S),
	retractall(settingsDepth(_)),
	settings(treeDepth,TreeDepth,Level), assert(settingsDepth(TreeDepth)).

/* start game and choose the level */
play(Level) :-
	initialize(Level, Position, Player),
	display_game_first_time(Position),
	play(Position, Player, _).

%there are no more stones to one of the players
play(Position, Player, Result) :-
	is_game_over(Position),
	!,
	game_over(Position, Player, Result),
	finish(Result).

%user plays
play(Position, player, Result) :-
	choose_and_perform_move_user(Position, player, Position1), !,
	swap(Position1, Position2),
	play(Position2, ai, Result).

%AI plays
play(Position, ai, Result) :-
	choose_move(Position, ai, Move),
	move(Move, Position, Position1),
	display_game(Position1, ai),
	!,
	play(Position1, player, Result).

%choosing a move by alpha beta
choose_move(Position, _, Move, Depth) :-
	alpha_beta(Depth, Position, -1000, 1000, Move, _).

%choosing a move by alpha beta
choose_move(Position, _, Move) :-
	settingsDepth(Depth),
	alpha_beta(Depth, Position, -1000, 1000, Move, _),
	format('~nSelected: ~w', [Move]).

choose_and_perform_move_user(Position, Player, Position1) :-
	extra_user_move(Position,Position1, Player).