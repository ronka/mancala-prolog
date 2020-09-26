%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI Controllers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% user plays
% play(board([0,0,0,0,0,1],0,[1,1,1,1,1,1],0), player2, 6, AfterBoard, ExtraTurn, Winner)
% board([playerBoard],playerScore,[AIBoard],AIScore)
play(Board, player2, Move, FinalBoard, ExtraTurn, Winner) :-
	perform_user_move(Move, Board, player2, FinalBoard,ExtraTurn), !,
    game_over(FinalBoard, player2, Winner).

% AI plays
% play(board([0,0,0,0,0,1],0,[1,1,1,1,1,1],0), player1, 1, AfterBoard, Winner)
% board([playerBoard],playerScore,[AIBoard],AIScore)
play(Board, player1, Depth, FinalBoard, Winner) :-
    swap(Board, SwappedBoard),
	choose_move(SwappedBoard, player1, Move, Depth),
	move(Move, SwappedBoard, FinalBoard), !,
    game_over(FinalBoard, player1, Winner).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLI Controllers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % initialize state
% initialize(Level, board([S,S,S,S,S,S], 0, [S,S,S,S,S,S], 0), player2) :-
% 	settings(stones, S),
% 	retractall(settingsDepth(_)),
% 	settings(treeDepth,TreeDepth,Level), assert(settingsDepth(TreeDepth)).

% /* start game and choose the level */
% play(Level) :-
% 	initialize(Level, Position, Player),
% 	display_game_first_time(Position),
% 	play(Position, Player, _).