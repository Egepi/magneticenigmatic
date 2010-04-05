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
//Port for data transferf
int dataPort = 7100;
int msgPort = 7340;

/**************************************************************
 * Constants library (Do tweaking here, do not hardcode values)
 */
 
 //Board and tile size (careful with the commas here, I kept getting unexpected token errors because of having semi-colons instead of commas)
 
 static final int TPR = 8, //Tiles per row
                  MAX_R = 31, //Maximum number of rows
                  START_R = 17, //Number of rows to start with
                  PUZZLE_WIDTH = 500,
                  TILE_SIZE = PUZZLE_WIDTH/TPR;
                
final int PUZZLE_ORIGIN_X = (screen.width/2) - ((MAX_R * TILE_SIZE)/2),
          PUZZLE_ORIGIN_Y = (screen.height/2) - ((TPR * TILE_SIZE)/2),
          HALF_MARK = (screen.width/2);
          
                
//Gameplay variables (change difficulty, speed, and other settings here)
 static final int TILE_TYPES = 11, //To avoid out-of-bounds errors go to "//Load resources into memory" to make sure the number of loaded images is equal to the number of images+1 (for null)
                  MAX_V = 2,
                  MAX_TILE_V = 2,
                  TILE_COLORS = 6;
 static final double MOMENTUM_COEFF = 0.90;
 static final boolean DEBUG_MODE_ON = false,
                      MOMENTUM_ON = true,
                      ANIMATIONS_ON = true,
                      ROW_GENERATION_ON = true;
                      

//Images
 static final String TILE0 = "star.png",//"diamond.jpg",
                     TILE1 = "Red.png",
                     TILE2 = "Blue.png",
                     TILE3 = "Green.png",
                     TILE4 = "Purple.png",
                     TILE5 = "White.png",
                     TILE6 = "fire.png",
                     TILE7 = "icecube.png",
                     TILE8 = "clover.png",
                     TILE9 = "grapes.png",
                     TILE10 = "star.png";
                     
//For the sake of readability and code comprehension

 static final int EMPTY = 0,
                  HORIZONTAL = 0,
                  VERTICAL = 1; 
                   
                      
/**************************************************************
 * Global variable declarations
 */
 
 
 

 PImage[] tileImageType = new PImage[TILE_TYPES];
 
 GameBoard theBoard;
 Player player1 = new Player("Player 1");
 Player player2 = new Player("Player 2");
 Momentum theMomentum;
 ArrayList chainList = new ArrayList();
 Selector sel1, sel2;
 GameFSM theGameFSM;
 int gameStartTime, frameStartTime, frameEndTime, lastRowTime;
 Minim minim;  //Used for playing sound
 int middleX;
 
 int lineOfGravity = MAX_R/2;
 

void setup()
{
  minim = new Minim(this);
  startClock();
  if (connectToTacTile)
    startTactile();
  //Load resources into memory
  sel1 = new Selector();
  sel2 = new Selector();
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
  
  size(screen.width, screen.height);
  
  //Making the board the game will be played on.
  theBoard = new GameBoard(TPR, MAX_R);
  theBoard.generateBoard();
  theMomentum = new Momentum();
  theGameFSM = new GameFSM();
}

void draw()
{
  //print("\n0,0: " + theBoard.tileBoard[0][0].getTileType() + "     0,1: " + theBoard.tileBoard[0][1].getTileType());
  frameStartTime = frameEndTime;
  frameEndTime = millis();
  background(50,125,150); //Arbitrary background color for the time being.
  theGameFSM.action();
}

void startClock() {
  gameStartTime = millis();
  lastRowTime = millis();
  frameStartTime = gameStartTime;
}

int timeDifference() {
  //print (frameEndTime-frameStartTime + " " );
  return (frameEndTime-frameStartTime);
}

int rowTimeDifference() {
  return (millis()-lastRowTime);
}

