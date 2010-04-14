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
        swap1.play();
        swap1.rewind();
      }
      else
      {
        swap2.play();
        swap2.rewind();
      }
    }
    sel1.reset();
    sel2.reset();
  }
}
