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
  float theta = 0;
  int MIDDLE_L = (width/2)/2;
  int MIDDLE_R = (width/2) + MIDDLE_L;
  AudioPlayer backGround;
  /************************************************************
  */
  public GameFSM()
  {
    stateId = 1;
    startButton = loadImage("start.png");
    clearSound = new GameSounds("splat.wav");
    backGround = minim.loadFile("zone_nebula_nomad.wav");
    if (SOUNDS_ON)
      backGround.loop();
  }
  
  /************************************************************
  */
  public void startState()
  {
    int startX = screen.width/2 - startButton.width/2;
    int startY = screen.height/2 - startButton.height/2;
    pushMatrix();
    translate(width/2, height/2);
    rotate(theta);
    image(startButton, -startButton.width/2, -startButton.height/2);
    theta = theta + 0.05;
    popMatrix();
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
              stateId++;
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
    text("Player 1", MIDDLE_L-50, 45);
    text("Player 2", MIDDLE_R - 50, 45);
    
    pushMatrix();
    translate(MIDDLE_L - 50, height - 70);
    rotate(PI);
    textAlign(CENTER);
    text("Player 1", 0, 0);
    popMatrix();
    
    pushMatrix();
    translate(MIDDLE_R-50, height - 70);
    rotate(PI);
    textAlign(CENTER);
    text("Player 2", 0, 0);
    popMatrix();
    
    clearSound.stopIfOver();
    
    theBoard.gravity();       //Apply gravity where needed
    //boolean playSound = theBoard.checkClears();   //Check for clears to be made
    theBoard.clearer();
    gameGetInput();           //Get player(s) touch input
    /*if(playSound == true)
    {
      clearSound.play();
    }*/
    theBoard.drawBoard();  //Draw the board
    drawChains();    
    player1.drawPlayer();
    player2.drawPlayer();
    if ((rowTimeDifference() > TIME_BETWEEN_ROWS)&&(ROW_GENERATION_ON))
    {
      lastRowTime += TIME_BETWEEN_ROWS;
      theBoard.generateRow();
    }
    if ((decayTimeDifference() > TIME_BETWEEN_DECAY)&&(MOMENTUM_DECAY_ON))
    {
      lastDecayTime += TIME_BETWEEN_DECAY;
      theMomentum.decreaseMomentum();
    }
    //Check if either player lost
    if (theBoard.checkLoss() > 0)
    {
      //stateId ++;
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
    int theRand;
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
            theRand = (int)(random(2));
            if(theRand == 0)
            {
              swap1.play();
              swap1.rewind();
            }
            else
            {
              swap2.play();
              swap2.rewind();
            }
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
