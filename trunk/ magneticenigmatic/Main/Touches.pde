void getTouches() {

  if(TOUCH_TYPE == 1)
  {
    touchesOne();
  }
  else if(TOUCH_TYPE == 2)
  {
    touchesTwo();
  }
  else //type 3
  {
    touchesThree();
  }

}

/***********************************************************************************************************/

void touchesOne()
{
  if ( ! tacTile.managedListIsEmpty() ){

    touchList = tacTile.getManagedList();
    selList.clear();
    // Cycle though the touches 

    for ( int index = 0; index < touchList.size(); index ++ )
    {

      Touches curTouch = (Touches) touchList.get(index);   

      if ( curTouch != null)
      {
        //Grab Data
        float xCoord = curTouch.getXPos() * width;    
        float yCoord = height - curTouch.getYPos() * height;
        int newx, newy;        
        newx = int((yCoord-PUZZLE_ORIGIN_Y)/TILE_SIZE);
        newy = int((xCoord-PUZZLE_ORIGIN_X-(int)(theMomentum.incrementY()))/TILE_SIZE);


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


        selList.add(new Selector(newx, newy));

        //Grab the Intensity!!!
        //float intensity = curTouch.getIntensity();

        //get finger ID
        //int finger = curTouch.getFinger();
      }
    }
  }
}

/***********************************************************************************************************/

void touchesTwo()
{
  if ( ! tacTile.managedListIsEmpty() ){

    touchList = tacTile.getManagedList();
    selList.clear();
    // Cycle though the touches 

    for ( int index = 0; index < touchList.size(); index ++ )
    {

      Touches curTouch = (Touches) touchList.get(index);   

      if ( curTouch != null)
      {
        //Grab Data
        float xCoord = curTouch.getXPos() * width;    
        float yCoord = height - curTouch.getYPos() * height;
        int newx, newy;        
        newx = int((yCoord-PUZZLE_ORIGIN_Y)/TILE_SIZE);
        newy = int((xCoord-PUZZLE_ORIGIN_X-(int)(theMomentum.incrementY()))/TILE_SIZE);

        /*
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
         */

        selList.add(new Selector(newx, newy));

        //Grab the Intensity!!!
        //float intensity = curTouch.getIntensity();

        //get finger ID
        //int finger = curTouch.getFinger();
      }
    }

    compareTouches();
  }
}
void compareTouches()
{
  int i,j;
  Selector selA, selB;
  for(i = 0; i < selList.size()-1; i++)
  {
    selA = (Selector)selList.get(i);
    if ((selA != null) && (selList.size() > 1))
    {
      for(j = i+1; j < selList.size(); j++)
      {
        selB = (Selector)selList.get(j);
        if(selB != null)
        {
          if(theBoard.swap(selA, selB))
          {
            //selList.remove(i);
            //selList.remove(j);
          }
        }
      }
    }
  }
}

/***********************************************************************************************************/

void touchesThree()
{
  //the process() method generates a listing of new, expired, and moved touches. 
  //It must be called before attempting to use the following methods.
  //if you plan to use a combination of getManagedList and these methods,
  //getManagedList calls process() for you so you don't have to.
  tacTile.process();

  //Gives you expired touches. Alternate method name: getExpiredTouches()
  ArrayList newUp = tacTile.getTouchesUp();         
  //gives you new touches. Alternate method name: getNewTouches()
  ArrayList newDown = tacTile.getTouchesDown();
  //gives you touches that have moved. Alternate method name: getTouchesMoved()
  ArrayList newMoved = tacTile.getMovedTouches();


  //loop through each list, getting the touch, assign it a color, and
  //display it to screen. Each list has its own ellipse shape. 
  if( !newUp.isEmpty() ){
    for(int i = 0; i < newUp.size(); i++){
      Touches touch = ((Touches) newUp.get(i));
      println("New Up: " + touch.getFinger());

      int finger = touch.getFinger();

      color shapeColor = getColor(finger);

      fill(shapeColor);
      ellipse(1920 * touch.getXPos(), 1080 - touch.getYPos() * 1080, 20, 50);
    } 
  }

  if( !newDown.isEmpty() ){
    for(int i = 0; i < newDown.size(); i++){
      Touches touch = ((Touches) newDown.get(i));

      println("New Down: " + touch.getFinger() + " at " + touch.getXPos() + ", " + touch.getYPos());
      int finger = touch.getFinger();

      color shapeColor = getColor(finger);

      fill(shapeColor);
      ellipse(1920 * touch.getXPos(), 1080 - touch.getYPos() * 1080, 50, 20);

    } 
  }

  if( !newMoved.isEmpty() ){
    for(int i = 0; i < newMoved.size(); i++){
      Touches t = ((Touches) newMoved.get(i));
      println("New Moved: " + t.getFinger());

      int finger = t.getFinger();

      color shapeColor = getColor(finger);

      fill(shapeColor);
      ellipse(1920 * t.getXPos(), 1080 - t.getYPos() * 1080, 20, 20);


    } 
  }
}
color getColor( int finger ){
  

      //assign color based on finger ID
      int colorNum = finger % 10;
      color shapeColor = #000000;
      switch (colorNum){
      case 0: shapeColor = #D2691E; break;  //chocolate
      case 1: shapeColor = #DC143C; break;  //Crimson
      case 2: shapeColor = #9400D3; break;  //Dark violet
      case 3: shapeColor = #FF4500; break;  //Orange Red
      case 4: shapeColor = #2E8B57; break;  //Sea Green        
      case 5: shapeColor = #B8860B; break;  //Dark Golden Rod
      case 6: shapeColor = #696969; break;  //Dim Gray
      case 7: shapeColor = #7CFC00; break;  //Lawngreen
      case 8: shapeColor = #4B0082; break;  //Indigo
      case 9: shapeColor = #6B8E23; break;  //Olive Drab
      }
    
    return shapeColor;  
  
  
}

