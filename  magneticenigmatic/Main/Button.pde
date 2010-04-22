class Button
{
  PImage myImage;
  float myXcoord;
  float myYcoord;
  public Button(PImage theImage, float theX, float theY)
  {
    myImage = theImage;
    myXcoord = theX;
    myYcoord = theY;
  }
  
  void drawit()
  {
    image(myImage, myXcoord, myYcoord);
  }
  
  int checkBounds()
  {
    
    if(!connectToTacTile)
    {
      if(mousePressed)
      {
        int xCoord = mouseX;
        int yCoord = mouseY;
        if((xCoord >= myXcoord)&&(xCoord <= (myXcoord + myImage.width)))
        {
            if((yCoord >= myYcoord)&&(yCoord <= (myYcoord + myImage.height)))
            {
              return 1;
            }
        }
      }
    }
        
    if ((tacTile != null)&&( ! tacTile.managedListIsEmpty() )){

      touchList = tacTile.getManagedList();
    
      // Cycle though the touches 
      for ( int index = 0; index < touchList.size(); index ++ ){
        Touches curTouch = (Touches) touchList.get(index);   
        if ( curTouch != null){
          float xCoord = curTouch.getXPos() * width;    
          float yCoord = height - curTouch.getYPos() * height;
          if((xCoord >= myXcoord)&&(xCoord <= (myXcoord + myImage.width)))
          {
            if((yCoord >= myYcoord)&&(yCoord <= (myYcoord + myImage.height)))
            {
              return 1;
            }
          }
        }
      }
    }
    
    return 0;
    
  }
}
