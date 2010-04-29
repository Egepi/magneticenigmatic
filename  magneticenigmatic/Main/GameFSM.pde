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
  boolean exiting = false;
  
  Button cont1;
  Button quit;
  Button cont2;
  Button settingsButton;
  Button helpCreditsButton;
  Button startPlayer1;
  Button startPlayer2;
  Button backButton;
  Button checkButton;
  Button wrongButton;
  Button fiveButton;
  Button eightButton;
  Button twelveButton;

  int continueCount = 0;
  int whoWon = 0;
  int logoX;
  int logoY;
  /************************************************************
  */
  public GameFSM()
  {
    stateId = 0;
  }
  
  public void logoState()
  {
    background(50,125,150);
    font1 = loadFont("ArialNarrow-48.vlw");
    textFont(font1); //Set font to use for following text() calls
    textAlign(CENTER);
    
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
    
    powerArray[0] = loadImage(POWER1);
    powerArray[1] = loadImage(POWER2);
    powerArray[2] = loadImage(POWER3);
    
    //powerArray[0].resize(TILE_SIZE, TILE_SIZE);
    //powerArray[1].resize(TILE_SIZE, TILE_SIZE);
    //powerArray[2].resize(TILE_SIZE, TILE_SIZE);
    
    logo = loadImage("logo-2.png");
    logoX = width/2 - logo.width/2;
    logoY = height/2 - logo.height/2;
    
    balancedBG = minim.loadFile("POL_Balanced.mp3", 2048);
    imbalancedBG = minim.loadFile("POL_Imbalanced.mp3", 2048);
    dangerBG = minim.loadFile("POL_Danger.mp3", 2048);
    
    p1Win = loadImage("P1Win.png");
    p2Win = loadImage("P2Win.png");
    p1Lose = loadImage("P1Lose.png");
    p2Lose = loadImage("P2Lose.png");  
 
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
    
    settingsButton.move();
    helpCreditsButton.move();
    
    settingsButton.drawit();
    helpCreditsButton.drawit();
    if(startPlayer1.checkBounds() == 1)
    {
      if(responseP1 == false)
      {
        responseP1 = true;
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
    }
    
    if((responseP1 == true)&&(responseP2 == true))
    {
      startPlayer2.myImage.filter(INVERT);
      startPlayer1.myImage.filter(INVERT);
      stateId = 3;
    }
   
    if(settingsButton.checkBounds() == 1) 
    {
      stateId = OPTION_STATE;
    }

    if(helpCreditsButton.checkBounds() == 1)
    {
      stateId = HELP_STATE;
    }    
    return;
  }
  
  /************************************************************
  */
  public void optionsState()
  {
    background(backgroundPicture);
    backButton.drawit();
    settingsButton.move();
    helpCreditsButton.move();
    text("MUSIC", width/2, height*0.15);
    text("NUMBER OF ROWS", width/2, height*0.47);
    checkButton.myXcoord = width/2-250;
    checkButton.myYcoord = height*0.20;
    wrongButton.myXcoord = width/2+50;
    wrongButton.myYcoord = height*0.20;
    checkButton.drawit();
    wrongButton.drawit();
    fiveButton.drawit();
    eightButton.drawit();
    twelveButton.drawit();
    
    if(wrongButton.checkBounds() == 1)
    {
      currentlyPlaying.pause();
      SOUNDS_ON = false;
    }
    if(checkButton.checkBounds() == 1)
    {
      currentlyPlaying.loop();
      SOUNDS_ON = true;
    }
    if(backButton.checkBounds() == 1)
    {
      stateId = START_STATE;
    }
    if(fiveButton.checkBounds() == 1)
    {
      TPR = 5;
    }
    else if(eightButton.checkBounds() == 1)
    {
      TPR = 8;
    }
    else if(twelveButton.checkBounds() == 1)
    {
      TPR = 12;
    }
    PUZZLE_ORIGIN_X = (screen.width/2) - ((MAX_R * TILE_SIZE)/2);
    PUZZLE_ORIGIN_Y = (screen.height/2) - ((TPR * TILE_SIZE)/2);
  }

  /************************************************************
  */  
  public void createNew()
  {
    player1.reset();
    player2.reset();
    responseP1 = false;
    responseP2 = false;
    theBoard = new GameBoard(TPR, MAX_R);
    theBoard.generateBoard();
    theMomentum = new Momentum();
    startClock(); 
    stateId = GAME_STATE;
  }

  /************************************************************
  */
  public void helpState()
  {
    background(backgroundPicture);
    backButton.drawit();
    settingsButton.move();
    helpCreditsButton.move();
    text("Project Lead\nJeremy Meador\n", width/2, height*0.10);
    text("Programmers\nTodd Silvia - UIC\nKaran Chakrapani - UIC\nJeremy Meador - LSU\n", width/2, height*0.30);
    text("Artist\nLee Vanderlick\n", width/2, height*0.70);
    if(backButton.checkBounds() == 1)
    {
      stateId = START_STATE;
    }
  }
  
  /************************************************************
  */
  public void gameState()
  {
    background(backgroundPicture); //Arbitrary background color for the time being.
    
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
    
    if(timer1 >= 0)//&&(imageTime1 != null)) //Check if timer has any time left to display
    {
      if(oldSec != second()) //Check if AT LEAST 1 second has passed
      {
        timer1--;
        oldSec = second();
      }
      text(timer1, height/8+20, playerOneY+65);  //Draw timer on board on top
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
  
    if(timer2 >= 0)//&&(imageTime2 != null))
    {
      if(oldSec !=second())
      {
        timer2--;
        oldSec = second();
      }
      text(timer2, (-height/8)+15,     playerTwoY+65);
      text(timer2, (-height/8)*7, playerTwoY+65);
      image(imageTime2, (-height/8)-60, playerOneY+20);
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
    if ((rowTimeDifference() > timeBetweenRows)&&(ROW_GENERATION_ON))
    {
      lastRowTime +=timeBetweenRows;
      theBoard.generateRow();
      if (timeBetweenRows > MIN_TIME_BETWEEN_ROWS)
      {
        timeBetweenRows -= 500;
      }
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
    theBoard.swapSongs(balancedBG);
    background(backgroundPicture); //Arbitrary background color for the time being.
    if(whoWon == 1)
    {
      //text("Player 1 won", 500, 200);
      image(p1Win, cont1.myXcoord + width*0.1, cont1.myYcoord);
      image(p2Lose, cont2.myXcoord - width*0.1, cont2.myYcoord);
    }
    else if (whoWon == 2)
    {
      //text("Player 2 won", 500, 200); 
      image(p1Lose, cont1.myXcoord + width*0.1, cont1.myYcoord);
      image(p2Win, cont2.myXcoord - width*0.1, cont2.myYcoord); 
    }
    cont1.drawit();
    cont2.drawit();
    quit.drawit();
    

    if(!responseP1)
    {
      if(cont1.checkBounds() == 1)
      {
        responseP1 = true;
        cont1.myImage.filter(INVERT);
        continueCount = continueCount + 1;
      }
    }
    if(!responseP2)
    {
      if(cont2.checkBounds() == 1)
      {
        responseP2 = true;
        cont2.myImage.filter(INVERT);
        continueCount = continueCount + 1;
      }
    }
    if(quit.checkBounds() == 1)
    {
      exiting = true;
      continueCount = 0;
    }
    if((responseP1 && responseP2) || exiting)
    {
      if(continueCount == 2)
      {
        responseP1 = false;
        responseP2 = false;
        exiting = false;    
        stateId = 3;
        continueCount = 0;
      }
      else
      {
        responseP1 = false;
        responseP2 = false;
        exiting = false;    
        stateId = 1;
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
      case 0: logoState(); break;
      case 1: startState(); break;
      case 2: optionsState(); break;
      case 3: createNew(); break;
      case 4: gameState(); break;
      case 5: endRound(); break;
      case 6: helpState(); break;
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
      PImage settings = loadImage("settings.png");
      PImage HelpCredits = loadImage("exitButton.png");
      
      PImage contP1Button = loadImage("contP1.jpg");
      PImage contP2Button = loadImage("contP2.jpg");
      PImage quitButton = loadImage("quit.jpg");
      
      float contP1Xcord = (width)*0.15;
      float contP1Ycord = (height/2) - contP1Button.height/2;
      float contP2Xcord = (width)*0.85 - contP2Button.width;
      float contP2Ycord = (height/2) - contP2Button.height/2;
      float quitXcord = (width/2) - quitButton.width/2;
      float quitYcord = (height/2) - quitButton.height/2;
      
      float start1Xcord = (width*0.15)-(start1.height)/2;
      float start2Xcord = (width*0.85)-(start2.height)/2;
      float startYcord = (height/2)-(start1.width)/2;
      
      cont1 = new Button(contP1Button, contP1Xcord, contP1Ycord);
      cont2 = new Button(contP2Button, contP2Xcord, contP2Ycord);
      quit = new Button(quitButton, quitXcord, quitYcord);
      
      startPlayer1 = new Button(start1, start1Xcord, startYcord);
      startPlayer2 = new Button(start2, start2Xcord, startYcord);
      settingsButton = new Button(settings, logoX -200, logoY-200, 200, 200);
      helpCreditsButton = new Button(HelpCredits, logoX + logo.width , logoY + logo.height ,200, 200);
      settingsButton.setPath(logoX - 200, logoX + logo.width, logoY-200, logoY + logo.height);
      helpCreditsButton.setPath(logoX - 200, logoX + logo.width, logoY-200, logoY + logo.height);
      backButton = new Button(HelpCredits, 0, height-200, 200, 200);
      checkButton = new Button(loadImage("check.png"), 200,200);
      wrongButton = new Button(loadImage("wrong.png"), 200,200);
      fiveButton = new Button(loadImage("five.png"), width*0.20, height/2,200,200);
      eightButton = new Button(loadImage("eight.png"), width*0.40, height/2,200,200);
      twelveButton = new Button(loadImage("twelve.png"), width*0.60, height/2,200,200);
  }
  
}
