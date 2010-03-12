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
import ddf.minim.*;

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
                MAX_R = 17, //Maximum number of rows
                PUZZLE_WIDTH = 500,
                TILE_SIZE = PUZZLE_WIDTH/TPR;
                
final int PUZZLE_ORIGIN_X = (screen.width/2) - ((MAX_R * TILE_SIZE)/2),
          PUZZLE_ORIGIN_Y = (screen.height/2) - ((TPR * TILE_SIZE)/2),
          HALF_MARK = (screen.width/2);
          
                
//Gameplay variables (change difficulty or speed here)
 static final int TILE_TYPES = 7, //To avoid out-of-bounds errors go to "//Load resources into memory" to make sure the number of loaded images is equal to the number of images+1 (for null)
                  MAX_V = 2,
                  MAX_TILE_V = 2,
                  TILE_COLORS = 6;

//Images
 static final String TILE0 = null,
                     TILE1 = "Red.png",
                     TILE2 = "Blue.png",
                     TILE3 = "Green.png",
                     TILE4 = "Purple.png",
                     TILE5 = "White.png",
                     TILE6 = "icecube.png";
                     
//For the sake of readability and code comprehension

 static final int EMPTY = 0;
                   
                      
/**************************************************************
 * Global variable declarations
 */
 
 
 

 PImage[] tileImageType = new PImage[TILE_TYPES];
 
 GameBoard theBoard;
 Momentum theMomentum;
 Selector sel1, sel2;
 GameFSM theGameFSM;
 int gameStartTime, frameStartTime, frameEndTime;
 
 
 int lineOfGravity = MAX_R/2 + 1;

void setup()
{
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
  
  size(screen.width, screen.height);
  
  //Making the board the game will be played on.
  theBoard = new GameBoard(TPR, MAX_R);
  theBoard.generateBoard();
  theMomentum = new Momentum();
  theGameFSM = new GameFSM();
}

void draw()
{
  frameStartTime = frameEndTime;
  frameEndTime = millis();
  background(50,125,150); //Arbitrary background color for the time being.
  theGameFSM.action();
}

void startClock() {
  gameStartTime = millis();
  frameStartTime = gameStartTime;
}

int timeDifference() {
  //print (frameEndTime-frameStartTime + " " );
  return frameEndTime-frameStartTime;
}
