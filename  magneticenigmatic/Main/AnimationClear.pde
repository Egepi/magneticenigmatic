class AnimationClear
{
  PImage i;
  int x,y,time,step;
  AnimationClear(PImage im, int tx, int ty)
  {
    i = im;
    time = millis();
    step = 0;
    x = tx;
    y = ty;
    
  }
  
  public void step()
  {
    while (millis()-time >= 25)
    {
      step++;
      time += 25;
    }
    drawMe();
  }
  
  private void drawMe()
  {
    int d,b,e;
    if (step < 5)
    {
      d = step*(TILE_SIZE/10);
      image(i,x+d,y+d,TILE_SIZE-2*d,TILE_SIZE-2*d);
    }
    else
    {
      if (step < 20)
      {
        d = (TILE_SIZE/2)-(step-5)*(TILE_SIZE/16);
        e = 2*(step-5)*(TILE_SIZE/16);
        b = 255-(step-5)*(256/16);
        tint(255,b);
        image(i,x+d,y+d,e,e);
        tint(255,255);
      }
      else
        animationList.remove(this);
    }
    return;
  }
}
