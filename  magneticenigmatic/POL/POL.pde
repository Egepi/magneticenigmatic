

/* Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: March 3, 2010
 * Class - Main: <Description goes here>
*/               

/**************************************************************
 *  Imports
 */
import processing.opengl.*;

import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
 
import hypermedia.net.*;
import tacTile.net.*;
import processing.net.*;
import java.util.ArrayList;

/**************************************************************
 * Tactile stuff
 */
 
boolean connectToTacTile = false;
boolean NEC_WALL = false;
//Touch API
TouchAPI tacTile;
//Names of machines you might use
ArrayList touchList = new ArrayList();
String localMachine = "127.0.0.1";
String tacTileMachine = "131.193.77.104";
//Port for data transfer
int dataPort = 7100;
int msgPort = 7340;

/**************************************************************
 * Constants library (Do tweaking here, do not hardcode values)
 */
 
 //Board and tile size (careful with the commas here, I kept getting unexpected token errors because of having semi-colons instead of commas)
 
 int TPR = 8; 
 int TILE_SIZE = PUZZLE_WIDTH/TPR;
 int PUZZLE_ORIGIN_X;
 int PUZZLE_ORIGIN_Y;
 static final int MAX_R = 115, //Maximum number of rows
                  START_R = 35, //Number of rows to start with
                  PUZZLE_WIDTH = 1030;
       
                
//Gameplay variables (change difficulty, speed, and other settings here)
 static final int TILE_TYPES = 11, //To avoid out-of-bounds errors go to "//Load resources into memory" to make sure the number of loaded images is equal to the number of images+1 (for null)
                  MAX_V = 300,
                  MAX_TILE_V = 2,
                  TILE_COLORS = 6,
                  TIME_BETWEEN_DECAY = 1000,
                  MAX_TIME_BETWEEN_ROWS = 15000,
                  MIN_TIME_BETWEEN_ROWS = 5000,
                  SPEED_POWERUP_DURATION = 10000, //millis
                  SLOW_POWERUP_DURATION = 10000, // millis
                  STEAL_POWERUP_NUMBER_OF_ROWS = 1,
                  BLIND_POWERUP_DURATION = 10000,
                  FREEZE_POWERUP_NUMBER_OF_ROWS = 1,
                  DANGER_CUE = 10, //Cues danger music when block reaches within 1/n of total gameboard size.
                  IMBALANCED_CUE = 5, //Cues imba music when block reaches within 1/n of total gameboard size.
                  LOW_MOMENTUM = 1,
                  MED_MOMENTUM = 2,
                  HIGH_MOMENTUM = 3,
                  EXIT_TIME = 85;
                  
                  
 double MOMENTUM_COEFF = 2.00;
 int momentumAdd = 1;
 static final double SPEED_POWERUP_MULTIPLIER = 2.0,
                     SLOW_POWERUP_MULTIPLIER = 0.5,
                     MOMENTUM_DECAY = 0.15,
                     PER_COMBO_BONUS = 0.25;
 static final boolean INFINITE_MODE = false, //NOT CURRENTLY USED (if true, game should continue despite a player losing)
                      DEBUG_MODE_ON = false, //if true, chain links are displayed, can also be used for other debugging purposes
                      MOMENTUM_ON = true,
                      ANIMATIONS_ON = true,
                      ROW_GENERATION_ON = true,
                      MOMENTUM_DECAY_ON = true,
                      STEREO_ON = true;
                      

//Images
 static final String TILE0 = null,//"diamond.jpg",
                     TILE1 = "redball.png",
                     TILE2 = "blueball.png",
                     TILE3 = "greenballtexture.png",
                     TILE4 = "purpleballtexture.png",
                     TILE5 = "goldballtexture.png",
                     TILE6 = "lightning.png",
                     TILE7 = "snow.png",
                     TILE8 = "slow.png",
                     TILE9 = "eye.png",
                     TILE10 = "arrow.png",
                     //CLTILE = "Colorless_patternless.png";
                     CLTILE = "silverball.png",
                     POWER1 = "lightning_time.png",
                     POWER2 = "turtle_time.png",
                     POWER3 = "eye_time.png";
                     
static final String PICE1 = "redIce.png",
                    PICE2 = "blueIce.png",
                    PICE3 = "greenIce.png",
                    PICE4 = "purpleIce.png",
                    PICE5 = "goldIce.png";                    
                     
//For the sake of readability and code comprehension

 static final int EMPTY = 0,
                  HORIZONTAL = 0,
                  VERTICAL = 1,
                  NONE = 100,
                  SLOW = 108,
                  FAST = 106,
                  STEAL = 110,
                  BLIND = 109,
                  FREEZE = 107;
                 
static final int  LOGO_STATE = 0,
                  START_STATE = 1,
                  OPTION_STATE = 2,
                  CREATE_STATE = 3,
                  GAME_STATE = 4,
                  END_STATE = 5,
                  HELP_STATE = 6;
                   
                      
