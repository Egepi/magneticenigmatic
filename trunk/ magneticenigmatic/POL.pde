Block b1 = new Block(0,0);
Block b2 = new Block(1,0);
Block b3 = new Block(2,0);
Block b4 = new Block(3,0);
Block b5 = new Block(4,0);
Block b6 = new Block(5,0);
Block b7 = new Block(6,0);

void setup()
{
  size (400,400);
  
}

void draw()
{
  b1.draw();
  b2.draw();
  b3.draw();
  b4.draw();
  b5.draw();
  b6.draw();
  b7.draw();
}


class Block
{
  private int x;
  private int y;
  private int blockColor;
  
  public Block(int xtemp, int ytemp) {
    x = xtemp;
    y = ytemp;
    blockColor = xtemp*40;
  }
  
  public void draw()
  {
    fill(blockColor,255-blockColor,128+blockColor/2);
    rect(32+x*32,height/2,32,32);
  }
  
  mouse
  
  public void swap(Block other) 
  {
    if (other.isSwappable()) {
      int temp = this.x;
      this.x = other.x;
      other.x = temp;
    }
  }
  
  public boolean isSwappable()
  {
    return true;
  }
  
  public boolean isSwappable(Block other)
  {
    if (abs(this.x-other.x) == 1) {
      
  }
}
