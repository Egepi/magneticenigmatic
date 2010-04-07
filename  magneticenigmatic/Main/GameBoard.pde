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
   //middleX = ((width/2) - (TILE_SIZE/2));
   tileBoard = new Tile[theWidth][theHeight];
   for(int i = 0; i < TPR; i++)
   {
     for(int j = 0; j < MAX_R; j++)
     {
       tileBoard[i][j] = new Tile(0);
     }
   }
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
    boolean blind;
    for(int x = 0; x < TPR; x++)
    {
      for(int y = 0; y < MAX_R; y++)
      {
        tileBoard[x][y].action();
        blind = false;
        Player p = playerAtY(y);
        if (p!= null)
        {
          blind = p.blind;
        }
        tileBoard[x][y].drawTile(tempX,tempY,blind);
        tempX = tempX + TILE_SIZE;
      }
      tempY = tempY + TILE_SIZE;
      tempX = PUZZLE_ORIGIN_X+(int)(theMomentum.getY());
    }
   fill(255,0,0,63);
   rect(PUZZLE_ORIGIN_X + lineOfGravity*TILE_SIZE + (int)(theMomentum.incrementY()), 0, TILE_SIZE, height);
   fill(0,0,0,255);
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
      for(int j = lineOfGravity-START_R/2; j < lineOfGravity+START_R/2; j++)
      {
        tileBoard[i][j] = new Tile(int(random(1,TILE_COLORS)));
      }
    }
  }
  
  public void generateRow()
  {
    boolean rowIsEmpty = true;
    Tile temp;
    int j = 0;
    
    //Player 1
    while (rowIsEmpty)
    {
      for(int i = 0; i < TPR; i++)
      {
        if (!tileBoard[i][j].isEmpty())
        {
          rowIsEmpty = false;
          break;
        }
      }
      j++;
    }
    j-=2;
    if (j<0)
      j=0;
    for(int i = 0; i < TPR; i++)
    {
        temp = new Tile(int(random(1,TILE_COLORS)));
        tileBoard[i][j] = temp;
        temp.animate(newRowAnimationX(i),newRowAnimationY(i));
        Chain newCh = new Chain(player1);
        newCh.addTile(temp);
    }
    
    //Player 2
    j=MAX_R-1;
    rowIsEmpty=true;
    while (rowIsEmpty)
    {
      for(int i = 0; i < TPR; i++)
      {
        if (!tileBoard[i][j].isEmpty())
        {
          rowIsEmpty = false;
          break;
        }
      }
      j--;
    }
    j+=2;
    if (j>=MAX_R)
      j = MAX_R-1;
    for(int i = 0; i < TPR; i++)
    {
        temp = new Tile(int(random(1,TILE_COLORS)));
        tileBoard[i][j] = temp;
        temp.animate(newRowAnimationX(i),-newRowAnimationY(i));
        Chain newCh = new Chain(player1);
        newCh.addTile(temp);
    }
  }
  
  public int newRowAnimationX(int i) //Animation formulas
  {
    return 2*(4-i);
  }
  
  public int newRowAnimationY(int i)
  {
    return 8;
  }
  
  /************************************************************
  * Checks to make sure tiles can be swapped, then swaps two adjacent tiles
  *
  * Author: JM
  */
  public boolean swap(int a, int b, int row) //Swap tile at xcoord a with tile at xcoord b on a row
  {
    Player p = null;
    if ((a < 0)||(a>=TPR)||(b < 0)||(b>=TPR)||(row < 0)||(row >=MAX_R)||(row == lineOfGravity)) //if a, b, or row are out of range
      return false; //tell caller swap did not succeed
    if ((tileAt(a,row) == null)||(tileAt(b,row) == null)) //if these tiles somehow don't exist
      return false;
    if (abs(a-b)!=1) //if a is not adjacent to b
      return false;
    if (!((tileAt(a,row).swappable())&&(tileAt(b,row).swappable()))) //if either block is not swappable
      return false;
    if ((tileAt(a,row).getTileType() == 0)&&(tileAt(b,row).getTileType() == 0))
      return false;
    Chain c = null;

    if (row < lineOfGravity)
    {
      p = player1;
    }   
    else //(row > lineOfGravity)
    {
      p = player2;
    }
    c = new Chain(p);
    Tile temp = tileAt(b,row);
    tileBoard[b][row] = tileAt(a,row);
    tileBoard[a][row] = temp;
     //------------------------CHAIN
    Tile[] chainTiles = new Tile[2];
    chainTiles[0] = tileBoard[b][row];
    chainTiles[1] = tileBoard[a][row];
    c.addTiles(chainTiles);
    tileBoard[b][row].animate(b-a,0,p.speedModifier);
    tileBoard[a][row].animate(a-b,0,p.speedModifier);
    
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
      Tile fallingTile = tileBoard[x][j];
      Tile emptyTile = tileBoard[x][j-iter];
      if ((!fallingTile.swappable())||(fallingTile.getTileType() == 0))
        break;
      Chain ftc = emptyTile.getChainID();
      Chain etc = fallingTile.getChainID();
      if (ftc != null)
      {
        Chain largest = ftc.getLargerChain(etc);
        ftc.addTile(fallingTile);
      }
      tileBoard[x][j-iter] = fallingTile; //Moves the falling tile into the empty tile's spot
      fallingTile.animate(0,-iter); //Animates the falling tile to make it look as if it is falling from its original location
      if (tileBoard[x][j].getTileType() != EMPTY)
        blockHasFallen = true;
      //if (emptyTile.getTileType() == 0)  
      //  emptyTile.delete();  
    }
    tileBoard[x][j-iter] = new Tile(EMPTY); // space from which last block fell
    return blockHasFallen;
  }
  
  public Tile[][] getGameBoard()
  {
    return tileBoard;
  }
  
  public boolean isNotInPuzzle(Tile t)
  {
    for(int i = 0; i < TPR; i++)
    {
      for(int j = 0; j < MAX_R; j++)
      { 
        if (tileAt(i,j) == t)
          return false;
      }
    }
    return true;
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
  
  private Player playerAtY(int y)
  {
    if (y > lineOfGravity)
      return player2;
    if (y < lineOfGravity)
      return player1;  
    return null;  
  }
  
  public void clearer()
  {
    Tile thisTile;
    for(int i = 0; i < TPR; i++)
    {
      for(int j = 0; j < MAX_R; j++)
      {
        thisTile = tileAt(i,j);
        if ((thisTile.getTileType()!=EMPTY)&&(thisTile.swappable())&&(!thisTile.isMarked()))
        {
         directionalCheck(i,j);
        }
        
      }
    }
  }
  private void directionalCheck(int x, int y)
  {
    int nx = x;
    int ny = y;
    int c = 1;
    Tile temp = tileAt(x,y);
    Chain ch = temp.getChainID();
    ArrayList tiles = new ArrayList();
    tiles.add(temp);
    while ((nx+1 < TPR)&&(temp.isMatch(tileAt(nx+1,y))))
    {
      c++;
      temp = tileAt(nx+1,y);
      if (ch == null)
        ch = temp.getChainID();
      else
        ch = ch.getLargerChain(temp.getChainID());
      tiles.add(temp);
      nx+=1;
    }
    if (c >= 3)
    {
      for (int j=0;j<tiles.size();j++)
      {
        temp = (Tile)tiles.get(j);
        Player p = null;
        if (ch != null)
        {
          ch.addTile(temp);
          p = ch.getPlayer();
        }
        temp.mark();
        activatePowerup(temp,p);
      }
      if (c>=5)
      {
        temp = (Tile)tiles.get(tiles.size()/2);
        temp.convertToPowerup();
      }
      if (ch != null)
      {
        ch.increaseTotal(c);
        ch.incrementChain();
      }
    } 
    c=1;
    ch = temp.getChainID();
    tiles.clear();
    temp = tileAt(x,y);
    tiles.add(temp);
    while ((ny+1 < MAX_R)&&(temp.isMatch(tileAt(x,ny+1))))
    {
      c++;
      temp = tileAt(x,ny+1);
      if (ch == null)
        ch = temp.getChainID();
      else
        ch = ch.getLargerChain(temp.getChainID());
      tiles.add(temp);
      ny+=1;
    } 
    if (c >= 3)
    {
      
      for (int j=0;j<tiles.size();j++)
      {
        temp = (Tile)tiles.get(j);
        Player p = null;
        if (ch != null)
        {
          ch.addTile(temp);
          p = ch.getPlayer();
        }
        temp.mark();
        activatePowerup(temp,p);
      }
      if (c>=5)
      {
        temp = (Tile)tiles.get(tiles.size()/2);
        temp.convertToPowerup();
      }
      if (ch != null)
      {
        ch.increaseTotal(c);
        ch.incrementChain();
      }
    }
  }
  
  private void activatePowerup(Tile t, Player p) 
  {
    int effect = t.getPowerUpEffect();
    if ((effect == NONE)||(p == null))
      return;
    if (effect == SLOW)
    {
      otherPlayer(p).speedModifier = 0.5;
      otherPlayer(p).speedEffectDuration = 10000;
    }
    if (effect == FAST)
    {
      p.speedModifier = 2;
      p.speedEffectDuration = 10000;
    }
    if (effect == STEAL)
    {
      if (p==player1)
        lineOfGravity += 1;
      if (p==player2)
        lineOfGravity -= 1; 
    }
    if (effect == BLIND)
    {
      otherPlayer(p).blind = true;
      otherPlayer(p).blindEffectDuration = 10000;
    }
    if (effect == FREEZE)
    {
      otherPlayer(p).freeze = true;
    }
        
  }
  
  private Player otherPlayer(Player p)
  {
    if (p == player1)
      return player2;
    if (p == player2)
      return player1;  
    return null;
  }
  
  /*private int directionalCheck(int x, int y, int type, int direction, int n) {
    int c;
    Tile thisTile = tileAt(x,y);
    if (ch == null)
      ch = thisTile.getChainID();
    else
      ch = ch.getLargerChain(thisTile.getChainID());  
    if(direction == HORIZONTAL)
    {
      if (x+1 >= TPR)
        c = n;
      else if (thisTile.isMatch(tileAt(x+1,y))) // also checks if other tile is 
        c = directionalCheck(x+1,y,type,HORIZONTAL,n+1);
      else
        c = n;    
    }
    else if(direction == VERTICAL)
    {
      if (y+1 >= MAX_R)
        c = n;
      else if (thisTile.isMatch(tileAt(x,y+1))) // also checks if other tile is swappable
        c = directionalCheck(x,y+1,type,VERTICAL,n+1);
      else
        c = n;
    }
    else {
      println("Bad directionalCheck call, check direction parameter");
      return n;  
    }
    
    if (c >= 3)
    {
      if (ch != null)
      {
        print("awesome");
        ch.addTile(thisTile);
      }
      thisTile.mark();
    }
      return c; 
  }*/
  
  
  public int checkLoss()
  {
    //print("\n" +tileBoard[0][0].getMyX());
    ///print("\n" +tileBoard[0][MAX_R-1].getMyX());
    Tile tempLeft = null;
    Tile tempRight = null;
    for(int i = 0; i < MAX_R/2; i++)
    {
      for(int j = 0; j < TPR; j++)
      {
        if(this.tileBoard[j][i].getTileType() != 0 && this.tileBoard[j][i].isIdle()) 
        {
          tempLeft = tileBoard[j][i];
          i = MAX_R;
          break;
        }
      }
    }
    for(int i = MAX_R-1; i > MAX_R/2; i--)
    {
      for(int j = 0; j < TPR; j++)
      {
        if(this.tileBoard[j][i].getTileType() != 0 && this.tileBoard[j][i].isIdle()) 
        {
          tempRight = tileBoard[j][i];
          i = 0;
          break;
        }
      }
    }
    if(tempLeft.getMyX() < 0)
    {
      println(player1.getName() + " loses...");
      return 1;
    }
    if(tempRight.getMyX() > screen.width - TILE_SIZE)
    {
      println(player2.getName() + " loses...");
      return 2;
    }
    //Debugging
    //print("\nno loss");
    return 0;
  }
  
}

