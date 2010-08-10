/* Game: POL v 2.0
 * Class: GameFSM
 */

class GameFSM {
  private int stateId;
  
  public GameFSM() {
    stateId = 0;
  }//End GameFSM()
  
  /************************************************************
  */
  private void initState() {
    stateId = 1;
  }//End initState()
  
  /************************************************************
  */
  private void menuState() {
    background(255,255,100);
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
}//End GameFSM{}
