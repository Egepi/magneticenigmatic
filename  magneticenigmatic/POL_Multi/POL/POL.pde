/* Game: POL v 2.0
 * Updated: 8/9/10
 */

/**************************************************************
 * Imports
 */
import tacTile.net.*;


/**************************************************************
 * Constants
 */
 public static final int MAX_ROWS = 115,
                         PUZZLE_WIDTH = 1030,
                         TILE_TYPES = 11; 
 public static int TILES_PER_ROW = 8,
                   TILE_SIZE = PUZZLE_WIDTH/TILES_PER_ROW,
                   LINE_OF_GRAVITY = MAX_ROWS/2,
                   TILE_COLORS = 5,
                   START_ROWS = 35;
 
 public final String TILE0 = null,
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
                     BLIND_TILE = "silverball.png",
                     POWER1 = "lightning_time.png",
                     POWER2 = "turtle_time.png",
                     POWER3 = "eye_time.png";



/**************************************************************
 * Connection information
 */
TouchAPI touchInterface;
int dataPort = 7000;
int msgPort = 7340;
String touchServer;

/**************************************************************
 * Global Variables
 */
int WIDTH = 800;  //Defaults size to 800 x 600 if not specified otherwise
int HEIGHT = 600;
String PLATFORM = "";
boolean touchInput = false,
        DEBUG_ON = false;
GameFSM theGameFSM;
ArrayList touchList = new ArrayList();
PImage[] tileImageType = new PImage[TILE_TYPES];


/**************************************************************
 * MAIN SECTION
 */

void setup() {
  readConfigFile("todd_laptop.cfg");
  size(WIDTH,HEIGHT);
  if(touchInput) { startTouches(); }
  theGameFSM = new GameFSM();
}//End setup()

void draw () {
  theGameFSM.action();
  checkDebug();
}//End draw

private void checkDebug() {
  if(DEBUG_ON) {
    debugCode();
  }
}

public void keyPressed() {
 if(key == 'd') {
    DEBUG_ON = !DEBUG_ON;
 } 
}

