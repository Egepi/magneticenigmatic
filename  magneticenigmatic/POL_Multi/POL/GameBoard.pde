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
    int tempX = PUZZLE_ORIGIN_X;
    int tempY;
    boolean blind;
    for (int d = 0; d < 3; d++) {
      tempX = PUZZLE_ORIGIN_X;
      tempY = PUZZLE_ORIGIN_Y;
      for(int x = 0; x < TILES_PER_ROW; x++){
        for(int y = 0; y < MAX_ROWS; y++){
          if (tileBoard[x][y].depth == d){
            tileBoard[x][y].drawTile(tempX,tempY);
          }
          tempX = tempX + TILE_SIZE;
        }
        tempY = tempY + TILE_SIZE;
        tempX = PUZZLE_ORIGIN_X;
      }
    }    
   fill(0,0,0,128);
   rect(PUZZLE_ORIGIN_X + LINE_OF_GRAVITY*TILE_SIZE, 0, TILE_SIZE, height);
   fill(0,0,0,255);
    
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
