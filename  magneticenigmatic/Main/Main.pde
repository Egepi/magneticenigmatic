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
  checkWin();
}

  void checkWin()
  {
    Tile tempTile;
    for(int i = 0; i < theBoard.boardHeight-1; i++)
    {
      for(int j = 0; j < theBoard.boardWidth-1; j++)
      {
        tempTile = theBoard.tileBoard[i][j];
        if(tempTile.getTileType() == theBoard.tileBoard[i+1][j].getTileType())
        {
          
        }
      }
    }    
  }
