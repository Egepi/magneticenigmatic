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

/**************************************************************
 * Connection information
 */
TouchAPI touchInterface;
int dataPort;
int msgPort;
String touchServer;

/**************************************************************
 * Global Variables
 */
int WIDTH = 800;  //Defaults size to 800 x 600 if not specified otherwise
int HEIGHT = 600;
boolean touchInput;
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

