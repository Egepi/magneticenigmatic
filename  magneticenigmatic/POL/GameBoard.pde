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
   plyOneMove = 0;
   plyTwoMove = 0;
   lineOfGravity = MAX_R/2;
   timeBetweenRows = MAX_TIME_BETWEEN_ROWS;
   chainList = new ArrayList();
   selList = new ArrayList();
   pOneUp = new ArrayList();
   pTwoUp = new ArrayList();
}
  
  /************************************************************
  * Traverses the entire GameBoard and prints it to the screen.
  *
  * Author: Todd Silvia
  */
  public void drawBoard()
  {
    int tempX = PUZZLE_ORIGIN_X+(int)(theMomentum.incrementY());
    int tempY;
    boolean blind;
    for (int d = 0; d < 3; d++)
    {
      tempX = PUZZLE_ORIGIN_X+(int)(theMomentum.getY());
      tempY = PUZZLE_ORIGIN_Y;
      for(int x = 0; x < TPR; x++)
      {
        for(int y = 0; y < MAX_R; y++)
        {
          if (tileBoard[x][y].depth == d)
          {
            tileBoard[x][y].action();
            blind = false;
            Player p = playerAtY(y);
            if (p!= null)
            {
              blind = p.blind;
            }
            tileBoard[x][y].drawTile(tempX,tempY,blind);
          }
          tempX = tempX + TILE_SIZE;
        }
        tempY = tempY + TILE_SIZE;
        tempX = PUZZLE_ORIGIN_X+(int)(theMomentum.getY());
      }
    }
    
   fill(0,0,0,128);
   rect(PUZZLE_ORIGIN_X + lineOfGravity*TILE_SIZE + (int)(theMomentum.getY()), 0, TILE_SIZE, height);
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
      for(int j = lineOfGravity-START_R/2; j < lineOfGravity+START_R/2+1; j++)
      {
        tileBoard[i][j] = new Tile(int(random(1,TILE_COLORS)));
      }
    }
    boolean clean = false;
    while (!clean)
    {
      clean = true;
      for(int i = 0; i < TPR; i++)
      {
        for(int j = lineOfGravity-START_R/2; j < lineOfGravity+START_R/2+1; j++)
        {
          while (makesCombo(i,j) == true)
          {
            clean = false;
            tileBoard[i][j] = new Tile(int(random(1,TILE_COLORS)));
          }
        }
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
        temp = new Tile(int(random(1,TILE_COLORS)),player1.freeze,player1.speedModifier);
        tileBoard[i][j] = temp;
        temp.animate(newRowAnimationX(i),newRowAnimationY(i));
        Chain newCh = new Chain(player1);
        newCh.addTile(temp);
    }
    player1.freeze = false;
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
        temp = new Tile(int(random(1,TILE_COLORS)),player2.freeze,player2.speedModifier);
        tileBoard[i][j] = temp;
        temp.animate(newRowAnimationX(i),-newRowAnimationY(i));
        Chain newCh = new Chain(player2);
        newCh.addTile(temp);
    }
    player2.freeze = false;
  }
  
  public int newRowAnimationX(int i) //Animation formulas
  {
    return 2*(TPR/2-i)-1;
  }
  
  public int newRowAnimationY(int i)
  {
    return TPR;
  }
  
  /************************************************************
  * Checks to make sure tiles can be swapped, then swaps two adjacent tiles
  *
  * Author: JM
  */
  public boolean swap(int x1, int x2, int y1, int y2)
  {
    if (x1==x2)
      return swapC(y1,y2,x1);
   else if (y1==y2)
      return swapR(x1,x2,y1);   
   else 
      return false;   
  }
  
  public boolean swapR(int a, int b, int row) //Swap tile at xcoord a with tile at xcoord b on a row
  {
    Player p = null;
    if ((a < 0)||(a>=TPR)||(b < 0)||(b>=TPR)||(row < 0)||(row >=MAX_R)||(row == lineOfGravity)) //if a, b, or row are out of range
      return false; //tell caller swap did not succeed
    if ((tileAt(a,row) == null)||(tileAt(b,row) == null)) //if these tiles somehow don't exist
      return false;
    if ((abs(a-b)!=1)) //if a is not adjacent to b
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
    if (tileAt(a,row).getTileType() == 0)
      tileBoard[b][row].animate(b-a,0,p.speedModifier);
    else if (tileAt(b,row).getTileType() == 0)
      tileBoard[a][row].animate(a-b,0,p.speedModifier);  
    else
    {
      tileBoard[b][row].swapAnimate(b-a,p.speedModifier,p);
      tileBoard[a][row].swapAnimate(a-b,p.speedModifier,p);
    }
    
    return true;
  }
  
  public boolean swapC(int a, int b, int col) //Swap tile at ycoord a with tile at ycoord b on a col
  {
    if (VERTICAL_SWAPS_ON == false)
      return false;
    Player p = null;
    if ((a < 0)||(a>=MAX_R)||(b < 0)||(b>=MAX_R)||(col < 0)||(col >=TPR)||(a == lineOfGravity)||(b == lineOfGravity)) //if a, b, or row are out of range
      return false; //tell caller swap did not succeed
    if ((tileAt(col,a) == null)||(tileAt(col,b) == null)) //if these tiles somehow don't exist
      return false;
    if ((abs(a-b)!=1)) //if a is not adjacent to b
      return false;
    if (!((tileAt(col,a).swappable())&&(tileAt(col,b).swappable()))) //if either block is not swappable
      return false;
    if ((tileAt(col,a).getTileType() == 0)||(tileAt(col,b).getTileType() == 0))
      return false;
    Chain c = null;

    if (a < lineOfGravity)
    {
      p = player1;
    }   
    else //(a > lineOfGravity)
    {
      p = player2;
    }
    c = new Chain(p);
    Tile temp = tileAt(col,b);
    tileBoard[col][b] = tileAt(col,a);
    tileBoard[col][a] = temp;
     //------------------------CHAIN
    Tile[] chainTiles = new Tile[2];
    chainTiles[0] = tileBoard[col][b];
    chainTiles[1] = tileBoard[col][a];
    c.addTiles(chainTiles);
    tileBoard[col][b].animate(0,b-a,p.speedModifier);
    tileBoard[col][a].animate(0,a-b,p.speedModifier); 
    
    return true;
  }
  
  public boolean swap(Selector s1, Selector s2) //attempt to swap the selected tiles if the selectors are on the same row
  {
    return swap(s1.getX(),s2.getX(),s1.getY(),s2.getY());
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
    double speed = 1.0;
    boolean blockHasFallen = false;
    if (tileBoard[x][y].getTileType() != EMPTY)
      return blockHasFallen;
    if (!tileBoard[x][y].canFall())
      return blockHasFallen;
    int furthest,nearest;
    if (g > y) {
      nearest = y-1; //the first block to iterate
      furthest = -1; //the one beyond the last block (out of array bounds)
      iter = -1; //the direction the iterator needs to go
      speed = player1.speedModifier;
    }
    else if(g < y ){
      nearest = y+1;
      furthest = MAX_R;
      iter = 1;
      speed = player2.speedModifier;
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
        speed = player1.speedModifier;
      }
      else
      {
        nearest = y+1;
        furthest = MAX_R;
        iter = 1;   
        speed = player2.speedModifier;     
      }
    }
    int j;
    for (j=nearest; j!=furthest; j+=iter)
    {
      Tile fallingTile = tileBoard[x][j];
      Tile emptyTile = tileBoard[x][j-iter];
      if ((!fallingTile.canFall())||(fallingTile.getTileType() == 0))
        break;
      Chain ftc = emptyTile.getChainID();
      Chain etc = fallingTile.getChainID();
      if (ftc != null)
      {
        Chain largest = ftc.getLargerChain(etc);
        ftc.addTile(fallingTile);
      }
      tileBoard[x][j-iter] = fallingTile; //Moves the falling tile into the empty tile's spot
      fallingTile.animate(0,-iter,speed); //Animates the falling tile to make it look as if it is falling from its original location
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
  
  /************************************************************
  * This function goes through every tile on a game board and runs a directionalCheck() on it.
  *
  * Author: JM
  */
  public void clearer()
  {
    Tile thisTile;
    for(int i = 0; i < TPR; i++)
    {
      for(int j = 0; j < MAX_R; j++)
      {
        thisTile = tileAt(i,j);
        if ((thisTile.getTileType()!=EMPTY)&&(thisTile.canFall())&&(!thisTile.isMarked(HORIZONTAL)))
        {
         directionalCheck(i,j,HORIZONTAL);
        }
        if ((thisTile.getTileType()!=EMPTY)&&(thisTile.canFall())&&(!thisTile.isMarked(VERTICAL)))
        {
         directionalCheck(i,j,VERTICAL);
        }
      }
    }
  }
  
  /************************************************************
  * Starting at the specified tile, this function checks vertically or horizonatally for matching tiles.
  * if 3 or more are detected, it marks the tiles to be cleared.
  *
  * Author: JM
  */
  private void directionalCheck(int x, int y,int d) //returns true if there is a clear
  {
    int nx = x; 
    int ny = y;
    int c = 1; //This is the matching tile combination total, it starts at one, because there will always be one tile of this color
    Tile temp = tileAt(x,y); //temp starts at the tile specified in the paramter
    Tile powerup = null;
    Chain ch = temp.getChainID(); //We need the chainID of each tile so we can determine which has the higher priority, this is just the first one for comparison (ch can be null)
    ArrayList tiles = new ArrayList(); //tiles will hold our combination so we can access them anywhere in the function
    tiles.add(temp); // Adds the first tile to the arraylist
    if (d == HORIZONTAL)
    {
      while ((nx+1 < TPR)&&(temp.isMatch(tileAt(nx+1,y)))&&(!tileAt(nx+1,y).isMarked(d))) //While the coordinates are inbounds and the next tile over is a match
      {
        c++;
        temp = tileAt(nx+1,y);
        //This If-Else gets the chain ID with the highest priority, or highest total number of blocks. Turn on debug mode to see this in action.
        if (ch == null)
          ch = temp.getChainID();
        else
          ch = ch.getLargerChain(temp.getChainID());
        tiles.add(temp); //Adds our new tile to the arraylist
        nx+=1;
      }
      //Check a row clear for 3 or more tiles
      if (c >= 3)
      {
        for (int j=0;j<tiles.size();j++) //iterates through the tiles
        {
          temp = (Tile)tiles.get(j);
          Player p = null;
          if (ch != null) //You need these statements or else you get nasty errors
          {
            ch.addTile(temp); 
            p = ch.getPlayer(); //Gets the player associates with the chain
          }
          temp.mark(d); //Marks the tile to be cleared (see the Tile FSM for case state==MARKED)
          activatePowerup(temp,p); //Activates any powerup tiles in the combo, does nothing if it isnt a powerup tile
        }
        //Check a row clear for 5 or more tiles, creates a powerup
        if (c>=5)
        {
          temp = (Tile)tiles.get(tiles.size()/2); //Picks the middle tile
          powerup = temp;
        }
        if (ch != null)
        {
          ch.increaseTotal(c); //Adds c tiles to the chain
          ch.incrementChain(); //Adds 1 combo to the chain
        }
      } 
    }
    else
    {
      while ((ny+1 < MAX_R)&&(temp.isMatch(tileAt(x,ny+1)))&&(!tileAt(x,ny+1).isMarked(d)))
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
          temp.mark(d);
          activatePowerup(temp,p);
        }
        if (c>=5)
        {
          temp = (Tile)tiles.get(tiles.size()/2);
          powerup = temp;
        }
        if (ch != null)
        {
          ch.increaseTotal(c);
          ch.incrementChain();
        }
      }
    }
    if (powerup != null)
      powerup.convertToPowerup();
  }
  
  private boolean makesCombo(int x, int y)
  {
    int nx = x; 
    int ny = y;
    int c = 1; //This is the matching tile combination total, it starts at one, because there will always be one tile of this color
    Tile temp = tileAt(x,y); //temp starts at the tile specified in the paramter
    while ((nx+1 < TPR)&&(temp.isMatch(tileAt(nx+1,y)))) //While the coordinates are inbounds and the next tile over is a match
    {
      c++;
      temp = tileAt(nx+1,y);
      nx+=1;
    }
    if (c >= 3)
      return true;
    c = 1;
    while ((ny+1 < MAX_R)&&(temp.isMatch(tileAt(x,ny+1))))
    {
      c++;
      temp = tileAt(x,ny+1);
      ny+=1;
    }
    if (c >= 3)
      return true;
    return false;  
  } 
  
  private void activatePowerup(Tile t, Player p) 
  {
    int effect = t.getPowerUpEffect();   
    
    if ((effect == NONE)||(p == null)) //Do nothing if there is not a plyer associated with this or if the block isn't a powerup
      return;
    
    if(p == player1)
    {
      PowerUp tempPow = new PowerUp(effect,p);
      //pOneUp.add(new PowerUp(effect, p));   
    }
    else
    {
      PowerUp tempPower = new PowerUp(effect,p);
      //pTwoUp.add(new PowerUp(effect, p));
    }
  }
  
  //Old recursive version
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
    if((tempLeft != null )&&(tempLeft.getMyX() < screen.width/DANGER_CUE))
    {
      if(STEREO_ON)
      {
        swapSongs(dangerBGP1);
      }
      else
      {
        swapSongs(dangerBG);
      }
    }
    else if(tempRight!= null &&(tempRight.getMyX() >= screen.width-screen.width/DANGER_CUE - TILE_SIZE))
    {
      if(STEREO_ON)
      {
        swapSongs(dangerBGP2);
      }
      else
      {
        swapSongs(dangerBG);
      }
    }
    else if((tempLeft != null)&&(tempLeft.getMyX() < screen.width/IMBALANCED_CUE)&&(tempLeft.getMyX() >= screen.width/DANGER_CUE))   
    {
      if(STEREO_ON)
      {
        swapSongs(imbalancedBGP1);
      }
      else
      {
        swapSongs(imbalancedBG);
      }
    }
    else if((tempRight != null)&&(tempRight.getMyX() >= screen.width-screen.width/IMBALANCED_CUE - TILE_SIZE)&&(tempLeft.getMyX() < screen.width-screen.width/DANGER_CUE - TILE_SIZE))
    {
      if(STEREO_ON)
      {
        swapSongs(imbalancedBGP2);
      }
      else
      {
        swapSongs(imbalancedBG);
      }
    }
    else 
    {
      swapSongs(balancedBG);
    }
    
    if((tempLeft != null )&&(tempLeft.getMyX() < 0))
    {
      player2.setRoundsWon(player2.getRoundsWon()+1);
      return 2;
    }
    if((tempRight != null )&&(tempRight.getMyX() > screen.width - TILE_SIZE))
    {
      player1.setRoundsWon(player1.getRoundsWon()+1);
      return 1;
    }
    return 0;
  }
  
  public void swapSongs(AudioPlayer newSong)
  {
    if ((currentlyPlaying != newSong)&&(SOUNDS_ON == true))
    {
      //newSong.play(currentlyPlaying.position());
      newSong.loop();
      currentlyPlaying.pause();
      currentlyPlaying = newSong;
    }
  }
  
}

