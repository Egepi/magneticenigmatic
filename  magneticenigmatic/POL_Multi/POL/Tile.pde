/* Game: POL v 2.0
 * Class: Tile
*/

class Tile {
  private int tileType;
  
  public Tile(int theType) {
    tileType = theType;
  }//End Tile()
  
  public void drawTile(theX, theY) {
    image(tileImageType[tileType], theX, theY);
  }//End drawTile()
  
}//End Tile{}
