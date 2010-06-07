void mouseInput()
{
  int newx, newy;
  newx = (mouseY-PUZZLE_ORIGIN_Y)/TILE_SIZE;
  newy = (mouseX-PUZZLE_ORIGIN_X-(int)(theMomentum.getY()))/TILE_SIZE;
  if (sel1.getX() == -1)
    sel1.setSelector(newx,newy);
  else if (sel1.isEqual(newx,newy))
    ; // do nothing if mouse is at something already selected
  else
  {
    sel2.setSelector(newx,newy);
    if(theBoard.swap(sel1,sel2))
    {
      if(sel1.getY() < lineOfGravity)
      {
        if(STEREO_ON)
        {
          swap1.play();
          swap1.rewind();
        }
        else
        {
          swap.play();
          swap.rewind();
        }
        player1.addSwap();
      }
      else
      {
        if(STEREO_ON)
        {
          swap2.play();
          swap2.rewind();
        }
        else
        {
          swap.play();
          swap.rewind();
        }
        player2.addSwap();
      }
    }
    sel1.reset();
    sel2.reset();
  }
}
