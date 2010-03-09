/* Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: March 3, 2010
 * Class - Tile: Tiles are the pieces of the puzzle. Tiles are not aware of where they are, only of what type they are and what state they are in.
*/


class Tile
{
  static final int DOUBLE_MARKED = 3,
                   ANIMATING = 2,
                   MARKED = 1,
                   IDLE = 0,
                   EMPTY = -1; 
  
  private PImage tileImage;
  private int tileType;
  private boolean isMoving;
  private int state;
  private double ax,ay; //ax is the horizontal offset, ay is the vertical offset (viewing from short side of table)
  
  /************************************************************
  * Constructor for Tile class.
  */  
  Tile(int theType)
  {
    tileImage = tileImageType[theType];
    tileType = theType;
    isMoving = false; //Set to true when tile is animating (falling or swapping)
    state = IDLE;
  }
  
  public void action() {
    if ((state == MARKED)||(state == DOUBLE_MARKED))
    {
      tileType = 0;
      state = EMPTY;
    }
    else if (state == ANIMATING)
    {
      if (abs((float)ax)>=0.001)
      {
        if (ax < 0)
           ax += 0.01;
        if (ax > 0)
           ax -= 0.01;   
        //print(ax);   
      }
      if (abs((float)ay)>=0.001)
      {
        if (ay < 0)
           ay += 0.01;
        if (ay > 0)
           ay -= 0.01;   
        //print(ay);   
      }
      if ((abs((float)ax)<=0.001)&&(abs((float)ay)<=0.001))
      {
        isMoving = false;
        state = IDLE;
      }
    }
  }
  
  public void animate(int dx, int dy) {
    state = ANIMATING;
    isMoving = true;
    ax = (double)dx;
    ay = (double)dy;
  }
  
  public void drawTile(int tempX, int tempY) {
    image(tileImage,tempX-(int)(ay*TILE_SIZE),tempY-(int)(ax*TILE_SIZE),TILE_SIZE,TILE_SIZE);
  }
  
  public void mark() {
    if (state == MARKED)
      state = DOUBLE_MARKED;
    else
      state = MARKED;  
  }
  
  public boolean swappable()
  {
    return (!isMoving);
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
  
  public int getTileType()
  {
    return this.tileType;
  }
  
  public void setTileType(int newType)
  {
    this.tileType = newType;
  }
  
  
}
