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
  public ArrayList clears;
  
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
  public void drawBoard()
  {
    int tempX = PUZZLE_ORIGIN_X+(int)(theMomentum.incrementY());
    int tempY = PUZZLE_ORIGIN_Y;
    for(int x = 0; x < TPR; x++)
    {
      for(int y = 0; y < MAX_R; y++)
      {
        tileBoard[x][y].action();
     //   if(tileBoard[x][y].getTileType() != 0)
     //   {
          tileBoard[x][y].drawTile(tempX,tempY);
     //   }
        tempX = tempX + TILE_SIZE;
      }
      tempY = tempY + TILE_SIZE;
      tempX = PUZZLE_ORIGIN_X+(int)(theMomentum.getY());
    }
  }
  
  /************************************************************
  * Generates a board to be print to the screen.
  *
  * #### This method will be used to generate a 'random' board ####
  *
  * Author: Todd Silvia
  */
  public void generateBoard()
  {
    for(int i = 0; i < TPR; i++)
    {
      for(int j = 0; j < MAX_R; j++)
      {
        tileBoard[i][j] = new Tile(int(random(1,TILE_COLORS)));
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
    if ((tileAt(a,row).getTileType() == 0)&&(tileAt(b,row).getTileType() == 0))
      return false;
    Tile temp = tileAt(b,row);
    tileBoard[b][row] = tileAt(a,row);
    tileBoard[a][row] = temp;
    tileBoard[b][row].animate(b-a,0);
    tileBoard[a][row].animate(a-b,0);
    return true;
  }
  
  public boolean swap(Selector s1, Selector s2) //attempt to swap the selected tiles if the selectors are on the same row
  {
    if (s1.getY() != s2.getY())
      return false;
    return swap(s1.getX(),s2.getX(),s1.getY());
  }
    
    
  /************************************************************
  * Iterates through all the blocks and checks to see if they should fall
  *
  * Author: JM
  */  
  public void gravity(){
    for (int x=0; x<TPR; x++)
      for (int y=0; y<MAX_R; y++)
      {
        if (tileBoard[x][y].getTileType() == EMPTY)
          fallTiles(x,y,lineOfGravity); 
      }
  }
  
 
  /************************************************************
  * Takes coordinates of an empty space (x,y) and a line which the blocks are attracted to (g) and incremements the blocks from one end of the puzzle to y on row x horizontally by one meant to be called multiple times in one instance
  * Returns false if the block is not an empty space or if no blocks fall
  *
  * Author: JM
  */
  public boolean fallTiles(int x, int y, int g) //
  {
    int lesser,greater,iter;
    boolean blockHasFallen = false;
    if (tileBoard[x][y].getTileType() != EMPTY)
      return blockHasFallen;
    if (!tileBoard[x][y].swappable())
      return blockHasFallen;
    int furthest,nearest;
    if (g > y) {
      nearest = y-1; //the first block to iterate
      furthest = -1; //the one beyond the last block (out of array bounds)
      iter = -1; //the direction the iterator needs to go
    }
    else{
      nearest = y+1;
      furthest = MAX_R;
      iter = 1;
    }
    int j;
    for (j=nearest; j!=furthest; j+=iter)
    {
      if ((!tileBoard[x][j].swappable())||(tileBoard[x][j].getTileType() == 0))
        break;
      tileBoard[x][j-iter] = tileBoard[x][j];
      tileBoard[x][j-iter].animate(0,-iter);
      if (tileBoard[x][j].getTileType() != EMPTY)
        blockHasFallen = true;
    }
    tileBoard[x][j-iter] = new Tile(EMPTY);
    return blockHasFallen;
  }
  
  public Tile[][] getGameBoard()
  {
    return tileBoard;
  }
  public void setGameBoard(Tile[][] theBoard)
  {
    tileBoard = theBoard;
  }
  
  private Tile tileAt(int x, int y) //alternative for getting a tile
  {
    return tileBoard[x][y];   
  }
  
  private Tile tileAt(Selector s) //alternative for getting a tile
  {
    return tileBoard[s.getX()][s.getY()];   
  }
  /************************************************************
  * Parses the board for any groups of 3+ tiles and clears them
  *
  *
  * Author: Karan Chakrapani
  */
  public void checkClears()
  {
    clears = new ArrayList();
    Tile tempTile;
    
    
    for(int i = 0; i < TPR; i++)
    {
      for(int j = 0; j < MAX_R; j++)
      {
        tempTile = tileBoard[i][j];
        
        /*
         * Horizontal 3 and 4 and 5 check
         */
        if(!(tempTile.getTileType() == 0))
        {
          if((i+1 < TPR) && (tileBoard[i+1][j].swappable()) &&(tempTile.getTileType() == tileBoard[i+1][j].getTileType()))
          {
            if((i+2 < TPR) && (tileBoard[i+2][j].swappable()) && (tempTile.getTileType() == tileBoard[i+2][j].getTileType()))
            {
              if((i+3 < TPR) && (tileBoard[i+3][j].swappable()) && (tempTile.getTileType() == tileBoard[i+3][j].getTileType()))
              {
                if((i+4 < TPR) && (tileBoard[i+4][j].swappable()) && (tempTile.getTileType() == tileBoard[i+4][j].getTileType()))
                {
                  //Debug code
                  print("\n5 tiles cleared Horizontally of type: " + tempTile.getTileType());   
                  clears.add(tileBoard[i][j]);
                  clears.add(tileBoard[i+1][j]);
                  clears.add(tileBoard[i+3][j]);
                  clears.add(tileBoard[i+4][j]);
                  if (j > lineOfGravity)
                     theMomentum.increaseMomentum(-1);
                  else   
                     theMomentum.increaseMomentum(1);       
                }
                else
                {
                  //Debug code
                  print("\n4 tiles cleared Horizontally of type: " + tempTile.getTileType());   
                  clears.add(tileBoard[i][j]);
                  clears.add(tileBoard[i+1][j]);
                  clears.add(tileBoard[i+2][j]);
                  clears.add(tileBoard[i+3][j]);
                  if (j > lineOfGravity)
                     theMomentum.increaseMomentum(-1);
                  else   
                     theMomentum.increaseMomentum(1);       
                }             
              }
              else
              {
                //Debug code
                print("\n3 tiles cleared Horizontally of type: " + tempTile.getTileType());                
                  clears.add(tileBoard[i][j]);
                  clears.add(tileBoard[i+1][j]);
                  clears.add(tileBoard[i+2][j]);
                  if (j > lineOfGravity)
                     theMomentum.increaseMomentum(-1);
                  else   
                     theMomentum.increaseMomentum(1);                         
              }
            }
          }
        }
        
        
        /*
         * Vertical 3 and 4 and 5 check
         */
        if(!(tempTile.getTileType() == 0))
        {
          if((j+1 < MAX_R) && (tileBoard[i][j+1].swappable()) &&(tempTile.getTileType() == tileBoard[i][j+1].getTileType()))
          {
            if((j+2 < MAX_R) && (tileBoard[i][j+2].swappable()) && (tempTile.getTileType() == tileBoard[i][j+2].getTileType()))
            {
              if((j+3 < MAX_R) && (tileBoard[i][j+3].swappable()) && (tempTile.getTileType() == tileBoard[i][j+3].getTileType()))
              {
                if((j+4 < MAX_R) && (tileBoard[i][j+4].swappable()) && (tempTile.getTileType() == tileBoard[i][j+4].getTileType()))
                {
                  //Debug code
                  print("\n5 tiles cleared Vertically   of type: " + tempTile.getTileType());            
                  clears.add(tileBoard[i][j]);
                  clears.add(tileBoard[i][j+1]);
                  clears.add(tileBoard[i][j+3]);
                  clears.add(tileBoard[i][j+4]);
                  if (j+2 > lineOfGravity)
                     theMomentum.increaseMomentum(-1);
                  else   
                     theMomentum.increaseMomentum(1);                    
                }
                else
                {
                  //Debug code
                  print("\n4 tiles cleared Vertically   of type: " + tempTile.getTileType());            
                  clears.add(tileBoard[i][j]);
                  clears.add(tileBoard[i][j+1]);
                  clears.add(tileBoard[i][j+2]);
                  clears.add(tileBoard[i][j+3]);   
                  if (j+2 > lineOfGravity)
                     theMomentum.increaseMomentum(-1);
                  else   
                     theMomentum.increaseMomentum(1);     
                }
              }
              else
              {
                //Debug code
                print("\n3 tiles cleared Vertically   of type: " + tempTile.getTileType());
                clears.add(tileBoard[i][j]);
                clears.add(tileBoard[i][j+1]);
                clears.add(tileBoard[i][j+2]);  
                if (j+1 > lineOfGravity)
                  theMomentum.increaseMomentum(-1);
                else   
                  theMomentum.increaseMomentum(1);     
              }
            }
          }
        }                
       }
     }
     for(int k=0; k<clears.size(); k++)
     {
       
       ((Tile)clears.get(k)).setTileType(0);
     }
  }
  
  /*public void checkClears() {
    Tile t1, t2;
    for(int i = 0; i < TPR; i++)
    {
      for(int j = 0; j < MAX_R; j++)
      {
        if (!tileBoard[i][j].isMarked())
        {
          t1 = tileBoard[i][j];
          t2 = tileBoard[i][j];
          int k = i;
          while (t1.getTileType() == t2.getTileType())
          {
            k++;
            t2 = tileBoard[k][j];
            if ((k-i)>3)
          }
        }
  }
  
  public boolean checkDirection(int type, int direction, int count) {
    if (direction == 0)
    {
      if (
    }
  }*/
  
public void evaluateClears()
{
	clears = new ArrayList();
	Tile clearSet[] = new Tile[5];
    Tile tempTile;
        
    for(int i = 0; i < TPR; i++)
    {
      for(int j = 0; j < MAX_R; j++)
      {
        tempTile = tileBoard[i][j];
		int combo = 1;

        for(int counter =1; counter<5; counter++)
        {
          if((i+counter < TPR) && (tileBoard[i+counter][j].swappable()) &&(tempTile.getTileType() == tileBoard[i+counter][j].getTileType()))
          {
            combo++;
          }
          else
          {
            break;
          } 
        }
        if(combo>2)
        {
          print("\n" + combo + " tiles cleared Horizontally of type: " + tempTile.getTileType()); 
          for (int k = 0; k < combo; k++)
          {
            clearSet[k] = tileBoard[i+k][j];
          }
		  clears.add(clearSet);
		  clearSet[0] = null;
		  clearSet[1] = null;
		  clearSet[2] = null;
		  clearSet[3] = null;
		  clearSet[4] = null;
          combo = 0;
        } 
      }
    }
    doClears();
}
public void doClears()
{
    boolean clearThis = false;
	Tile tempTiles[];
	for(int i = 0; i<clears.size(); i++)
	{
		tempTiles = (Tile[])clears.get(i);
		for (int j = 0; j < 5; j++)
		{
			if(tempTiles[j].swappable())
			{
				clearThis = true;
			}
			else
			{
				clearThis = false;
			}
		}
		
		if (clearThis)
		{
			tempTiles[0].setTileType(0);
			tempTiles[1].setTileType(0);
			tempTiles[2].setTileType(0);
			tempTiles[3].setTileType(0);
			tempTiles[4].setTileType(0);
			clearThis = false;
		}
            
		
		
	}
}
  
  
  
}
