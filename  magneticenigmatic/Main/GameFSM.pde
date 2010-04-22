/* Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: March 3, 2010
 * Class - GameFSM: <Description goes here>
*/
class GameFSM {
  private int stateId;
  float theta = 0;
  int MIDDLE_L = (width/2)/2;
  int MIDDLE_R = (width/2) + MIDDLE_L;
  int plyrOneRdy = 0;
  int plyrTwoRdy = 0;
  int rightScanX = width/2;
  int leftScanX = width/2;
  /************************************************************
  */
  public GameFSM()
  {
    stateId = 1;
    if (SOUNDS_ON);
      //backGround.loop();
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
    strokeWeight(1);
    rect((width/2 + 50), height/2 - 50, 400, 250);
    if(connectToTacTile == false)
    {
      stateId++;
      return;
    }
    checkScan();
    if((plyrOneRdy == 1)&&(plyrTwoRdy == 1))
    {
      stateId++;
    }
    print("player 1: " + plyrOneRdy + "  player 2: " + plyrTwoRdy + "\n");
  }
  
  /************************************************************
  */
  public void gameState()
  {
    textFont(font1); //Set font to use for following text() calls
    textAlign(CENTER);
    
    /*Rotate and draw player 1 name and a timer if neeed be*/
    pushMatrix();
    rotate(PI/2); //Rotate by 90 degrees
    if(timer1 >= 0) //Check if timer has any time left to display
    {
      if(oldSec != second()) //Check if AT LEAST 1 second has passed
      {
        timer1--;
        oldSec = second();
      }
      text(timer1, 100,(-width/2)+TILE_SIZE+65-(int)(theMomentum.getY()));  //Draw timer on board on top
      text(timer1, 780,(-width/2)+TILE_SIZE+65-(int)(theMomentum.getY()));  //Draw timer on board on bottom
    }
    text(player1.getName(), 100, (-width/2)+TILE_SIZE+8-(int)(theMomentum.getY())); //Don't ask how I got this number...
    text(player1.getName(), 780,  (-width/2)+TILE_SIZE+8-(int)(theMomentum.getY()));
    popMatrix();
    
    /*Rotate and draw player 1 name and a timer if neeed be*/
    pushMatrix();
    rotate(-PI/2);
    if(timer2 >= 0)
    {
      if(oldSec !=second())
      {
        timer2--;
        oldSec = second();
      }
      text(timer2, -100,width/2+TILE_SIZE+65+(int)(theMomentum.getY()));
      text(timer2, -780,width/2+TILE_SIZE+65+(int)(theMomentum.getY()));
    }
    text(player2.getName(), -100, width/2+TILE_SIZE+8+(int)(theMomentum.getY()));
    text(player2.getName(), -780, width/2+TILE_SIZE+8+(int)(theMomentum.getY()));
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
    if(player1.getRoundsWon() == 2 || player1.getRoundsWon() == 2)
    {
      stateId++;
    }
    else
    { 
      float contP1Xcord = (width)*0.2;
      float contP1Ycord = (height/2) - contP1Button.height - 50;
      float quitP1Xcord = (width)*0.2;
      float quitP1Ycord = (height/2) + 50;
      
      float contP2Xcord = (width)*0.8 - contP2Button.width;
      float contP2Ycord = (height/2) - contP1Button.height - 50;
      float quitP2Xcord = (width)*0.8 - contP2Button.width;
      float quitP2Ycord = (height/2) + 50;
      
      Button cont1 = new Button(contP1Button, contP1Xcord, contP1Ycord);
      Button quit1 = new Button(quitP1Button, quitP1Xcord, quitP1Ycord);
      Button cont2 = new Button(contP2Button, contP2Xcord, contP2Ycord);
      Button quit2 = new Button(quitP2Button, quitP2Xcord, quitP2Ycord);

      cont1.drawit();
      cont2.drawit();
      quit1.drawit();
      quit2.drawit();
      
      //when begin button clicked go to stage 3
      theBoard = new GameBoard(TPR, MAX_R);
      theBoard.generateBoard();
      theMomentum = new Momentum();
      //stateId = 4;
    }
    
  }
  
  /************************************************************
  */
  public void endGame()
  {
    if(player1.getRoundsWon() > player2.getRoundsWon())
    {
      //player 1 won
      print(player1.getName() + " wins the game!!!");
      
    }
    else if(player2.getRoundsWon() > player1.getRoundsWon())
    {
      //player 2 won
      print(player2.getName() + " wins the game!!!");
    }
    else
    {
      //tie
      print("It was a tie!");
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
    if (connectToTacTile)
      getTouches();
    else if (mousePressed)
      mouseInput();
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
        {
          rightScan++;
        }
        if(xCoord < width/2)
        {
          leftScan++;
        }
        //Grab the Intensity!!!
        //float intensity = curTouch.getIntensity();

        //get finger ID
        //int finger = curTouch.getFinger();
      }
    }
    fill(255,0,0);
    strokeWeight(5);
    if(rightScan >= 6)
    {
      if(plyrTwoRdy != 1)
      {
        rightScanX = rightScanX + 5;
        line(rightScanX, 0, rightScanX, height);
        if(rightScanX >= width)
        {
          plyrTwoRdy = 1;
        }
      }
    }
    if(leftScan >= 6)
    {
      if(plyrOneRdy != 1)
      {
        leftScanX = leftScanX - 5;
        line(leftScanX, 0, leftScanX, height);
        if(leftScanX <= 0)
        {
          plyrOneRdy = 1;
        }
      }
    }
    noFill();
    strokeWeight(1);
   }
  }//End checkScan
  
  void startScan(int player)
  {
    print(player + "the player is\n");
    strokeWeight(5);
    fill(255,0,0);
    if(player == 1)
    {
      leftScanX = leftScanX - 5;
      line(leftScanX, 0, leftScanX, height);
      if(leftScanX <= 0)
      {
        plyrOneRdy = 1;
      }
    }
    if(player == 0)
    {
      rightScanX = rightScanX + 5;
      line(rightScanX, 0, rightScanX, height);
      if(rightScanX >= width)
      {
        plyrTwoRdy = 1;
      }
    }
    strokeWeight(1);
      
      
    
  }
}
