/* Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: March 3, 2010
 * Class - GameFSM: <Description goes here>
*/
class GameFSM {
  private int stateId;
  float theta = 0;
  boolean responseP1 = false;
  boolean responseP2 = false;
  Button cont1;
  Button quit1;
  Button cont2;
  Button quit2;
  int continueCount = 0;
  int whoWon = 0;
  /************************************************************
  */
  public GameFSM()
  {
    
    stateId = 1;
  }
  
  public void logoState()
  {
    
    /*Load images code*/
    if (TILE0 != null) //for debugging purposes, this may be an actual image for making empty tiles visible.
      tileImageType[0] = loadImage(TILE0);
    else
      tileImageType[0] = null; 
      
    tileImageType[1] = loadImage(TILE1);
    tileImageType[2] = loadImage(TILE2);
    tileImageType[3] = loadImage(TILE3);
    tileImageType[4] = loadImage(TILE4);
    tileImageType[5] = loadImage(TILE5);
    tileImageType[6] = loadImage(TILE6);
    tileImageType[7] = loadImage(TILE7);
    tileImageType[8] = loadImage(TILE8);
    tileImageType[9] = loadImage(TILE9);
    tileImageType[10] = loadImage(TILE10);
    colorlessTile = loadImage(CLTILE);
    backgroundPicture = loadImage("backgroundTac.png");
    backgroundPicture.resize(width,height);
    swap1 = minim.loadFile("Swap_Left.wav");
    swap2 = minim.loadFile("Swap_Right.wav");
    slowSound = minim.loadFile("slow.mp3");
    speedSound = minim.loadFile("speedup.mp3");
    blindSound = minim.loadFile("blind.mp3");
    startButton = loadImage("start.png");
  
    contP1Button = loadImage("contP1.jpg");
    contP2Button = loadImage("contP2.jpg");
    quitP1Button = loadImage("quitP1.jpg");
    quitP2Button = loadImage("quitP2.jpg");
    
    clearSound = new GameSounds("splat.wav");
    backGround = minim.loadFile("POL_Balanced.mp3");

    font1 = loadFont("ArialNarrow-48.vlw");
  
    makeButtons();
    backGround.loop();
    stateId++;
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
    theBoard = new GameBoard(TPR, MAX_R);
    theBoard.generateBoard();
    theMomentum = new Momentum();
    startClock(); 
    stateId++;
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
    int playerOneY = (-width/2)+TILE_SIZE-(int)(theMomentum.getY())-plyOneMove;
    /*if((pOneUp.length > 0)&&(pOneUp[0] != null))
    {
      PowerUp temp;
      for(int i=0; i < pOneUp.length; i++)
      {
        temp = pOneUp[i];
        if(temp.oldSec != second())
        {
          pOneUp[i].oldSec = second();
          pOneUp[i].pTimer--;
        }
        int timer = pOneUp[i].pTimer;
        text(timer, height/8, playerOneY+65);
        text(timer, (height/8)*7, playerOneY+65);        
      }
    }*/
    if(timer1 >= 0) //Check if timer has any time left to display
    {
      if(oldSec != second()) //Check if AT LEAST 1 second has passed
      {
        timer1--;
        oldSec = second();
      }
      text(timer1, height/8+20,     playerOneY+65);  //Draw timer on board on top
      text(timer1, ((height/8)*7)+40, playerOneY+65);  //Draw timer on board on bottom
      image(imageTime1, height/8 - TILE_SIZE, playerOneY + 20);
      image(imageTime1, ((height/8)*7)-40, playerOneY + 20);
    }
    text(player1.getName(), height/8,      playerOneY+8); //Don't ask how I got this number...
    text(player1.getName(), (height/8)*7,  playerOneY+8);
    popMatrix();
    
    /*Rotate and draw player 1 name and a timer if neeed be*/
    pushMatrix();
    rotate(-PI/2);
    int playerTwoY = width/2+TILE_SIZE+(int)(theMomentum.getY())+plyTwoMove;
  
    if(timer2 >= 0)
    {
      if(oldSec !=second())
      {
        timer2--;
        oldSec = second();
      }
      text(timer2, (-height/8)+15,     playerTwoY+65);
      text(timer2, (-height/8)*7, playerTwoY+65);
      image(imageTime2, (-height/8)-60, playerTwoY+20);
      image(imageTime2, ((-height/8)*7)-75, playerTwoY+25);
    }
    text(player2.getName(), -height/8,     playerTwoY+8);
    text(player2.getName(), (-height/8)*7, playerTwoY+8);
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
    whoWon = theBoard.checkLoss();
    //Check if either player lost
    if (whoWon > 0)
    {
      stateId ++;
      return;
    }
    
         
  }
  
  /************************************************************
  */
  public void endRound()
  {
    if(whoWon == 1)
    {
      text("Player 1 won", 500, 200);
    }
    else if (whoWon == 2)
    {
      text("Player 2 won", 500, 200);  
    }
    else
    {
    }
    //Display winner
    if(true)
    { 
      if(!responseP1)
      {
        cont1.drawit();
        quit1.drawit();
      }
      if(!responseP2)
      {
        cont2.drawit();
        quit2.drawit();
      }
      
      if(!responseP1)
      {
        if(cont1.checkBounds() == 1)
        {
          responseP1 = true;
          continueCount = continueCount + 1;
        }
        if(quit1.checkBounds() == 1)
        {
          responseP1 = true;
        }
      }
      if(!responseP2)
      {
        if(cont2.checkBounds() == 1)
        {
          responseP2 = true;
          continueCount = continueCount + 1;
        }
        if(quit2.checkBounds() == 1)
        {
          responseP2 = true;
        }
      }
      if(responseP1 && responseP2)
      {
        if(continueCount == 2)
        {
          theBoard = new GameBoard(TPR, MAX_R);
          theBoard.generateBoard();
          theMomentum = new Momentum();
          startClock();
          stateId --;
          continueCount = 0;
          responseP1 = false;
          responseP2 = false;
        }
        else
        {
          stateId = 2;
        }
      }
      
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
      case 1: logoState(); break;
      case 2: startState(); break;
      case 3: optionsState(); break;
      case 4: gameState(); break;
      case 5: endRound(); break;
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
  
  void makeButtons()
  {
      float contP1Xcord = (width)*0.2;
      float contP1Ycord = (height/2) - contP1Button.height - 50;
      float quitP1Xcord = (width)*0.2;
      float quitP1Ycord = (height/2) + 50;
      
      float contP2Xcord = (width)*0.8 - contP2Button.width;
      float contP2Ycord = (height/2) - contP1Button.height - 50;
      float quitP2Xcord = (width)*0.8 - contP2Button.width;
      float quitP2Ycord = (height/2) + 50;
      
      cont1 = new Button(contP1Button, contP1Xcord, contP1Ycord);
      quit1 = new Button(quitP1Button, quitP1Xcord, quitP1Ycord);
      cont2 = new Button(contP2Button, contP2Xcord, contP2Ycord);
      quit2 = new Button(quitP2Button, quitP2Xcord, quitP2Ycord);
  }
  
}
