/* Game: POL v 2.0
 * Class: Tile
*/

class Tile {
  private int tileType;
  public int depth = 0;
  public Tile(int theType) {
    tileType = theType;
  }//End Tile()
  
  public void drawTile(int theX, int theY) {
    if(tileType != 0)
    {
      image(tileImageType[tileType], theX, theY);
    }
  }//End drawTile()
  
}//End Tile{}
