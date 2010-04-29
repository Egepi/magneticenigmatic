import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

/* Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: March 3, 2010
 * Class - Main: <Description goes here>
*/

/**************************************************************
 *  Imports
 */
 
import hypermedia.net.*;
import tacTile.net.*;
import processing.net.*;
import TouchEvents.*;
import java.util.ArrayList;

/**************************************************************
 * Tactile stuff
 */
 
boolean connectToTacTile = false;
//Touch API
TouchAPI tacTile;
//Names of machines you might use
ArrayList touchList = new ArrayList();
String localMachine = "127.0.0.1";
String tacTileMachine = "127.0.0.1";
//Port for data transfer
int dataPort = 7100;
int msgPort = 7340;

/**************************************************************
 * Constants library (Do tweaking here, do not hardcode values)
 */
 
 //Board and tile size (careful with the commas here, I kept getting unexpected token errors because of having semi-colons instead of commas)
 
 static final int TPR = 8, //Tiles per row
                  MAX_R = 31, //Maximum number of rows
                  START_R = 13, //Number of rows to start with
                  PUZZLE_WIDTH = 640,
                  TILE_SIZE = PUZZLE_WIDTH/TPR;
                
final int PUZZLE_ORIGIN_X = (screen.width/2) - ((MAX_R * TILE_SIZE)/2),
          PUZZLE_ORIGIN_Y = (screen.height/2) - ((TPR * TILE_SIZE)/2),
          HALF_MARK = (screen.width/2);
          
                
//Gameplay variables (change difficulty, speed, and other settings here)
 static final int TILE_TYPES = 11, //To avoid out-of-bounds errors go to "//Load resources into memory" to make sure the number of loaded images is equal to the number of images+1 (for null)
                  MAX_V = 100,
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
                  IMBALANCED_CUE = 5; //Cues imba music when block reaches within 1/n of total gameboard size.
 static final double MOMENTUM_COEFF = 1.9,
                     SPEED_POWERUP_MULTIPLIER = 2.0,
                     SLOW_POWERUP_MULTIPLIER = 0.5,
                     MOMENTUM_DECAY = 0.15,
                     PER_COMBO_BONUS = 0.25;
 static final boolean INFINITE_MODE = false, //NOT CURRENTLY USED (if true, game should continue despite a player losing)
                      DEBUG_MODE_ON = false, //if true, chain links are displayed, can also be used for other debugging purposes
                      SOUNDS_ON = true, 
                      MOMENTUM_ON = true,
                      ANIMATIONS_ON = true,
                      ROW_GENERATION_ON = true,
                      MOMENTUM_DECAY_ON = true;
                      

//Images
 static final String TILE0 = null,//"diamond.jpg",
                     TILE1 = "rust.png",
                     TILE2 = "ice.png",
                     TILE3 = "oxycopper.png",
                     TILE4 = "platinum.png",
                     TILE5 = "nugget.png",
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
                   
                      
/**************************************************************
 * Global variable declarations
 */
 
 
 

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
 AudioPlayer slowSound;
 AudioPlayer speedSound;
 AudioPlayer blindSound;
 AudioPlayer currentlyPlaying;
 AudioPlayer balancedBG;
 AudioPlayer imbalancedBG;
 AudioPlayer dangerBG;
 
int timer1 = -1;
int timer2 = -1;
PImage imageTime1;
PImage imageTime2;
int plyOneMove = 0;
int plyTwoMove = 0;
int oldSec;
int numOfPowerUps;
PImage backgroundPicture;


 int lineOfGravity = MAX_R/2;
 int timeBetweenRows = MAX_TIME_BETWEEN_ROWS;
 PFont font1;
 PImage logo;

 
 PImage p1Win;
 PImage p2Win;
 PImage p1Lose;
 PImage p2Lose;
 
 PImage[] powerArray = new PImage[3];
 
void setup()
{
  minim = new Minim(this);


  if (connectToTacTile)
    startTactile();
  sel1 = new Selector();
  sel2 = new Selector();

  size(screen.width, screen.height);
  
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

