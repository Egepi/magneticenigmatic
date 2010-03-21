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
     //------------------------CHAIN
    //Chain c = new Chain();
    //tileBoard[b][row].setChain(c);
    //tileBoard[a][row].setChain(c);
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
    else if(g < y ){
      nearest = y+1;
      furthest = MAX_R;
      iter = 1;
    }
    else
    {
      int topSide = 0;
      int bottomSide = 0;
      for(int j = 0; j < MAX_R/2; j++)
      {
        if(tileBoard[x][j].getTileType() != 0)
        {
          topSide++;
        }
      }
      for(int j = (MAX_R/2)+1; j < MAX_R-1; j++)
      {
        if(tileBoard[x][j].getTileType() != 0)
        {
          bottomSide++;
        }
      }
      if(topSide > bottomSide)
      {
        nearest = y-1; //the first block to iterate
        furthest = -1; //the one beyond the last block (out of array bounds)
        iter = -1; //the direction the iterator needs to go
      }
      else
      {
        nearest = y+1;
        furthest = MAX_R;
        iter = 1;        
      }
    }
    int j;
    for (j=nearest; j!=furthest; j+=iter)
    {
      if ((!tileBoard[x][j].swappable())||(tileBoard[x][j].getTileType() == 0))
        break;
      //tileBoard[x][j].setChain(getLargerChain(tileBoard[x][j-iter].getChain(),tileBoard[x][j].getChain()));  
      tileBoard[x][j-iter] = tileBoard[x][j];
      tileBoard[x][j-iter].animate(0,-iter);
      if (tileBoard[x][j].getTileType() != EMPTY)
        blockHasFallen = true;
    }
    tileBoard[x][j-iter] = new Tile(EMPTY); // space from which last block fell
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
  
  
  public void clearer()
  {
    int c, thisType;
    Tile thisTile;
    //ArrayList cl = new ArrayList();
    for(int i = 0; i < TPR; i++)
    {
      for(int j = 0; j < MAX_R; j++)
      {
        thisTile = tileAt(i,j);
        if ((thisTile.getTileType()!=EMPTY)&&(thisTile.swappable())&&(!thisTile.isMarked()))
        {
          thisType = thisTile.getTileType();
          c = directionalCheck(i,j,thisType,HORIZONTAL,1);//,cl);
          if (c >= 5){
            tileBoard[i+2][j].convertToPowerup();
          }
          c = directionalCheck(i,j,thisType,VERTICAL,1);//,cl);
          if (c >= 5){
            tileBoard[i][j+2].convertToPowerup();
          }
        }
        
      }
    }   
    //cl.clear();    
  }
  
  private int directionalCheck(int x, int y, int type, int direction, int n) {//, ArrayList cl) {
    int c;
    Tile thisTile = tileAt(x,y);
    //cl.add(thisTile.getChain());
    if(direction == HORIZONTAL)
    {
      if (x+1 >= TPR)
        c = n;
      else if (thisTile.isMatch(tileAt(x+1,y))) // also checks if other tile is 
      {
        c = directionalCheck(x+1,y,type,HORIZONTAL,n+1);//,cl);
      }
      else
      {
        c = n;    
      }
      if (c >= 3)
      {
        if (c==n){
          //Chain z = (Chain)getLargestChain(cl);
          //cl.clear();
          //cl.add(z);
        } //This should only run for the last block in a combo, it gets the largest chainID and empties everything but this chain in the array list.
        //thisTile.setChain((Chain)cl.get(0)); 
        thisTile.mark();
      }
      else
      {
        //cl.remove(this);
      }
      
      return c;   
    }
    else if(direction == VERTICAL)
    {
      if (y+1 >= MAX_R)
        c = n;
      else if (thisTile.isMatch(tileAt(x,y+1))) // also checks if other tile is swappable
        c = directionalCheck(x,y+1,type,VERTICAL,n+1);//,cl);
      else
        c = n;
      if (c >= 3)
      {
        if (c==n){
           //------------------------CHAIN
          //Chain z = (Chain)getLargestChain(cl);
          //cl.clear();
          //cl.add(z);
        } //This should only run for the last block in a combo, it gets the largest chainID and empties everything but this chain in the array list.
        //thisTile.setChain((Chain)cl.get(0)); 
        thisTile.mark();
      }
      return c;   
    }
    else
      println("Bad directionalCheck call, check direction parameter");
    return n;  
  }
  
  
  public int checkLoss()
  {
    if(this.tileBoard[0][0].getMyX() == 0)
    {
      //Debugging   
      //print("\nplayer 1 loss");
      return 1;
    }
    if(this.tileBoard[0][MAX_R-1].getMyX() == 0)
    {
      //Debugging
      //print("\nplayer 2 loss");
      return 2;
    }
    //Debugging
    print("\nno loss");
    return 0;
  }
  
  
  
  
  /************************************************************
  * Parses the board for any groups of 3+ tiles and clears them
  *
  *
  * Author: Karan Chakrapani
  */
  /*public boolean checkClears()
  {
    clears = new ArrayList();
    Tile tempTile;
    boolean returner = false;
    
    
    for(int i = 0; i < TPR; i++)
    {
      for(int j = 0; j < MAX_R; j++)
      {
        tempTile = tileBoard[i][j];
        
        if(!(tempTile.getTileType() == 0))
        {
          if((i+1 < TPR)  &&(tempTile.getTileType() == tileBoard[i+1][j].getTileType()))
          {
            if((i+2 < TPR)  && (tempTile.getTileType() == tileBoard[i+2][j].getTileType()))
            {
              if((i+3 < TPR)  && (tempTile.getTileType() == tileBoard[i+3][j].getTileType()))
              {
                if((i+4 < TPR)  && (tempTile.getTileType() == tileBoard[i+4][j].getTileType()))
                {
                  //Debug code
                  //print("\n5 tiles cleared Horizontally of type: " + tempTile.getTileType());   
                  clears.add(tileBoard[i][j]);
                  clears.add(tileBoard[i+1][j]);
                  int tempType = tileBoard[i][j+2].getTileType();
                  print("\nTHE AMT IS " + tempType);
                  tileBoard[i][j+2].setTileType(tempType + 5);
                  tileBoard[i][j+2].setTileImage(tempType + 5);
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
                  //print("\n4 tiles cleared Horizontally of type: " + tempTile.getTileType());   
                  clears.add(tileBoard[i][j]);
                  clears.add(tileBoard[i+1][j]);
                  clears.add(tileBoard[i+2][j]);
                  clears.add(tileBoard[i+3][j]);
                  if (j > lineOf)
                     theMomentum.increaseMomentum(-1);
                  else   
                     theMomentum.increaseMomentum(1);       
                }             
              }
              else
              {
                //Debug code
                //print("\n3 tiles cleared Horizontally of type: " + tempTile.getTileType());                
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
        

        if(!(tempTile.getTileType() == 0))
        {
          if((j+1 < MAX_R) &&(tempTile.getTileType() == tileBoard[i][j+1].getTileType()))
          {
            if((j+2 < MAX_R) && (tempTile.getTileType() == tileBoard[i][j+2].getTileType()))
            {
              if((j+3 < MAX_R) && (tempTile.getTileType() == tileBoard[i][j+3].getTileType()))
              {
                if((j+4 < MAX_R)  && (tempTile.getTileType() == tileBoard[i][j+4].getTileType()))
                {
                  //Debug code
                  //print("\n5 tiles cleared Vertically   of type: " + tempTile.getTileType());            
                  clears.add(tileBoard[i][j]);
                  clears.add(tileBoard[i][j+1]);
                  int tempType = tileBoard[i][j+2].getTileType();
                  print("\nTHE AMT IS " + tempType);
                  tileBoard[i][j+2].setTileType(tempType + 5);
                  tileBoard[i][j+2].setTileImage(tempType + 5);
                  print("\n NEW IS: " + tileBoard[i][j+2].getTileType());
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
                  //print("\n4 tiles cleared Vertically   of type: " + tempTile.getTileType());            
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
                //print("\n3 tiles cleared Vertically   of type: " + tempTile.getTileType());
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
       if(((Tile)clears.get(k)).getTileType() == 0)
       {
         clears.remove(k);
       }
       else
       {
         ((Tile)clears.get(k)).setTileType(0);
         returner = true;
       }
     }
     return returner;
  }
*/  
  
