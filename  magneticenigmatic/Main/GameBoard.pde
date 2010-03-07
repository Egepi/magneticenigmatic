/* Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: March 3, 2010
 * Class - GameBoard: <Description goes here>
*/
class GameBoard
{
//private int boardWidth;  Use MAX_R and TPR instead
//private int boardHeight; These names are short because they will be used often
  public Tile tileBoard[][]; 
  
  /************************************************************
  * Constructor for a GameBoard, sets the width and height of board.
  * And creates the 2d array that will hold the tiles of the board.
  *
  * Author: Todd Silvia
  */
  GameBoard(int theWidth, int theHeight)
  {
    tileBoard = new Tile[theWidth][theHeight];
  }
  
  /************************************************************
  * Traverses the entire GameBoard and prints it to the screen.
  *
  * Author: Todd Silvia
  */
  void drawBoard()
  {
    int tempX = (screen.width/2) - ((MAX_R * TILE_SIZE)/2);
    int tempY = (screen.height/2) - ((TPR * TILE_SIZE)/2);
    for(int x = 0; x < TPR; x++)
    {
      for(int y = 0; y < MAX_R; y++)
      {
        if(tileBoard[x][y].getTileType() != 0)
        {
          image(tileBoard[x][y].getTileImage(),tempX,tempY,TILE_SIZE,TILE_SIZE);
        }
        tempX = tempX + TILE_SIZE;
      }
      tempY = tempY + TILE_SIZE;
      tempX = (screen.width/2) - ((MAX_R * TILE_SIZE)/2);
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
    for(int i = 0; i < TPR; i++)
    {
      for(int j = 0; j < MAX_R; j++)
      {
        tileBoard[i][j] = new Tile(int(random(1,TILE_TYPES)));
      }
    }
  }
  
  /************************************************************
  * Checks to make sure tiles can be swapped, then swaps two adjacent tiles
  *
  * Author: JM
  */
  public boolean swap(int a, int b, int row) //Swap tile at xcoord a with tile at xcoord b on a row
  {
    if ((a < 0)||(a>=TPR)||(b < 0)||(b>=TPR)||(row < 0)||(row >=MAX_R)) //if a, b, or row are out of range
      return false; //tell caller swap did not succeed
    if ((tileAt(a,row) == null)||(tileAt(b,row) == null)) //if these tiles somehow don't exist
      return false;
    if (abs(a-b)!=1) //if a is not adjacent to b
      return false;
    if (!((tileAt(a,row).swappable())&&(tileAt(b,row).swappable()))) //if either block is not swappable
      return false;
    //Play fancy animation for which the duration is the time that the tile is not swappable.  
    Tile temp = tileAt(b,row);
    tileBoard[b][row] = tileAt(a,row);
    tileBoard[a][row] = temp;
    return true;
  }
  
  public boolean swap(Selector s1, Selector s2) //attempt to swap the selected tiles if the selectors are on the same row
  {
    if (s1.getY() != s2.getY())
      return false;
    return swap(s1.getX(),s2.getX(),s1.getY());
  }
    
    
  
  public Tile[][] getGameBoard()
  {
    return tileBoard;
  }
  
  private Tile tileAt(int x, int y) //alternative for getting a tile
  {
    return tileBoard[x][y];   
  }
  
  private Tile tileAt(Selector s) //alternative for getting a tile
  {
    return tileBoard[s.getX()][s.getY()];   
  }
    

}
