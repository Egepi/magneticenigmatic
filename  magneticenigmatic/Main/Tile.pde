/* Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: March 3, 2010
 * Class - Tile: Tiles are the pieces of the puzzle. Tiles are not aware of where they are, only of what type they are and what state they are in.
*/
class Tile
{
  //private int TILE_WIDTH = 50;  All tiles should be square and 
  //private int TILE_HEIGHT = 50; have identical dimensions; unnec. var.
  private PImage tileImage;
  private int tileType;
  private boolean isMoving;
  
  /************************************************************
  * Constructor for Tile class.
  */  
  Tile(int theType)
  {
    tileImage = tileImageType[theType];
    tileType = theType;
    isMoving = false; //Set to true when tile is animating (falling or swapping)
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
  
  public boolean swappable()
  {
    return (!isMoving);
  }
}
