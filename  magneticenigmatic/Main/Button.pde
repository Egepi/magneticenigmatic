class Button
{
  PImage myImage;
  float myXcord;
  float myYcord;
  public Button(PImage theImage, float theX, float theY)
  {
    myImage = theImage;
    myXcord = theX;
    myYcord = theY;
  }
  
  void drawit()
  {
    image(myImage, myXcord, myYcord);
  }
}
