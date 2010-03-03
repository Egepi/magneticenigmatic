/* Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: March 3, 2010
 * Class - Main: <Description goes here>
*/
GameBoard theBoard;
void setup()
{
  //Setting the max number of rows and coloms on the GameBoard
  int BOARD_WIDTH = 8;
  int BOARD_HEIGHT = 8;
  size(screen.width, screen.height);
  //Making the board the game will be played on.
  theBoard = new GameBoard(BOARD_WIDTH, BOARD_HEIGHT);
  theBoard.generateBoard();
}

void draw()
{
  //Arbitrary background color for the time being.
  background(50,125,150);
  //Prints the board on the screen.
  theBoard.drawBoard();
}
