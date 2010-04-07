/* Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: March 3, 2010
 * Class - GameFSM: <Description goes here>
*/
class GameFSM {
  private int stateId;
  PImage startButton;
  GameSounds clearSound;
  /************************************************************
  */
  public GameFSM()
  {
    stateId = 1;
    startButton = loadImage("start.png");
    clearSound = new GameSounds("splat.wav");
  }
  
  /************************************************************
  */
  public void startState()
  {
    int startX = screen.width/2 - startButton.width/2;
    int startY = screen.height/2 - startButton.height/2;
    image(startButton, startX, startY);
    if( ! connectToTacTile)
    {
      if(mousePressed)
      {
        int xCoord = mouseX;
        int yCoord = mouseY;
        if((xCoord >= startX)&&(xCoord <= (startX + startButton.width)))
        {
            if((yCoord >= startY)&&(yCoord <= (startY + startButton.height)))
            {
              stateId = stateId + 1;
              return;
            }
        }
      }
    }
        
    if ((tacTile != null)&&( ! tacTile.managedListIsEmpty() )){

      touchList = tacTile.getManagedList();
    
      // Cycle though the touches 
      for ( int index = 0; index < touchList.size(); index ++ ){
        Touches curTouch = (Touches) touchList.get(index);   
        if ( curTouch != null){
          float xCoord = curTouch.getXPos() * width;    
          float yCoord = height - curTouch.getYPos() * height;
          if((xCoord >= startX)&&(xCoord <= (startX + startButton.width)))
          {
            if((yCoord >= startY)&&(yCoord <= (startY + startButton.height)))
            {
              stateId = stateId + 1;
              return;
            }
          }
        }
      }
    }
    return;
  }
  
  /************************************************************
  */
  public void optionsState()
  {    
    strokeWeight(4);
    line((width/2 - 500), 500, (width/2 + 500), 500);
    strokeWeight(0);  
    stateId++;
  }
  
  /************************************************************
  */
  public void gameState()
  {
    textFont(font1);
    text("Player 1", (width/2 + 100), 10);
    clearSound.stopIfOver();
    gameGetInput();           //Get player(s) touch input
    theBoard.gravity();       //Apply gravity where needed
    //boolean playSound = theBoard.checkClears();   //Check for clears to be made
    theBoard.clearer();
    
    /*if(playSound == true)
    {
      clearSound.play();
    }*/
    theBoard.drawBoard();  //Draw the board
    drawChains();    
    player1.drawPlayer();
    player2.drawPlayer();
    if ((rowTimeDifference() > 10000)&&(ROW_GENERATION_ON))
    {
      lastRowTime += 10000;
      theBoard.generateRow();
    }
    //Check if either player lost
    if (theBoard.checkLoss() > 0)
    {
      stateId ++;
      return;
    }
    
         
  }
  
  /************************************************************
  */
  public void endRound()
  {
    
  }
  
  /************************************************************
  */
  public void endGame()
  {
    

  }
  
  /************************************************************
  */
  public int getId()
  {
    return stateId;
  }
  
  /************************************************************
  */
  public void action()
  {
    switch(stateId) {
      case 1: startState(); break;
      case 2: optionsState(); break;
      case 3: gameState(); break;
      case 4: endRound(); break;
      default: break;
    }
  }
  
  /************************************************************
  */
  void gameGetInput()
  {
    if (connectToTacTile)
      getTouches();
    else if (mousePressed)
    {
       int newx, newy;
       newx = (mouseY-PUZZLE_ORIGIN_Y)/TILE_SIZE;
       newy = (mouseX-PUZZLE_ORIGIN_X-(int)(theMomentum.getY()))/TILE_SIZE;
       if (sel1.getX() == -1)
         sel1.setSelector(newx,newy);
       else if (sel1.isEqual(newx,newy))
         ; // do nothing if mouse is at something already selected
       else
       {
         sel2.setSelector(newx,newy);
         theBoard.swap(sel1,sel2);
         sel1.reset();
         sel2.reset();
       }
    }
  }
  
  void drawChains() {
    for (int j=0;j<chainList.size();j++)
    {
      if (DEBUG_MODE_ON)
      {
        rect(j*20,0,20,20);
      }
      Chain ch = (Chain)chainList.get(j);
      ch.removeIdleTiles();
      ch.redeemChain();
      
    }
  }
}

