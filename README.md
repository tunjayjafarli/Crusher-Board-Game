Crusher-Board-Game
==================

An AI search game implemented in Haskell

Crusher is played on a hexagonal board with N hexes to a side.  Each
player starts with 2N-1 pieces arranged in two rows at opposite ends of
the board.  Here's an example of an initial Crusher board where N = 3:

               W   W   W

             -   W   W   -

           -   -   -   -   -

             -   B   B   -

               B   B   B


White always begins at the top of the board, and white always makes
the first move.

In Crusher, players alternate moves and try to win by obliterating
the other player's pieces.  A piece can move in one of two ways.
First, a piece can slide to any one of six adjacent spaces so long
as the adjacent space is empty.  So in the diagram below, the black
piece can slide to any of the spaces indicated by a "*":

               W   W   W

             -   *   *   -

           -   *   B   *   -

             -   *   *   -

               B   B   B

The other type of movement is a leap.  A piece can leap over an
adjacent piece of the same color in any of six directions.  The space
that the piece leaps to may be empty, or it may be occupied by an
opponent's piece.  If the space is occupied by an opponent's piece,
that piece is removed from the game.  Thus leaping is not only a means
of movement, but it's the only means of capturing an opponent's piece.
Also, note that a player must line up two pieces in order to capture an
opponent's piece.  Here's an example of leaping.  Let's say the board
looks like this:


               W   W   -

             -   W   -   -

           -   -   B   -   -

             B   -   B   -

               -   -   -

If it's now black's turn, black has two possible leaps available (in
addition to several slides).  Black could leap like this and crush the
white piece (hence the name Crusher):

               W   W   -

             -   B   -   -

           -   -   B   -   -

             B   -   -   -

               -   -   -

This would seem to be a pretty good move for black, as it results
in a win for black.  The other possible leap shows black running away
for no obvious reason:

               W   W   -

             -   W   -   -

           -   -   -   -   -

             B   -   B   -

               -   -   B

Note that a piece may not leap over more than one piece.  Oh, there's
one more constraint on movement.  No player may make a move that
results in a board configuration that has occurred previously in the
game.  This constraint prevents the "infinite cha-cha" where one player
moves forward, the other player moves forward, the first player moves
back, the other player moves back, the first player moves forward, and
so on.  We prevent this sort of annoying behavior by checking the history 
list of moves that will be passed to the program.

How does a game end?  Who wins?  One player wins when he or she has
removed N (i.e., more than half) of the opponent's pieces from the
board.  That was easy, wasn't it?  A player also wins if it's the
opponent's turn and the opponent can't make a legal move.


I and my partner worked together to construct a Haskell function, 
along with all the necessary supporting functions, which takes as 
input a representation of the state of a Crusher game (i.e. a board position), 
an indication as to which player is to move next, and an integer representing 
the number of moves to look ahead. The current board position is actually 
the first element on a list containing all the boards or states that the game
has passed through, from the initial board to the most recent board. The function 
called "crusher", will also be passed an integer representing N 
(the number of hexes or spaces along one side of the board).

This function determines the best next move that the designated player
can make from that given board position. That move is
represented as a Crusher board position in the same format that was
used for the input board position.  That new board position is then
cons'ed onto the history list of boards that was passed as an argument
to your function, and that updated list is the value returned by the
function.

The function selects the best next move by using MiniMax search and 
devises a static board evaluation function to embody
the strategy that we want Crusher program to employ. The program also 
has the necessary move generation capability.
