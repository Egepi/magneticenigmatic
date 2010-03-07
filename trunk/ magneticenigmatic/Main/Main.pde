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
 
 //Board and tile size
 
 static final int TPR = 15, //Tiles per row
                MAX_R = 20; //Maximum number of rows
                //TILE_SIZE = 50;

//Implementation for dynamic based size?
//This works but really not what you want on a rectangular screen.
//int numTiles = TPR*MAX_R;
//int areaOverall = screen.width*screen.height;
//int tileArea = areaOverall/numTiles;
//int TILE_SIZE = int(sqrt(tileArea)) - 10;

//Implementation for tiles per row based size
//This forces there to be tiles from edge to edge on the short edge.
int TILE_SIZE = int(screen.height/TPR);
                
//Gameplay variables (change difficulty here)
 static final int TILE_TYPES = 6; //To avoid out-of-bounds errors go to "//Load resources into memory" to make sure the number of loaded images is equal to the number of images+1 (for null)

//Images
 static final String TILE1 = "Red.png",
                     TILE2 = "Blue.png",
                     TILE3 = "Green.png",
                     TILE4 = "Purple.png",
                     TILE5 = "White.png";
                      
/**************************************************************
 * Global variable declarations
 */
 
 
 

 PImage[] tileImageType = new PImage[TILE_TYPES];
 
 GameBoard theBoard;
 
 Selector sel1, sel2;

void setup()
{
  if (connectToTacTile)
    startTactile();
  //Load resources into memory
  sel1 = new Selector();
  sel2 = new Selector();
  tileImageType[0] = null;
  tileImageType[1] = loadImage(TILE1);
  tileImageType[2] = loadImage(TILE2);
  tileImageType[3] = loadImage(TILE3);
  tileImageType[4] = loadImage(TILE4);
  tileImageType[5] = loadImage(TILE5);
//tileImageType[6] = loadImage("");
  
  size(screen.width, screen.height);
  
  //Making the board the game will be played on.
  theBoard = new GameBoard(TPR, MAX_R);
  theBoard.generateBoard();
}

void draw()
{
  
  //Arbitrary background color for the time being.
  background(50,125,150);
  //Prints the board on the screen.
  getInput();
  theBoard.drawBoard();
  checkWin();
}

  void checkWin()
  {
    Tile tempTile;
    
    for(int i = 0; i < TPR-2; i++)
    {
      for(int j = 0; j < MAX_R; j++)
      {
        
        tempTile = theBoard.tileBoard[i][j];
        if(!(tempTile.getTileType() == 0))
        {
          if(tempTile.getTileType() == theBoard.tileBoard[i+1][j].getTileType())
          {
            if(tempTile.getTileType() == theBoard.tileBoard[i+2][j].getTileType())
            {
              theBoard.tileBoard[i][j].setTileType(0);
              theBoard.tileBoard[i+1][j].setTileType(0);
              theBoard.tileBoard[i+2][j].setTileType(0);
            }
          }
        }
     }
    }    
  }
  
void getInput()
{
    //theBoard.swap(6,5,4);
    if (connectToTacTile)
      getTouches();
    else if (mousePressed)
    {
       int newx, newy;
       newx = mouseY/TILE_SIZE;
       newy = mouseX/TILE_SIZE;
       if (sel1.getX() == -1)
         sel1.setSelector(newx,newy);
       else if (sel1.isEqual(newx,newy))
         ; // do nothing if mouse is at something already selected
       else
       {
         sel2.setSelector(newx,newy);
         theBoard.swap(sel1,sel2);
         sel1.reset();
         sel2.reset();
       }
    }
}
