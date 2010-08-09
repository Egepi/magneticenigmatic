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
int WIDTH;
int HEIGHT;
boolean touchInput;


/**************************************************************
 * MAIN SECTION
*/

void setup() {
   readConfigFile("todd_laptop.cfg");
   size(WIDTH,HEIGHT);
   
   if(touchInput) {
     startTouches();
   }
}//End setup()

void draw () {
  background(255,255,100);
}//End draw

