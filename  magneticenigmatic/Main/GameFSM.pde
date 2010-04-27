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
    background(50,125,150);
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
    backgroundPicture = loadImage("cut_background2B.png");
    backgroundPicture.resize(width,height);
    swap1 = minim.loadFile("Swap_Left.wav");
    swap2 = minim.loadFile("Swap_Right.wav");
    
    slowSound = minim.loadFile("slow.mp3");
    speedSound = minim.loadFile("speedup.mp3");
    blindSound = minim.loadFile("blind.mp3");
    
    logo = loadImage("logo-2.png");
    

    contP1Button = loadImage("contP1.jpg");
    contP2Button = loadImage("contP2.jpg");
    quitP1Button = loadImage("quitP1.jpg");
    quitP2Button = loadImage("quitP2.jpg");
    
    balancedBG = minim.loadFile("POL_Balanced.mp3");
    imbalancedBG = minim.loadFile("POL_Imbalanced.mp3");
    dangerBG = minim.loadFile("POL_Danger.mp3");
    font1 = loadFont("ArialNarrow-48.vlw");
  
    makeButtons();
    balancedBG.loop();
    currentlyPlaying = balancedBG;
    stateId++;
  }
  /************************************************************
  */
  public void startState()
  {
    background(backgroundPicture); //Arbitrary background color for the time being.

    image(logo, width/2 - logo.width/2, height/2 - logo.height/2);
    
    startPlayer1.drawit();
    startPlayer2.drawit();
    if(startPlayer1.checkBounds() == 1)
    {
      if(responseP1 == false)
      {
        responseP1 = true;
        startPlayer1.myImage.filter(INVERT);
      }
      else if(responseP1 == true)
      {
        responseP1 = false;
        startPlayer1.myImage.filter(INVERT);
      }
    }
    
    if(startPlayer2.checkBounds() == 1)
    {
      if(responseP2 == false)
      {
        responseP2 = true;
        startPlayer2.myImage.filter(INVERT);
      }
      else if(responseP2 == true)
      {
        responseP2 = false;
        startPlayer2.myImage.filter(INVERT);
      }
    }
    
    if((responseP1 == true)&&(responseP2 == true))
    {
      startPlayer2.myImage.filter(INVERT);
      startPlayer1.myImage.filter(INVERT);
      responseP1 = false;
      responseP2 = false;
      stateId++;
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
    background(backgroundPicture); //Arbitrary background color for the time being.
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
    /*
    if(pOneUp.size() > 0)
    {
      for(int i = 0; i < pOneUp.size(); i++)
      {
        PowerUp temp = (PowerUp) pOneUp.get(i);
        if(temp.getOldSec() < 0)
        {
          pOneUp.remove(i);
        }
        else if(temp.oldSec != second())
        {
          temp.setOldSec(second());
          temp.setNewTime(temp.getTime() - 1);
          text(temp.getTime(), height/8+20,     playerOneY+65);
          text(temp.getTime(), ((height/8)*7)+40, playerOneY+65);
          pOneUp.set(i, temp);
        }
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
    drawAnimations();
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
    background(backgroundPicture); //Arbitrary background color for the time being.
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
          player1.reset();
          player2.reset();
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
          responseP1 = false;
          responseP2 = false;    
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
  
  void drawAnimations() {
    for (int j=0;j<animationList.size();j++)
    {
      AnimationClear ac = (AnimationClear)animationList.get(j);
      ac.step();
    }
  }
  
  void makeButtons()
  {
      PImage start1 = loadImage("start_black_1.png");
      PImage start2 = loadImage("start_black_2.png");
      
      float contP1Xcord = (width)*0.2;
      float contP1Ycord = (height/2) - contP1Button.height - 50;
      float quitP1Xcord = (width)*0.2;
      float quitP1Ycord = (height/2) + 50;
      
      float start1Xcord = (width*0.15)-(start1.height)/2;
      float start2Xcord = (width*0.85)-(start2.height)/2;
      float startYcord = (height/2)-(start1.width)/2;
      
      float contP2Xcord = (width)*0.8 - contP2Button.width;
      float contP2Ycord = (height/2) - contP1Button.height - 50;
      float quitP2Xcord = (width)*0.8 - contP2Button.width;
      float quitP2Ycord = (height/2) + 50;
      
      cont1 = new Button(contP1Button, contP1Xcord, contP1Ycord);
      quit1 = new Button(quitP1Button, quitP1Xcord, quitP1Ycord);
      cont2 = new Button(contP2Button, contP2Xcord, contP2Ycord);
      quit2 = new Button(quitP2Button, quitP2Xcord, quitP2Ycord);
      startPlayer1 = new Button(start1, start1Xcord, startYcord);
      startPlayer2 = new Button(start2, start2Xcord, startYcord);
  }
  
}
