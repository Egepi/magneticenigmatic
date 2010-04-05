/* Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: March 3, 2010
 * Class - Tile: Tiles are the pieces of the puzzle. Tiles are not aware of where they are, only of what type they are and what state they are in.
*/


class Tile
{
  static final int DONE_ANIMATING = 4,
                   ANIMATING = 3,
                   DOUBLE_MARKED = 2,
                   MARKED = 1,
                   IDLE = 0;
  
  private PImage tileImage;
  private int tileType;
  private boolean isMoving, isIdle;
  private int state;
  private Chain chainID;
  private double ax,ay; //ax is the horizontal offset, ay is the vertical offset (viewing from short side of table)
  private int myX;
  
  /************************************************************
  * Constructor for Tile class.
  */  
  Tile(int theType)
  {
    tileImage = tileImageType[theType];
    tileType = theType;
    isIdle = true;
    isMoving = false; //Set to true when tile is animating (falling or swapping)
    chainID = null;
    state = IDLE;
  }
  
  public void action() {
    if ((state == MARKED)||(state == DOUBLE_MARKED))
    {
      tileType = 0;
      state = DONE_ANIMATING;
    }
    else if (state == ANIMATING)
    {
      if (abs((float)ax)>=0)
      {
        if (ax < 0)
        {
           ax += 0.01*MAX_TILE_V*timeDifference()/10;
           if (ax > 0)
             ax = 0;
        }
        else
        {
           ax -= 0.01*MAX_TILE_V*timeDifference()/10;
           if (ax < 0)
             ax = 0;
        }  
      }
      if (abs((float)ax)>=0)
      {
        if (ay < 0)
        {
           ay += 0.01*MAX_TILE_V*timeDifference()/10;
           if (ay > 0)
             ay = 0;
        }
        else
        {
           ay -= 0.01*MAX_TILE_V*timeDifference()/10;
           if (ay < 0)
             ay = 0;
        }  
      }
      if ((abs((float)ax)<=0.001)&&(abs((float)ay)<=0.001))
      {
        ax = 0;
        ay = 0;
        state = DONE_ANIMATING;
      }
    }
    else if (state == DONE_ANIMATING)
    {
      isMoving = false;
      state = IDLE;
    }
    else if (state == IDLE)
    {
      isIdle = true;
      isMoving = false;
    }
  }
  
  public void animate(int dx, int dy) {
    if (ANIMATIONS_ON) {
      state = ANIMATING;
      isMoving = true;
      isIdle = false;
      ax = (double)dx;
      ay = (double)dy;
    }
    else {
      state = DONE_ANIMATING;
    }
  }
  
  public void drawTile(int tempX, int tempY) {
    myX = tempX-(int)(ay*TILE_SIZE);
    if (tileImage != null)
    {
      image(tileImage,tempX-(int)(ay*TILE_SIZE),tempY-(int)(ax*TILE_SIZE),TILE_SIZE,TILE_SIZE);
      
    }
    if ((chainID != null)&&(DEBUG_MODE_ON))
        line(tempX+10,tempY+10,chainList.indexOf(chainID)*20+10,10); 
  }
    
  public void mark() {
    if (state == ANIMATING)
      print("unacceptable state change");
    if (state == MARKED)
      state = DOUBLE_MARKED;
    else
      state = MARKED;  
  }
  
  public void convertToPowerup() {
    tileType += 5;
    setTileImage(tileType);
    state = IDLE;
  }
  
  public boolean swappable()
  {
    return (!isMoving);
  }
  
  public boolean isIdle()
  {
    return (isIdle);
  }
  
  public boolean isMarked()
  {
    return (state == MARKED);
  }
  
  /************************************************************
  * Generic get() and set() methods for private variables in Tile class
  *
  * Author: Todd Silvia
  */  
  
  public PImage getTileImage()
  {
    return tileImage;
  }
  
  public void setTileImage(PImage tempImage)
  {
    this.tileImage = tempImage;
  }
  
  public void setTileImage(int tempImage)
  {
    this.tileImage = tileImageType[tempImage];
  }
  
  public boolean isMatch(Tile other) {
    return ((isMatch(other.tileType))&&(other.swappable()));
  }
  
  public boolean isMatch(int type){
    if (type == tileType)
      return true;
    return false;  
  }
  
  public int getTileType()
  {
    return this.tileType;
  }
  
  public boolean isEmpty()
  {
    return (this.tileType==0);
  }
  public int getState()
  {
    return this.state;
  }
  
  public void setChainID(Chain c)
  {
    chainID = c;
  }
  
  public Chain getChainID()
  {
    return chainID;
  }
  
  public void setTileType(int newType)
  {
    this.tileType = newType;
  }
  
  public int getMyX()
  {
    return myX;
  }
  
  public void delete()
  {
    state = IDLE;
    tileType = 0;
    if (chainID != null)
      chainID.removeTile(this);
    chainID = null;
  }
  
  
}