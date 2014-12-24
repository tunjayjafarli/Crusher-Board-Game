-- * * * CRUSHER GAME * * * --

import Data.List (maximumBy)
import Data.List (minimumBy)
import Data.Ord  (comparing)

crusher boards player depth sideLength = 
				(find_bestMove (head boards) boards player depth sideLength) : boards

-- Makes the best move by employing the minimax algorithm
find_bestMove board history player depth sideLength = 
				(fst (minimax board history depth "MAX" player sideLength))

--------------------------- MINIMAX ALGORITHM ---------------------------

-- Determines the most promising move by using the minimax algorithm
minimax board history depth maxPlayer player side		
    | depth == 0 				= evaluator board history player side
    | maxPlayer == "MAX"		= findMax (map max_helper possibleMoves)
    | otherwise					= findMin (map min_helper possibleMoves)
         where max_helper board = minimax board history (depth-1) "MIN" player side
               min_helper board = minimax board history (depth-1) "MAX" player side
               possibleMoves    = generateNewBoards board player side 0

findMax tupleBoards = maximumBy (comparing snd) tupleBoards
findMin tupleBoards = minimumBy (comparing snd) tupleBoards

-------------------------- BOARD EVALUATION -----------------------------

-- Evaluates the given board and attach the value to it
evaluator board history player side
	| (opp_pieces board player) < side 	= makeTuple board 100
	| (my_pieces board player) < side 	= makeTuple board (-100)
	| elem board history 				= makeTuple board (-100)
	| otherwise 						= makeTuple board ((my_pieces board player) - (opp_pieces board player))
		where makeTuple a b = (a, b)

-- Computes the number of player's pieces
my_pieces board player = find_pieces board player

-- Computes the number of opponent's pieces
opp_pieces board player
	| player == 'B'			 = find_pieces board 'W'
	| otherwise				 = find_pieces board 'B'

-- Computes the number of pieces for the input player
find_pieces board player
	| null board                       = 0
	| player == (head board)           = 1 + (find_pieces (tail board) player)
	| otherwise                        = find_pieces (tail board) player

--------------------------- MOVE GENERATION ----------------------------

-- Returns a list of new boards --
generateNewBoards board piece sideLength pieceIndex  
	| null board 			    = []
	| (head board == piece)		= (generateNewMoves board piece sideLength pieceIndex) : 
								  (generateNewBoards (tail board) piece sideLength (pieceIndex+1))
	| otherwise					= generateNewBoards  (tail board) piece sideLength (pieceIndex+1)

-- Takes a board, piece, and s and outputs a list of boards each containing a legal move
generateNewMoves board piece s nth
    -- Check for LegalMoves and Move within x axis
    |  (retrieveItem (nth - 2) s board)  == '-'   	           = (moveWithin "x" "left" board nth s piece)
    |  (retrieveItem (nth + 0) s board)  == '-'  	           = (moveWithin "x" "right" board nth s piece)
    | ((retrieveItem (nth - 3) s board)  == '-') 
    ||((retrieveItem (nth - 3) s board)  == (rivalize piece))  = (moveWithin "x" "jumpLeft"	board nth s piece)
    | ((retrieveItem (nth + 1) s board)  == '-' )	
    ||((retrieveItem (nth + 1) s board)  == (rivalize piece )) = (moveWithin "x" "jumpRight" board nth s piece)

    -- Check for LegalMoves and Move within y = -x axis
    |  (retrieveItem (nth - (2*s-1)) s board)     == '-'               = (moveWithin "y=-x" "topLeft" board nth s piece)
    |  (retrieveItem (nth + (2*s-1)) s board)     == '-' 	           = (moveWithin "y=-x" "botRight" board nth s piece)
    | ((retrieveItem (nth - (2*(2*s-1))) s board) == '-') 
    ||((retrieveItem (nth - (2*(2*s-1))) s board) == (rivalize piece)) = (moveWithin "y=-x" "JumpTopLeft" board nth s piece) 
    | ((retrieveItem (nth + (2*(2*s-1))) s board) == '-') 
    ||((retrieveItem (nth + (2*(2*s-1))) s board) == (rivalize piece)) = (moveWithin "y=-x" "JumpBotRight" board nth s piece)

    -- Check for LegalMoves and Move within y = x axis
    |  (retrieveItem (nth - 2*(s-1)) s board)	== '-'                = (moveWithin "y=x" "topRight" board nth s piece)
    |  (retrieveItem (nth + 2*(s-1)) s board)	== '-'                = (moveWithin "y=x" "botLeft" board nth s piece)
    | ((retrieveItem (nth - 4*(s-1)) s board)	== '-') 	
    ||((retrieveItem (nth - 4*(s-1)) s board)	== (rivalize piece))  = (moveWithin "y=x" "JumpTopRight" board nth s piece)
    | ((retrieveItem (nth + 4*(s-1)) s board)	== '-')
    ||((retrieveItem (nth + 4*(s-1)) s board)	==  (rivalize piece)) = (moveWithin "y=x" "JumpBotLeft" board nth s piece)

-- Retrieves element at index i from board, based on its sideLength s; 'O' stands for out-of-bounds
retrieveItem i s board
    | i <= 0 || i >= ((2*s-1)*(2*s-1))          = 'O'
    | otherwise                              	= board !! i

-- Rivalizes input piece to return its opposite 'B'<->'W'
rivalize piece
	| piece == 'W' 	= 'B'
	| otherwise		= 'W'

moveWithin axis dir board nth s piece
    | axis == "x" 		= moveInX 		dir board piece nth s
    | axis == "y=x"		= moveInYx 	dir board piece nth s
    | axis == "y=-x"	= moveInNegYx 	dir board piece nth s
 
 -- Moves on the x axis using piecePlacement board piece origin destination
moveInX dir board piece nth s  
    | dir == "left"              = piecePlacement board piece (nth-1) (nth - 2)    
    | dir == "right"             = piecePlacement board piece (nth-1) (nth + 0) 
    | dir == "jumpLeft"          = piecePlacement board piece (nth-1) (nth - 3)
    | dir == "jumpRight"         = piecePlacement board piece (nth-1) (nth + 1)

moveInYx dir board piece nth s 
    | dir == "topRight"          = piecePlacement board piece (nth-1) (nth - 2*(s-1))
    | dir == "botLeft"           = piecePlacement board piece (nth-1) (nth + 2*(s-1))
    | dir == "jumpTopRight"      = piecePlacement board piece (nth-1) (nth - 4*(s-1))
    | dir == "jumpBotLeft"       = piecePlacement board piece (nth-1) (nth + 4*(s-1))

moveInNegYx dir board piece nth s 
    | dir == "topLeft"           = piecePlacement board piece (nth-1) (nth - (2*s-1))        
    | dir == "botRight"          = piecePlacement board piece (nth-1) (nth + (2*s-1)) 
    | dir == "jumpTopLeft"       = piecePlacement board piece (nth-1) (nth - (4*s-2)) 
    | dir == "jumpBotRight"      = piecePlacement board piece (nth-1) (nth + (4*s-2))

-- Takes a piece from origin position and places it on the destination by removing the piece from original 
-- location and putting the piece in the destination location
piecePlacement board piece origin destin    = (take (destin-1) (removeOriginPiece board origin)) 
											++	(piece : (drop destin (removeOriginPiece board origin)))
											
-- Removes origin piece from board and leave a '-'
removeOriginPiece board origin              = (take (origin-1) board) ++ ('-': (drop origin board))
