
void getTouches() {
  if ( ! tacTile.managedListIsEmpty() ){

    touchList = tacTile.getManagedList();
    
    // Cycle though the touches 
    
    for ( int index = 0; index < touchList.size(); index ++ ){
      
      Touches curTouch = (Touches) touchList.get(index);   

      if ( curTouch != null){
        //Grab Data
        float xCoord = curTouch.getXPos() * width;    
        float yCoord = height - curTouch.getYPos() * height;
        int newx, newy;        
        newx = int((yCoord-PUZZLE_ORIGIN_Y)/TILE_SIZE);
        newy = int((xCoord-PUZZLE_ORIGIN_X)/TILE_SIZE);
        if (sel1.getX() == -1)
          sel1.setSelector(newx,newy);
        else if (sel1.isEqual(newx,newy))
          ; // do nothing if touch is at something already selected
        else
        {
          sel2.setSelector(newx,newy);
          theBoard.swap(sel1,sel2);
          sel1.reset();
          sel2.reset();
        }
        

        //Grab the Intensity!!!
        //float intensity = curTouch.getIntensity();

        //get finger ID
        //int finger = curTouch.getFinger();
      }
    }
  }
}