/*public void evaluateClears()
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
        
        
        //Horizontal clears
        for(int counter =1; counter<5; counter++)
        {
          if((i+counter < TPR) &&(tempTile.getTileType() == tileBoard[i+counter][j].getTileType()))
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
          //print("\n" + combo + " tiles cleared Horizontally of type: " + tempTile.getTileType()); 
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
          combo = 1;
        }
        //Vertical Clears
	for(int counter = 1; counter<5; counter++)
        {
          if((j+counter < MAX_R) &&(tempTile.getTileType() == tileBoard[i][j+counter].getTileType()))
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
          //print("\n" + combo + " tiles cleared Vertically of type: " + tempTile.getTileType()); 
          for (int k = 0; k < combo; k++)
          {
            clearSet[k] = tileBoard[i][j+k];
          }
		  clears.add(clearSet);
		  clearSet[0] = null;
		  clearSet[1] = null;
		  clearSet[2] = null;
		  clearSet[3] = null;
		  clearSet[4] = null;
          combo = 1;
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
		for (int j = 0; j < tempTiles.length; j++)
		{
                       // print("\n" + (tempTiles[j].getTileType()) );
			if((tempTiles[j] != null) && (!tempTiles[j].swappable()))
			{
                               
				clearThis = true;
			}
			else
			{
                             
				clearThis = false;
                                break;
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
}*/
  
  
  
}
