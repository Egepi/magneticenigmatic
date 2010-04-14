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
  int plyrOneRdy = 0;
  int plyrTwoRdy = 0;
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
    stateId++;
  }
  
  /************************************************************
  */
  public void scanState()
  {
    background(49,79,79);
    strokeWeight(4);
    line(width/2, 0, width/2, height);
    rect((width/2 + 50), height/2 - 50, 400, 250);
    checkScan();
    if((plyrOneRdy == 1)&&(plyrTwoRdy == 1))
    {
      print("HELLO THERE WORLD THINGY\n");
      stateId++;
    }
    //stroke(1);
//    stateId++;
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
      stateId ++;
      return;
    }
    
         
  }
  
  /************************************************************
  */
  public void endRound()
  {
    //Display winner
    
    //Show begin round 2 button
    
    //when begin button clicked go to stage 3
    theBoard = new GameBoard(TPR, MAX_R);
    theBoard.generateBoard();
    theMomentum = new Momentum();
    stateId = 4;
    
  }
  
  /************************************************************
  */
  public void endGame()
  {
    if(player1.getRoundsWon() > player2.getRoundsWon())
    {
      
    }
    else
    {
    }

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
      case 3: scanState(); break;
      case 4: gameState(); break;
      case 5: endRound(); break;
      case 6: endGame(); break;
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
         if(theBoard.swap(sel1,sel2))
         {
           if(sel1.getY() < lineOfGravity)
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
  
  void checkScan()
  {
    int rightScan = 0;
    int leftScan = 0;
    if ( ! tacTile.managedListIsEmpty() ){

    touchList = tacTile.getManagedList();
    // Cycle though the touches 

    for ( int index = 0; index < touchList.size(); index ++ )
    {

      Touches curTouch = (Touches) touchList.get(index);   

      if ( curTouch != null)
      {
        //Grab Data
        float xCoord = curTouch.getXPos() * width;    
        float yCoord = height - curTouch.getYPos() * height;

        if(xCoord > width/2)
          rightScan++;
        else if(xCoord < width/2)
          leftScan++;

        //Grab the Intensity!!!
        //float intensity = curTouch.getIntensity();

        //get finger ID
        //int finger = curTouch.getFinger();
      }
    }
    if(rightScan >= 6)
      plyrOneRdy = 1;
    if(leftScan >= 6)
      plyrTwoRdy = 1;
    }
  }//End checkScan
}
