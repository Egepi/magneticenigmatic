void getTouches() {
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
  int theRand;
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
            if(selA.getY() < lineOfGravity )
            {
              swap1.play();
              swap1.rewind();
            }
            else
            {
              swap2.play();
              swap2.rewind();
            }
            //selList.remove(i);
            //selList.remove(j);
          }
        }
      }
    }
  }
}


