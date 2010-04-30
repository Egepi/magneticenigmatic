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
  boolean victoryStarted = false;
  boolean notNormal = false;
  
  Button cont1;
  Button cont2;
  Button settingsButton;
  Button helpCreditsButton;
  Button startPlayer1;
  Button startPlayer2;
  Button backButton;
  Button backButton2;
  Button exitGameButtonP1;
  Button exitGameButtonP2;
  Button checkButton;
  Button wrongButton;
  Button fiveButton;
  Button eightButton;
  Button twelveButton;
  Button lowButton;
  Button medButton;
  Button highButton;

  int continueCount = 0;
  int whoWon = 0;
  int logoX;
  int logoY;
  
  boolean holdingP1 = false;
  int holdCountP1 = 0;
  int p1QuitTint = 255;
  
  boolean holdingP2 = false;
  int holdCountP2 = 0;
  int p2QuitTint = 255;
  
  String powerupStringP1;
  String swapStringP1;
  String clearStringP1;
  String chainStringP1;
  String bestChainStringP1;

  String powerupStringP2;
  String swapStringP2;
  String clearStringP2;
  String chainStringP2;
  String bestChainStringP2;
  
  String player1Status;
  String player2Status;
  
  PImage toddImage;
  PImage karanImage;
  PImage leeImage;
  PImage jeremyImage;
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
    font2 = loadFont("Monospaced.plain-36.vlw");
    font3 = loadFont("Monospaced.bold-48.vlw");
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
    
    iceArray[0] = loadImage(PICE1);
    iceArray[1] = loadImage(PICE2);
    iceArray[2] = loadImage(PICE3);
    iceArray[3] = loadImage(PICE4);
    iceArray[4] = loadImage(PICE5);
    
    powerArray[0] = loadImage(POWER1);
    powerArray[1] = loadImage(POWER2);
    powerArray[2] = loadImage(POWER3);
    
    powerArray[0].resize(60 , 60);
    powerArray[1].resize(60, 60);
    powerArray[2].resize(60, 60);
    
    toddImage = loadImage("ToddS.png");
    toddImage.resize(200,225);
    karanImage = loadImage("KaranC.png");
    leeImage = loadImage("star.png");
    leeImage.resize(200,200);
    jeremyImage = loadImage("jeremy.png");
    jeremyImage.resize(200,200);
    
    logo = loadImage("logo-2.png");
    logoX = width/2 - logo.width/2;
    logoY = height/2 - logo.height/2;
    
    balancedBG = minim.loadFile("POL_Balanced.mp3", 2048);
    victorySound = minim.loadFile("POL_Victory.mp3");
    
    if(STEREO_ON)
    {
      imbalancedBGP1 = minim.loadFile("POL_ImbalancedP1.mp3", 2048);
      imbalancedBGP2 = minim.loadFile("POL_ImbalancedP2.mp3", 2048);
      
      dangerBGP1 = minim.loadFile("POL_DangerP1.mp3", 2048);
      dangerBGP2 = minim.loadFile("POL_DangerP2.mp3", 2048);
      
      swap1 = minim.loadFile("swapP1.mp3");
      swap2 = minim.loadFile("swapP2.mp3");
      
      freezeSoundP1 = minim.loadFile("bellsP1.mp3");
      freezeSoundP2 = minim.loadFile("bellsP2.mp3");

      blindSoundP1 = minim.loadFile("blindP1.mp3");
      blindSoundP2 = minim.loadFile("blindP2.mp3");
      
      slowSoundP1 = minim.loadFile("slowP1.mp3");
      slowSoundP2 = minim.loadFile("slowP2.mp3");
      
      speedSoundP1 = minim.loadFile("speedupP1.mp3");
      speedSoundP2 = minim.loadFile("speedupP2.mp3");
      
      clearP1[0] = minim.loadFile("Effect-1P1.mp3");
      clearP1[1] = minim.loadFile("Effect-2P1.mp3");
      clearP1[2] = minim.loadFile("Effect-3P1.mp3");
      clearP1[3] = minim.loadFile("Effect-4P1.mp3");
      clearP1[4] = minim.loadFile("Effect-5P1.mp3");
      clearP1[5] = minim.loadFile("Effect-6P1.mp3");

      clearP2[0] = minim.loadFile("Effect-1P2.mp3");
      clearP2[1] = minim.loadFile("Effect-2P2.mp3");
      clearP2[2] = minim.loadFile("Effect-3P2.mp3");
      clearP2[3] = minim.loadFile("Effect-4P2.mp3");
      clearP2[4] = minim.loadFile("Effect-5P2.mp3");
      clearP2[5] = minim.loadFile("Effect-6P2.mp3");
    }
    else
    {
      imbalancedBG = minim.loadFile("POL_Imbalanced.mp3", 2048);
      dangerBG = minim.loadFile("POL_Danger.mp3", 2048);
      
      swap = minim.loadFile("swap.mp3");
      freezeSound = minim.loadFile("bells.mp3");
      slowSound = minim.loadFile("slow.mp3");
      speedSound = minim.loadFile("speedup.mp3");
      blindSound = minim.loadFile("blind.mp3");
      
      clear[0] = minim.loadFile("Effect-1.mp3");
      clear[1] = minim.loadFile("Effect-2.mp3");
      clear[2] = minim.loadFile("Effect-3.mp3");
      clear[3] = minim.loadFile("Effect-4.mp3");
      clear[4] = minim.loadFile("Effect-5.mp3");
      clear[5] = minim.loadFile("Effect-6.mp3");
    }
    
    
    scoreBG = loadImage("scoreBackground.png");
 
    makeButtons();
    
    stateId++;
  }
  /************************************************************
  */
  public void startState()
  {
    background(backgroundPicture); //Arbitrary background color for the time being.
    if (currentlyPlaying != balancedBG)
    {
      balancedBG.loop();
      currentlyPlaying = balancedBG;
      victorySound.pause();
      victorySound.rewind();
    }
    image(logo, width/2 - logo.width/2, height/2 - logo.height/2);
    
    tint(255,p2QuitTint);
    exitGameButtonP2.drawit();
    noTint();
    
    tint(255,p1QuitTint);
    exitGameButtonP1.drawit();
    noTint();
    
    startPlayer1.drawit();
    startPlayer2.drawit();
    
    settingsButton.move();
    helpCreditsButton.move();
    
    settingsButton.drawit();
    helpCreditsButton.drawit();
    
    if((exitGameButtonP1.checkBounds() == 1) || holdingP1)
    {
      if(exitGameButtonP1.checkBounds() == 1)
      {
        holdCountP1++;
        p1QuitTint = p1QuitTint - 3;
      }
      else
      {
        holdingP1 = false;
      }
      if(holdCountP1 == EXIT_TIME) exit();
    }
    else
    {
      if(p1QuitTint < 254)
      {
        p1QuitTint = p1QuitTint + 3;
        holdCountP1--;;
      }
    }
    
    if((exitGameButtonP2.checkBounds() == 1) || holdingP2)
    {
      if(exitGameButtonP2.checkBounds() == 1)
      {
        holdCountP2++;
        p2QuitTint = p2QuitTint - 3;
      }
      else
      {
        holdingP2 = false;
      }
      if(holdCountP2 == EXIT_TIME) exit();
    }
    else
    {
      if(p2QuitTint < 254)
      {
        p2QuitTint = p2QuitTint + 3;
        holdCountP2++;
      }
    }
  
    
    startPlayer1.decrementSwitch();
    if(startPlayer1.checkBounds() == 1 && startPlayer1.switchCount == 0) 
    {
      //Switch the image
      PImage temp1 = startPlayer1.myImage;
      startPlayer1.myImage = startPlayer1.myImage2;
      startPlayer1.myImage2 = temp1;
      startPlayer1.switchCount = 12;
      responseP1 = !responseP1;
    }
    
    startPlayer2.decrementSwitch();
    if(startPlayer2.checkBounds() == 1 && startPlayer2.switchCount == 0) 
    {
      //Switch the image
      PImage temp2 = startPlayer2.myImage;
      startPlayer2.myImage = startPlayer2.myImage2;
      startPlayer2.myImage2 = temp2;
      startPlayer2.switchCount = 12;
      responseP2 = !responseP2;
    }
    
    if((responseP1 == true)&&(responseP2 == true))
    {
      PImage temp3 = startPlayer1.myImage;
      startPlayer1.myImage = startPlayer1.myImage2;
      startPlayer1.myImage2 = temp3;
      
      PImage temp4 = startPlayer2.myImage;
      startPlayer2.myImage = startPlayer2.myImage2;
      startPlayer2.myImage2 = temp4;
      stateId = 3;
    }
   
    if(settingsButton.checkBounds() == 1) 
    
    if(settingsButton.checkBounds() == 1)
    {
      stateId = OPTION_STATE;
      return;
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
    startPlayer1.switchCount = 0;
    startPlayer2.switchCount = 0;
    if(responseP1 == true)
    {
      responseP1 = false;
      PImage temp = startPlayer1.myImage;
      startPlayer1.myImage = startPlayer1.myImage2;
      startPlayer1.myImage2 = temp;
    }
    if(responseP2 == true)
    {
      responseP2 = false;
      PImage temp2 = startPlayer2.myImage;
      startPlayer2.myImage = startPlayer2.myImage2;
      startPlayer2.myImage2 = temp2;
    }
    background(backgroundPicture);
    backButton.drawit();
    backButton2.drawit();
    settingsButton.move();
    helpCreditsButton.move();
    text("MUSIC", width/2, height*0.10);
    text("NUMBER OF ROWS", width/2, height*0.43);
    text("MOMENTUM", width/2, height*0.70);
    checkButton.myXcoord = width/2-250;
    checkButton.myYcoord = height*0.15;
    wrongButton.myXcoord = width/2+50;
    wrongButton.myYcoord = height*0.15;
    checkButton.drawit();
    wrongButton.drawit();
    fiveButton.drawit();
    eightButton.drawit();
    twelveButton.drawit();
    lowButton.drawit();
    medButton.drawit();
    highButton.drawit();
    
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
    if((backButton.checkBounds() == 1)||(backButton2.checkBounds() == 1))
    {
      stateId = START_STATE;
      return;
    }
    if(fiveButton.checkBounds() == 1)
    {
      if(TPR !=5)
      {
        fiveButton.myImage.filter(INVERT);
        if(TPR == 8)
        {
          eightButton.myImage.filter(INVERT);
        }
        else
        {
          twelveButton.myImage.filter(INVERT);
        }
        TPR = 5;
      }
    }
    else if(eightButton.checkBounds() == 1)
    {
      if(TPR != 8)
      {
        eightButton.myImage.filter(INVERT);
        if(TPR == 5)
        {
          fiveButton.myImage.filter(INVERT);
        }
        else
        {
          twelveButton.myImage.filter(INVERT);
        }
        TPR = 8;
      }
    }
    else if(twelveButton.checkBounds() == 1)
    {
      if(TPR != 12)
      {
        twelveButton.myImage.filter(INVERT);
        if(TPR == 5)
        {
          fiveButton.myImage.filter(INVERT);
        }
        else
        {
          eightButton.myImage.filter(INVERT);
        }
        TPR = 12;
      }
    }
    
    if(lowButton.checkBounds() == 1)
    {
      if(momentumAdd != LOW_MOMENTUM)
      {
        lowButton.myImage.filter(INVERT);
        if(momentumAdd == MED_MOMENTUM)
        {
          medButton.myImage.filter(INVERT);
        }
        else
        {
          highButton.myImage.filter(INVERT);
        }
        momentumAdd = LOW_MOMENTUM;
      }
    }
    else if(medButton.checkBounds() == 1)
    {
      if(momentumAdd != MED_MOMENTUM)
      {
        medButton.myImage.filter(INVERT);
        if(momentumAdd == LOW_MOMENTUM)
        {
          lowButton.myImage.filter(INVERT);
        }
        else
        {
          highButton.myImage.filter(INVERT);
        }
        momentumAdd = MED_MOMENTUM;
      }
    }
    else if(highButton.checkBounds() == 1)
    {
      if(momentumAdd != HIGH_MOMENTUM)
      {
        highButton.myImage.filter(INVERT);
        if(momentumAdd == MED_MOMENTUM)
        {
          medButton.myImage.filter(INVERT);
        }
        else
        {
          lowButton.myImage.filter(INVERT);
        }
        momentumAdd = HIGH_MOMENTUM;
      }
    }
  }

  /************************************************************
  */  
  public void createNew()
  {
    holdingP1 = false;
    holdCountP1 = 0;
    holdingP2 = false;
    holdCountP2 = 0;   
    TILE_SIZE = PUZZLE_WIDTH/TPR;
    PUZZLE_ORIGIN_X = (screen.width/2) - ((MAX_R * TILE_SIZE)/2);
    PUZZLE_ORIGIN_Y = (screen.height/2) - ((TPR * TILE_SIZE)/2);
    player1.reset();
    player2.reset();
    responseP1 = false;
    responseP2 = false;
    theBoard = new GameBoard(TPR, MAX_R);
    theBoard.generateBoard();
    theMomentum = new Momentum();
    timer1 = -1;
    timer2 = -1;
    imageTime1 = null;
    imageTime2 = null;
    startClock(); 
    stateId = GAME_STATE;
  }

  /************************************************************
  */
  public void helpState()
  {
    if(responseP1 == true)
    {
      responseP1 = false;
      PImage temp = startPlayer1.myImage;
      startPlayer1.myImage = startPlayer1.myImage2;
      startPlayer1.myImage2 = temp;
    }
    if(responseP2 == true)
    {
      responseP2 = false;
      PImage temp2 = startPlayer2.myImage;
      startPlayer2.myImage = startPlayer2.myImage2;
      startPlayer2.myImage2 = temp2;
    }
    textAlign(CENTER);
    background(backgroundPicture);
    backButton.drawit();
    backButton2.drawit();
    settingsButton.move();
    helpCreditsButton.move();
    image(toddImage, width*0.25, height/4 - 100);
    text("Programmer - UIC\n", width*0.30, height/4 + 200);
    text("Programmer - UIC\n", width*0.70, height/4 + 200);
    text("Artist - LSU\n", width*0.70, height*0.60 + 275);
    text("Project Lead\nProgrammer - LSU", width*0.32, height*0.60 + 275);
    image(karanImage, width*0.70-(karanImage.width/2), height/4 - 100);
    image(jeremyImage, width*0.25, height*0.60);
    image(leeImage, width*0.7-(leeImage.width/2), height*0.60);
    if((backButton.checkBounds() == 1)||(backButton2.checkBounds() == 1))
    {
      stateId = START_STATE;
    }
  }
  
  /************************************************************
  */
  public void gameState()
  {
    background(backgroundPicture); //Arbitrary background color for the time being.
    
    tint(255,p2QuitTint);
    exitGameButtonP2.drawit();
    noTint();
    
    tint(255,p1QuitTint);
    exitGameButtonP1.drawit();
    noTint();
    
    if((exitGameButtonP1.checkBounds() == 1) || holdingP1)
    {
      if(exitGameButtonP1.checkBounds() == 1)
      {
        holdCountP1++;
        p1QuitTint = p1QuitTint - 3;
      }
      else
      {
        holdingP1 = false;
      }
      if(holdCountP1 == EXIT_TIME) exit();
    }
    else
    {
      if(p1QuitTint < 254)
      {
        p1QuitTint = p1QuitTint + 3;
        holdCountP1--;;
      }
    }
    
    if((exitGameButtonP2.checkBounds() == 1) || holdingP2)
    {
      if(exitGameButtonP2.checkBounds() == 1)
      {
        holdCountP2++;
        p2QuitTint = p2QuitTint - 3;
      }
      else
      {
        holdingP2 = false;
      }
      if(holdCountP2 == EXIT_TIME) exit();
    }
    else
    {
      if(p2QuitTint < 254)
      {
        p2QuitTint = p2QuitTint + 3;
        holdCountP2++;
      }
    }  
    /*Rotate and draw player 1 name and a timer if neeed be*/
    pushMatrix();
    rotate(PI/2); //Rotate by 90 degrees
    int playerOneY = (-width/2)+TILE_SIZE-(int)(theMomentum.getY())-plyOneMove;
    
    if(timer1 >= 0)//&&(imageTime1 != null)) //Check if timer has any time left to display
    {
      if(oldSec != second()) //Check if AT LEAST 1 second has passed
      {
        timer1--;
        oldSec = second();
      }
      if(timer1 >= 0)
      {
        text(timer1, height/8+20, playerOneY+65);  //Draw timer on board on top
        text(timer1, ((height/8)*7)+40, playerOneY+65);  //Draw timer on board on bottom
        image(imageTime1, height/8 - TILE_SIZE-8, playerOneY+25);
        image(imageTime1, ((height/8)*7)-60, playerOneY + 25);
      }
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
      if(timer2 >= 0)
      {
        text(timer2, (-height/8)+25, playerTwoY+70);
        text(timer2, (-height/8)*7 + 15, playerTwoY+65);
        image(imageTime2, (-height/8)-65, playerTwoY + 25);
        image(imageTime2, ((-height/8)*7)-75, playerTwoY+25);
      }
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
      calculateScores();
      return;
    }
    
         
  }
  
  /************************************************************
  */
  public void endRound()
  {

    holdingP1 = false;
    holdCountP1 = 0;
    holdingP2 = false;
    holdCountP2 = 0;
    
    if(!victoryStarted)
    {
      currentlyPlaying.pause();
      victorySound.play();
      victoryStarted = true;
      notNormal = true;
    }
    else
    {
      if(!victorySound.isPlaying() && notNormal)
     {
       victorySound.pause();
       currentlyPlaying = balancedBG;
       balancedBG.loop();
       notNormal = false;
     }
    }

    background(backgroundPicture); //Arbitrary background color for the time being.

    if(whoWon == 1)
    {
      player1Status = "You Win";
      player2Status = "You Lose";
    }
    else if (whoWon == 2)
    {
      player1Status = "You Lose";
      player2Status = "You Win";
    }
    displayScores();
    cont1.drawit();
    cont2.drawit();
    backButton.drawit();
    backButton2.drawit();

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
    if((backButton.checkBounds() == 1)||(backButton2.checkBounds() == 1))
    {
      if(TPR != 8)
      {
        eightButton.myImage.filter(INVERT);
        if(TPR == 5)
        {
          fiveButton.myImage.filter(INVERT);
        }
        else
        {
          twelveButton.myImage.filter(INVERT);
        }
        TPR = 8;
      }
      

        if(momentumAdd != LOW_MOMENTUM)
        {
          lowButton.myImage.filter(INVERT);
          if(momentumAdd == MED_MOMENTUM)
          {
            medButton.myImage.filter(INVERT);
          }
          else
          {
            highButton.myImage.filter(INVERT);
          }
          momentumAdd = LOW_MOMENTUM;
        }
      exiting = true;
      continueCount = 0;
      settingsButton.myXcoord = settingsButton.myPathMinX;
      settingsButton.myYcoord = settingsButton.myPathMaxY;
      helpCreditsButton.myXcoord = helpCreditsButton.myPathMaxX;
      helpCreditsButton.myYcoord = helpCreditsButton.myPathMinY;
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
      PImage start1 = loadImage("startLeft.png");
      PImage start2 = loadImage("startRight.png");
      PImage HelpCredits = loadImage("exitButton.png");
      
      PImage contP1Button = loadImage("contP1.jpg");
      PImage contP2Button = loadImage("contP2.jpg");

      float contP1Xcord = (width)*0.10;
      float contP1Ycord = (height/2) - contP1Button.height/2;
      float contP2Xcord = (width)*0.90 - contP2Button.width;
      float contP2Ycord = (height/2) - contP2Button.height/2;
      
      float start1Xcord = (width*0.15)-(start1.height)/2;
      float start2Xcord = (width*0.85)-(start2.height)/2;
      float startYcord = (height/2)-(start1.width)/2;
      
      cont1 = new Button(contP1Button, contP1Xcord, contP1Ycord);
      cont2 = new Button(contP2Button, contP2Xcord, contP2Ycord);
      
      startPlayer1 = new Button(start1, start1Xcord, startYcord);
      startPlayer2 = new Button(start2, start2Xcord, startYcord);
      startPlayer1.myImage2 = loadImage("startLeftP.png");
      startPlayer2.myImage2 = loadImage("startRightP.png");
      startPlayer1.secondPic = true;
      startPlayer2.secondPic = true;
      settingsButton = new Button(loadImage("options.png"), logoX -200, logoY-200, 200, 200);
      helpCreditsButton = new Button(loadImage("copyright.png"), logoX + logo.width , logoY + logo.height ,200, 200);
      settingsButton.setPath(logoX - 200, logoX + logo.width, logoY-200, logoY + logo.height);
      helpCreditsButton.setPath(logoX - 200, logoX + logo.width, logoY-200, logoY + logo.height);
      backButton = new Button(loadImage("leftHome.png"), 0, height-200, 200, 200);
      backButton2 = new Button(loadImage("rightHome.png"), width-200, 0, 200,200);
      checkButton = new Button(loadImage("check.png"), 200,200);
      wrongButton = new Button(loadImage("wrong.png"), 200,200);
      fiveButton = new Button(loadImage("five.png"), width*0.20, height*0.45,175,175);
      eightButton = new Button(loadImage("eight.png"), width*0.40, height*0.45,175,175);
      twelveButton = new Button(loadImage("twelve.png"), width*0.60, height*0.45,175,175);
      eightButton.myImage.filter(INVERT);
      lowButton = new Button(loadImage("low.png"), width*0.15, height*0.70, 300,200);
      medButton = new Button(loadImage("med.png"), width*0.40, height*0.70, 300,200);
      highButton = new Button(loadImage("high.png"), width*0.65, height*0.70, 300,200);
      lowButton.myImage.filter(INVERT);
      
      exitGameButtonP1 = new Button(loadImage("exitButtonLeft.png"), 0, 0, 100, 100);
      exitGameButtonP2 = new Button(loadImage("exitButtonRight.png"), width-100, height-100, 100, 100);
      
  }
  
  void calculateScores()
  {
    if(player1.statSwaps < 10)
    {
      swapStringP1      = "   Swaps made:            " + player1.statSwaps;
    }
    else if(player1.statSwaps < 100)
    {
      swapStringP1      = "   Swaps made:           " + player1.statSwaps;     
    }
    else
    {
      swapStringP1      = "   Swaps made:          " + player1.statSwaps;        
    }

    if(player1.statClears < 10)
    {
      clearStringP1     = "   Clears made:           " + player1.statClears;
    }
    else if(player1.statClears < 100)
    {
      clearStringP1     = "   Clears made:          " + player1.statClears;
    }
    else
    {
      clearStringP1     = "   Clears made:         " + player1.statClears;
    }
    
    if(player1.statPowerups < 10)
    {
      powerupStringP1   = "   Powerups used:         " + player1.statPowerups;
    }
    else if(player1.statPowerups < 100)
    {
      powerupStringP1   = "   Powerups used:        " + player1.statPowerups;
    }
    else
    {
      powerupStringP1   = "   Powerups used:       " + player1.statPowerups;
    }
    
    if(player1.statChains < 10)
    {
      chainStringP1     = "   Chains caused:         " + player1.statChains;
    }
    else if(player1.statChains < 100)
    {
      chainStringP1     = "   Chains caused:        " + player1.statChains;
    }
    else
    {
       chainStringP1     = "   Chains caused:       " + player1.statChains;
    }    
    
    if(player1.statBestChain < 10)
    {
      bestChainStringP1 = "   Best chain:            " + player1.statBestChain;      
    }
    else if(player1.statBestChain < 100)
    {
      bestChainStringP1 = "   Best chain:           " + player1.statBestChain;
    }
    else
    {
      bestChainStringP1 = "   Best chain:          " + player1.statBestChain;
    }
    
    if(player2.statSwaps < 10)
    {
      swapStringP2      = "   Swaps made:            " + player2.statSwaps;
    }
    else if(player2.statSwaps < 100)
    {
      swapStringP2      = "   Swaps made:           " + player2.statSwaps;     
    }
    else
    {
      swapStringP2      = "   Swaps made:          " + player2.statSwaps;        
    }

    if(player2.statClears < 10)
    {
      clearStringP2     = "   Clears made:           " + player2.statClears;
    }
    else if(player2.statClears < 100)
    {
      clearStringP2     = "   Clears made:          " + player2.statClears;
    }
    else
    {
      clearStringP2     = "   Clears made:         " + player2.statClears;
    }
    
    if(player2.statPowerups < 10)
    {
      powerupStringP2   = "   Powerups used:         " + player2.statPowerups;
    }
    else if(player2.statPowerups < 100)
    {
      powerupStringP2   = "   Powerups used:        " + player2.statPowerups;
    }
    else
    {
      powerupStringP2   = "   Powerups used:       " + player2.statPowerups;
    }
    
    if(player2.statChains < 10)
    {
      chainStringP2     = "   Chains caused:         " + player2.statChains;
    }
    else if(player2.statChains < 100)
    {
      chainStringP2     = "   Chains caused:        " + player2.statChains;
    }
    else
    {
       chainStringP2     = "   Chains caused:       " + player2.statChains;
    }    
    
    if(player2.statBestChain < 10)
    {
      bestChainStringP2 = "   Best chain:            " + player2.statBestChain;      
    }
    else if(player2.statBestChain < 100)
    {
      bestChainStringP2 = "   Best chain:           " + player2.statBestChain;
    }
    else
    {
      bestChainStringP2 = "   Best chain:          " + player2.statBestChain;
    }    
  }
  void displayScores()
  {
    textFont(font2);
    pushMatrix();
    textAlign(LEFT);
    image(scoreBG, cont1.myXcoord + cont1.myWidth + 5, height*0.2 , width - 2*(cont1.myXcoord + cont1.myWidth + 5), height*0.6); 
    float heightOffset = (height*0.3);
    fill(255);
    rotate(PI/2);
    text(swapStringP1, 0.5*height - heightOffset, 0.45*-width);
    text(clearStringP1, 0.5*height - heightOffset, 0.41*-width); 
    text(powerupStringP1, 0.5*height - heightOffset, 0.37*-width); 
    text(chainStringP1, 0.5*height - heightOffset, 0.33*-width); 
    text(bestChainStringP1, 0.5*height - heightOffset, 0.29*-width);
    textAlign(CENTER);
    textFont(font3);
    text(player1Status, 0.5*height, 0.21*-width); 
    popMatrix();

    textFont(font2);
    pushMatrix();
    textAlign(LEFT);
    rotate(-PI/2);
    text(swapStringP2, 0.5*-height - heightOffset, 0.55*width);
    text(clearStringP2, 0.5*-height - heightOffset, 0.59*width); 
    text(powerupStringP2, 0.5*-height - heightOffset, 0.63*width); 
    text(chainStringP2, 0.5*-height - heightOffset, 0.67*width); 
    text(bestChainStringP2, 0.5*-height - heightOffset, 0.71*width);
    textAlign(CENTER);
    textFont(font3);
    text(player2Status, 0.5*-height, 0.79*width);
    popMatrix();
    textAlign(CENTER);
    textFont(font1);

  }
}