/**************************************************************
 * Global variable declarations
 */
 
 
 
 boolean SOUNDS_ON = true; 
 boolean VERTICAL_SWAPS_ON = true;
 PImage[] tileImageType = new PImage[TILE_TYPES];
 PImage colorlessTile = new PImage();
 GameBoard theBoard;
 Player player1 = new Player("Player 1");
 Player player2 = new Player("Player 2");
 Momentum theMomentum;
 ArrayList chainList = new ArrayList();
 ArrayList animationList = new ArrayList();
 ArrayList selList = new ArrayList();
 ArrayList pOneUp = new ArrayList();
 ArrayList pTwoUp = new ArrayList();
 Selector sel1, sel2;
 GameFSM theGameFSM;
 int gameStartTime, frameStartTime, frameEndTime, lastRowTime, lastDecayTime;

 Minim minim;  //Used for playing sound
 AudioPlayer swap1;
 AudioPlayer swap2;
 AudioPlayer swap;
 
 AudioPlayer freezeSound;
 AudioPlayer freezeSoundP1;
 AudioPlayer freezeSoundP2;
 
 AudioPlayer slowSound;
 AudioPlayer slowSoundP1;
 AudioPlayer slowSoundP2;

 AudioPlayer speedSound;
 AudioPlayer speedSoundP1;
 AudioPlayer speedSoundP2;
 
 AudioPlayer blindSound;
 AudioPlayer blindSoundP1;
 AudioPlayer blindSoundP2;

 AudioPlayer[] clear = new AudioPlayer[6];
 AudioPlayer[] clearP1 = new AudioPlayer[6];
 AudioPlayer[] clearP2 = new AudioPlayer[6];
 
 AudioPlayer arrowSound;
 AudioPlayer victorySound;
 
 AudioPlayer currentlyPlaying;
 AudioPlayer balancedBG;
 
 AudioPlayer imbalancedBG;
 AudioPlayer dangerBG;
 AudioPlayer imbalancedBGP1;
 AudioPlayer dangerBGP1;
 AudioPlayer imbalancedBGP2;
 AudioPlayer dangerBGP2;
 
int timer1 = -1;
int timer2 = -1;
PImage imageTime1;
PImage imageTime2;
int plyOneMove = 0;
int plyTwoMove = 0;
int oldSec1;
int oldSec2;
int numOfPowerUps;
PImage backgroundPicture;


 int lineOfGravity = MAX_R/2;
 int timeBetweenRows = MAX_TIME_BETWEEN_ROWS;
 PFont font1;
 PFont font2;
 PFont font3;
 PImage logo;

 
 PImage scoreBG;
 
 PImage[] powerArray = new PImage[3];
 PImage[] iceArray = new PImage[5];
 
void setup()
{
  minim = new Minim(this);
  int w = screen.width;
  int h = screen.height;
  size(w, h);
  readConfigFile("config.cfg");
  if (connectToTacTile)
    startTactile();
  sel1 = new Selector();
  sel2 = new Selector();

  
  
  //Making the board the game will be played on.
  theGameFSM = new GameFSM();
  theGameFSM.action();

}

void draw()
{
  
  frameStartTime = frameEndTime;
  frameEndTime = millis();
  //background(50,125,150);
  theGameFSM.action();
  textAlign(LEFT);
  //debugCode();
  textAlign(CENTER);
}

void startClock() {
  gameStartTime = millis();
  lastRowTime = millis();
  lastDecayTime = millis();
  frameStartTime = gameStartTime;
}

int timeDifference() {
  //print (frameEndTime-frameStartTime + " " );
  return (frameEndTime-frameStartTime);
}

int rowTimeDifference() {
  return (millis()-lastRowTime);
}

int decayTimeDifference() {
  return (millis()-lastDecayTime);
}

/**
 * Parses a config file for touch tracker information.
 * By Arthur Nishimoto
 * 
 * @param config_file Text file containing tracker information.
 */
void readConfigFile(String config_file){
  String[] rawConfig = loadStrings(config_file);

  tacTileMachine = "localhost";
  if( rawConfig == null ){
    println("No tracker information provided by config.cfg. Connecting to localhost.");
  }
  else {
    String tempStr = "";

    for( int i = 0; i < rawConfig.length; i++ ){
      rawConfig[i].trim(); // Removes leading and trailing white space
      if( rawConfig[i].length() == 0 ) // Ignore blank lines
        continue;

      if( rawConfig[i].contains("//") ) // Removes comments
          rawConfig[i] = rawConfig[i].substring( 0 , rawConfig[i].indexOf("//") );

      if( rawConfig[i].contains("TRACKER_MACHINE") ){
        tacTileMachine = rawConfig[i].substring( rawConfig[i].indexOf("\"")+1, rawConfig[i].lastIndexOf("\"") );
        continue;
      }
      if( rawConfig[i].contains("DATA_PORT") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        dataPort = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("MSG_PORT") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        msgPort = Integer.valueOf( tempStr.trim() );
        continue;
      }

    }// for
    println("Connecting to Tracker: '"+tacTileMachine+"' Data port: "+dataPort+" Message port: "+msgPort+".");
  }
}// readConfigFile
