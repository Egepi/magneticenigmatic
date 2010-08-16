/* Game: POL v 2.0
 * Class: GameFSM
 */

class GameFSM {
  private int stateId;
  private PImage backgroundPicture;
  
  public GameFSM() {
    stateId = 0;
  }//End GameFSM()
  
  /************************************************************
  */
  private void initState() {
    loadImages();
    stateId = 1;
  }//End initState()
  
  /************************************************************
  */
  private void menuState() {
    image(backgroundPicture,0,0);
  }//End menuState()
  
  /************************************************************
  */
  private void optionsState() {
    
  }//End optionsState()
  
  /************************************************************
  */
  private void creditsState() {
    
  }//End creditsState()
  
  /************************************************************
  */
  private void boardInitState() {
    
  }//End boardInitState()
  
  /************************************************************
  */
  private void gameState() {
    
  }//End gameState()
  
  /************************************************************
  */
  private void endGameState() {
    
  }//End endGameState()
  
  /************************************************************
  */
  public void action() {
    switch(stateId) {
      case 0: initState(); break;
      case 1: menuState(); break;
      case 2: optionsState(); break;
      case 3: creditsState(); break;
      case 4: boardInitState(); break;
      case 5: gameState(); break;
      case 6: endGameState(); break;
      default: break;
    }
  }//End action()
  
  private void loadImages() {
    //Load background
    backgroundPicture = loadImage("background1.png");
    backgroundPicture.resize(width, height);
    
    //Load images for Tiles
   /* if(TILE0 == null) {
       tileImageType[0] = null; 
    } else {
       tileImageType[0] = loadImage(TILE0); 
    }
    
    tileImageType[1] = loadImage(TILE1);
    tileImageType[2] = loadImage(TILE2);
    tileImageType[3] = loadImage(TILE3);
    tileImageType[4] = loadImage(TILE4);
    tileImageType[5] = loadImage(TILE5);
    tileImageType[6] = loadImage(TILE6);
    tileImageType[7] = loadImage(TILE7);
    tileImageType[8] = loadImage(TILE8);
    tileImageType[9] = loadImage(TILE9);
    tileImageType[10] = loadImage(TILE10);*/
  }
}//End GameFSM{}
