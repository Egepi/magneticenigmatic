/* Game: POL v 2.0
 * Class: Button
 */
 
class Button {
  
  private PImage buttonImage;
  private int buttonX;
  private int buttonY;
  private int buttonWidth;
  private int buttonHeight;
  
  public Button(PImage theImage, float theX , float theY) {
    buttonImage = theImage;
    buttonX = theX;
    buttonY = theY;
    buttonWidth = 100;
    buttonHeight = 100;
  }//End Button(PImage, float, float)
  
  public Button(PImage theImage, float theX, float theY, int theWidth, int theHeight) {
    buttonImage = theImage;
    buttonX = theX;
    buttonY = theY;
    buttonWidth = theWidth;
    buttonHeight = theHeight;
  }//End  Button(PImage, float, float, int, int)
  
  /**************************************************************
  * Draws the button object on the screen with given parameters
  */
  public drawIt() {
    image(buttonImage, buttonX, buttonY, buttonWidth, buttonHeight);
  }//End drawIt()
}//End Button {}
