/* Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: March 3, 2010
 * Class - GameBoard: <Description goes here>
*/
class GameBoard
{
  private int boardWidth;
  private int boardHeight;
  Tile tileBoard[][]; 
  
  /************************************************************
  * Constructor for a GameBoard, sets the width and height of board.
  * And creates the 2d array that will hold the tiles of the board.
  *
  * Author: Todd Silvia
  */
  GameBoard(int theWidth, int theHeight)
  {
    boardWidth = theWidth;
    boardHeight = theHeight;
    tileBoard = new Tile[boardHeight][boardWidth];
  }
  
  /************************************************************
  * Traverses the entire GameBoard and prints it to the screen.
  *
  * Author: Todd Silvia
  */
  void drawBoard()
  {
    int tempX = 0;
    int tempY = 0;
    for(int x = 0; x < boardHeight; x++)
    {
      for(int y = 0; y < boardWidth; y++)
      {
        image(tileBoard[x][y].getTileImage(),tempX,tempY,50,50);
        tempX = tempX + 52;
      }
      tempY = tempY + 52;
      tempX = 0;
    }
  }
  
  /************************************************************
  * Generates a board to be print to the screen.
  *
  * #### This method will be used to generate a 'random' board ####
  *
  * Author: Todd Silvia
  */
  void generateBoard()
  {
    for(int i = 0; i < boardHeight; i++)
    {
      for(int j = 0; j < boardWidth; j++)
      {
        tileBoard[i][j] = new Tile(0);
      }
    }
    tileBoard[3][4] = new Tile(1);
    tileBoard[4][4] = new Tile(1);
  }
  
  void checkWin()
  {
    Tile tempTile;
    for(int i = 0; i < boardHeight-1; i++)
    {
      for(int j = 0; j < boardWidth-1; j++)
      {
        tempTile = tileBoard[i][j];
        if(tempTile.getTileType() == tileBoard[i+1][j].getTileType())
        {
          
        }
      }
    }    
  }
}
