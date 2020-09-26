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
% play(board([0,0,0,0,0,1],0,[1,1,1,1,1,1],0), ai, 1, AfterBoard, Winner)
% board([playerBoard],playerScore,[AIBoard],AIScore)
play(Board, ai, Depth, FinalBoard, Winner) :-
    swap(Board, SwappedBoard),
	choose_move(SwappedBoard, ai, Move, Depth),
	move(Move, SwappedBoard, FinalBoard), !,
    game_over(FinalBoard, ai, Winner).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLI Controllers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % initialize state
% initialize(Level, board([S,S,S,S,S,S], 0, [S,S,S,S,S,S], 0), player) :-
% 	settings(stones, S),
% 	retractall(settingsDepth(_)),
% 	settings(treeDepth,TreeDepth,Level), assert(settingsDepth(TreeDepth)).

% /* start game and choose the level */
% play(Level) :-
% 	initialize(Level, Position, Player),
% 	display_game_first_time(Position),
% 	play(Position, Player, _).