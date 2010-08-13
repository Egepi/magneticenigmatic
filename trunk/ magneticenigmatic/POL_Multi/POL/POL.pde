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
 public static int TILES_PER_ROW = 8;
 public static int TILE_SIZE = PUZZLE_WIDTH/TILES_PER_ROW;
 public static final int MAX_ROWS = 115;
 public static final int PUZZLE_WIDTH = 1030; 


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
boolean touchInput = false;
GameFSM theGameFSM;
ArrayList touchList = new ArrayList();


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
}//End draw

