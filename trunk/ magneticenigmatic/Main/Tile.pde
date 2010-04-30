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
                   HMARKED = 5,
                   VMARKED = 6,
                   IDLE = 0;
  
  private PImage tileImage;
  private int tileType;
  private boolean isMoving, isIdle, isFrozen, isSwapping, swapLeft, swapUp;
  private int state;
  private Chain chainID;
  private double ax,ay,dr; //ax is the horizontal offset, ay is the vertical offset (viewing from short side of table)
  private int myX,myY;
  public int depth;
  private double speedModifier,sizeModifier;
  
  /************************************************************
  * Constructor for Tile class.
  */  
  Tile(int theType)
  {
    tileImage = tileImageType[theType];
    tileType = theType;
    isIdle = true; //Set to true when tile is swapping or will not be falling in the next frame
    isMoving = false; //Set to true when tile is animating (falling or swapping)
    isFrozen = false;
    isSwapping = false;
    swapLeft = false;
    depth = 1;
    sizeModifier = 1.0;
    chainID = null; //Chain currently associated with this tile
    state = IDLE;
    swapUp = false;
    speedModifier = 1.0;
  }
  
  Tile(int theType, boolean freeze, double sM)
  {
    tileImage = tileImageType[theType];
    tileType = theType;
    isIdle = true; //Set to true when tile is swapping or will not be falling in the next frame
    isMoving = false; //Set to true when tile is animating (falling or swapping)
    isFrozen = false;
    isSwapping = false;
    swapLeft = false;
    depth = 1;
    sizeModifier = 1.0;
    chainID = null; //Chain currently associated with this tile
    state = IDLE;
    swapUp = false;
    speedModifier = sM;
    if (freeze)
    {
      isFrozen = true;
      tileImage = iceArray[theType-1];
    }
      
  }
  
  public void action() {
    if ((state == HMARKED)||(state == VMARKED))
    {
      tileType = 0;
      AnimationClear ac = new AnimationClear(tileImage,myX,myY);
      animationList.add(ac);
      state = DONE_ANIMATING;
    }
    else if (state == DOUBLE_MARKED)
    {
      convertToPowerup();
    }
    else if (state == ANIMATING)
    {
      if (!isSwapping)
      {
        if (abs((float)ax)>=0)
        {
          if (ax < 0)
          {
             ax += 0.001*MAX_TILE_V*timeDifference()*speedModifier;
             if (ax > 0)
               ax = 0;
          }
          else
          {
             ax -= 0.001*MAX_TILE_V*timeDifference()*speedModifier;
             if (ax < 0)
               ax = 0;
          }  
        }
        if (abs((float)ax)>=0)
        {
          if (ay < 0)
          {
             ay += 0.001*MAX_TILE_V*timeDifference()*speedModifier;
             if (ay > 0)
               ay = 0;
          }
          else
          {
             ay -= 0.001*MAX_TILE_V*timeDifference()*speedModifier;
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
      else
      {
        dr+=0.0031*MAX_TILE_V*timeDifference()*speedModifier;
        if (dr < PI)
        {
          if (swapUp)
          {
            if (swapLeft)
            {
              ax = 0.5-0.5*cos((float)dr+PI);
              ay = 0.25*sin((float)dr);
              sizeModifier = 1.0+ay;
              ay*=1.5;
              depth = 2;
            }
            else
            {
              ax = 0.5*cos((float)dr+PI)-0.5;
              ay = -0.25*sin((float)dr);
              sizeModifier = 1.0+ay;
              ay*=1.5;
              depth = 0;
            }
          }
          if (!swapUp)
          {
            if (swapLeft)
            {
              
              ax = 0.5+0.5*cos((float)dr);
              ay = 0.25*sin((float)dr);
              sizeModifier = 1.0-ay;
              depth = 0;
            }
            else
            {
              ax = -0.5*cos((float)dr)-0.5;
              ay = -0.25*sin((float)dr);
              sizeModifier = 1.0-ay;
              depth = 2;
            }
          }
        }
        if (dr >= PI)
        {
          dr = PI;
          ax = 0;
          ay = 0;
          sizeModifier = 1.0;
          depth = 1;
          state = DONE_ANIMATING;
          isSwapping = false;
        }
      }
      
    }
    else if (state == DONE_ANIMATING) //DONE_ANIMATING and IDLE need to be different so a chain can tell the difference between a tile in transition and a tile that is truly not going to move again.
    {
      isMoving = false; //Tile is NOT idle yet because it could still fall further
      state = IDLE; //If the tile is still falling the state should go back to ANIMATING before the next frame
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
  
  public void swapAnimate(int dx, double modifier, Player p) {
    if (ANIMATIONS_ON) {
      state = ANIMATING;
      isMoving = true;
      isIdle = false;
      ax = (double)dx;
      ay = 0;
      dr = 0;
      if (p == player1)
        swapUp = true;
      else
        swapUp = false;  
      if (dx >0)
        swapLeft = true;
      else
        swapLeft = false;
      isSwapping = true;
      speedModifier = modifier;
    }
    else {
      state = DONE_ANIMATING;
    }
  }
  
  public void animate(int dx, int dy, double modifier) {
    animate(dx,dy);
    speedModifier = modifier;
  }
  
  public void drawTile(int tempX, int tempY, boolean blind) {
    myX = tempX-(int)(ay*TILE_SIZE);
    myY = tempY-(int)(ax*TILE_SIZE);
    if ((!blind)&&(tileImage != null))
    {
      /*if (isFrozen)
      {
        tileImage = tileImageType[theType];
      }
      else*/
        image(tileImage,tempX-(int)(ay*TILE_SIZE),tempY-(int)(ax*TILE_SIZE),(int)(sizeModifier*TILE_SIZE),(int)(sizeModifier*TILE_SIZE));
    }
    else if ((blind)&&(tileImage != null))
    {
      image(colorlessTile,tempX-(int)(ay*TILE_SIZE),tempY-(int)(ax*TILE_SIZE),(int)(sizeModifier*TILE_SIZE),(int)(sizeModifier*TILE_SIZE));
    }
    /*if (tileImage != null)
    {
      stroke(0);
      strokeWeight(2);
      ellipseMode(CORNER);
      noFill();
      ellipse(tempX-(int)(ay*TILE_SIZE),tempY-(int)(ax*TILE_SIZE),(int)(sizeModifier*TILE_SIZE),(int)(sizeModifier*TILE_SIZE));
    }*/
    if ((chainID != null)&&(DEBUG_MODE_ON))
        line(tempX+10,tempY+10,chainList.indexOf(chainID)*20+10,10); 
  }
  
 
  public void mark(int d) {  //Mark this tile to be cleared
    if (state == ANIMATING)
      print("unacceptable state change"); //Shouldn't happen
    if (((d == HORIZONTAL)&&(state == VMARKED))||((d == VERTICAL)&&(state == HMARKED)))
      state = DOUBLE_MARKED;  //This tile has been marked more than once
    else if (d == HORIZONTAL)
    {
      state = HMARKED;  
    }
    else if (d == VERTICAL)
    {
      state = VMARKED;  
    }
    isIdle = false;
  }
  
  public void convertToPowerup() {
    if ((tileType < TILE_COLORS)&&(tileType > 0))
      tileType += (TILE_COLORS-1);
    setTileImage(tileType);
    state = DONE_ANIMATING;
    isIdle = false;
  }
  
  public boolean canFall()
  {
    return (!isMoving);
  }
  
  public boolean swappable()
  {
    return ((isIdle)&&(!isMoving)&&(!isFrozen));
  }
  
  public boolean isIdle()
  {
    return (isIdle);
  }
  
  public boolean isMarked(int d)
  {
    if (state == DOUBLE_MARKED)
      return true;
    if (d == HORIZONTAL)
      return (state == HMARKED);
    //if (d == VERTICAL)
    return (state == VMARKED);
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
    return ((isMatch(other.tileType))&&(other.canFall()));
  }
  
  public boolean isMatch(int type){
    if (type == tileType)
      return true;
    if ((tileType>0)&&(type>0)&&(tileType%5 == type%5))
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
  
  public int getPowerUpEffect()
  {
    if (tileType <= 5)
      return NONE;
    return NONE+tileType;  
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

