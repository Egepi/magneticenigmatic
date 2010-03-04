/* Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: March 3, 2010
 * Class - Tile: <Description goes here>
*/
class Tile
{
  private int TILE_WIDTH = 50;
  private int TILE_HEIGHT = 50;
  private PImage tileImage;
  private int tileType;
  
  /************************************************************
  * Constructor for Tile class.
  */  
  Tile(int theType)
  {
    if(theType == 1)
    {
      tileImage = loadImage("diamond.jpg");
    }
    else if(theType == 2)
    {
      tileImage = loadImage("ruby.jpg");
    }
    tileType = theType;
  }
  
  /************************************************************
  * Generic get() and set() methods for private variables in Tile class
  *
  * Author: Todd Silvia
  */  
  public int getTileHeight()
  {
    return this.TILE_HEIGHT;
  }
  
  public int getTileWidth()
  {
    return this.TILE_WIDTH;
  }
  
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
