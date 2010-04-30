class Button
{
  PImage myImage;
  PImage myImage2 = null;
  float myXcoord;
  float myYcoord;
  int myWidth;
  int myHeight;
  boolean secondPic;
  
  int switchCount = 0;
  
  //path stuff
  int myPathMinX;
  int myPathMaxX;
  int myPathMinY;
  int myPathMaxY;  
  
  public Button(PImage theImage, float theX, float theY)
  {
    myImage = theImage;
    myXcoord = theX;
    myYcoord = theY;
    myWidth = theImage.width;
    myHeight = theImage.height;  
    secondPic = false;
  }
  
  public Button(PImage theImage, float theX, float theY, int theWidth, int theHeight)
  {
    myImage = theImage;
    myXcoord = theX;
    myYcoord = theY;
    myWidth = theWidth;
    myHeight = theHeight;  
    secondPic = false;
  }
  
  void drawit()
  {
    //if(secondPic == true)
    //  image(myImage2, myXcoord, myYcoord, myWidth, myHeight);
    //else
      image(myImage, myXcoord, myYcoord, myWidth, myHeight);
  }
  
  public void move()
  {

    if(myXcoord < myPathMaxX && myYcoord == myPathMinY)
    {
      myXcoord = myXcoord + 5;
    }
    else if(myXcoord > myPathMinX && myYcoord == myPathMaxY)
    {
      myXcoord = myXcoord - 5;   
    }
    else if(myYcoord < myPathMaxY && myXcoord == myPathMaxX)
    {
      myYcoord = myYcoord + 5;   
    }
    else if(myYcoord > myPathMinY && myXcoord == myPathMinX)
    {
      myYcoord = myYcoord - 5;    
    }
  }
  public void setPath(int leftX, int rightX, int topY, int bottomY)
  {
    myPathMinX = leftX;
    myPathMaxX = rightX;
    myPathMinY = topY;
    myPathMaxY = bottomY;
  }
  
  int checkBounds()
  {
    
    if(!connectToTacTile)
    {
      if(mousePressed)
      {
        int xCoord = mouseX;
        int yCoord = mouseY;
        if((xCoord >= myXcoord)&&(xCoord <= (myXcoord + myWidth)))
        {
            if((yCoord >= myYcoord)&&(yCoord <= (myYcoord + myHeight)))
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
          if((xCoord >= myXcoord)&&(xCoord <= (myXcoord + myWidth)))
          {
            if((yCoord >= myYcoord)&&(yCoord <= (myYcoord + myHeight)))
            {
              return 1;
            }
          }
        }
      }
    }
    
    return 0;
    
  }
  
  void decrementSwitch()
  {
    if(switchCount > 0) switchCount--;
  }
}
