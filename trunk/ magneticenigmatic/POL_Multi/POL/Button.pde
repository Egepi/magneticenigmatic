/* Game: POL v 2.0
 * Class: Button
 */
 
class Button {
  
  private PImage buttonImage;
  private float buttonX;
  private float buttonY;
  private int buttonWidth;
  private int buttonHeight;
  
  public Button(PImage theImage, float theX , float theY) {
    buttonImage = theImage;
    buttonX = theX;
    buttonY = theY;
    buttonWidth = theImage.width;
    buttonHeight = theImage.height;
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
  public void drawIt() {
    image(buttonImage, buttonX, buttonY, buttonWidth, buttonHeight);
  }//End drawIt()
  
  /**************************************************************
  * Checks if the button is being either clicked on or touched.
  * Returns 1 if the button has been clicked/touched else returns 0.
  */
  public int checkBounds() {
    if(touchInput) {
      if((touchInterface != null) && (! touchInterface.managedListIsEmpty() )) {
         touchList = touchInterface.getManagedList();
         
         //Cycle through the touches
         for(int index = 0; index < touchList.size(); index++) {
           Touches currentTouch = (Touches) touchList.get(index);
           if( currentTouch != null ){
             float xCoord = currentTouch.getXPos() * width;
             float yCoord = height - currentTouch.getYPos() * height;
             if( (xCoord >= buttonX) && (xCoord <= (buttonX + buttonWidth)) ) {
               if( (yCoord >= buttonY) && (yCoord <= ( buttonY + buttonHeight)) ) {
                 return 1; //The button in question was touched
               } 
             }
           } 
         }
      }
      return 0; //The the button in question was not touched
    } else {
      if(mousePressed) {
        int xCoord = mouseX;
        int yCoord = mouseY;
        if(( xCoord >= buttonX ) && ( xCoord <= (buttonX + buttonWidth ))) {
          if(( yCoord >= buttonY) && ( yCoord <= (buttonY + buttonHeight))) {
            return 1; //The button in question was clicked on
          }  
        }
      }
      return 0; //The button in question was NOT clicked on
    }
  }//End checkBounds()
  
}//End Button {}
