/* Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: March 3, 2010
 * Class - Selector: Follows the coordinate system of the Gameboard, holds coordinates for a currently selected tile
*/
class Selector{
  private int coordx;
  private int coordy;
  
  public Selector()
  {
    coordx = -1;
    coordy = -1;
  }
  
  public void setSelector(int x, int y) {
    coordx = x;
    coordy = y;
  }
  
  public void reset()
  {
    coordx = -1;
    coordy = -1;
  }
  
  public boolean isEqual(int x, int y)
  {
    return ((coordx == x)&&(coordy == y));
  }
  
  public boolean isEqual(Selector other)
  {
    return ((coordx == other.getX())&&(coordy == other.getY()));
  }
  
  public int getX() {
    return coordx;
  }
  
  public int getY(){
    return coordy;
  }
}

