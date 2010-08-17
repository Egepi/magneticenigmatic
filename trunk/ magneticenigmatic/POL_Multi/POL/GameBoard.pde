/* Game: POL v 2.0
 * Class: GameBoard
*/

class GameBoard {
  private Tile tileBoard[][]; //Data structure to hold the game board.
  
  public GameBoard(int theWidth, int theHeight) {
    tileBoard = new Tile[theWidth][theHeight];
    for(int i = 0; i < TILES_PER_ROW; i++) {
      for(int j = 0; j < MAX_ROWS; j++) {
        tileBoard[i][j] = new Tile(0);
      } 
    }
  }//End GameBoard()
  
  public void drawBoard() {
    
  }//End drawBoard()
  
  private void createBoard() {
    for(int i = 0; i < TILES_PER_ROW; i++) {
      for(int j = LINE_OF_GRAVITY-START_ROWS/2; j < LINE_OF_GRAVITY+START_ROWS/2+1; j++) {
        tileBoard[i][j] = new Tile(int(random(1,TILE_COLORS)));
      }
    }
   return;
  }//End createBoard()
  
  public void createRow() {
  
  }//End createRow()
 
}//End GameBoard{}
