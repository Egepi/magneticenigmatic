
class Chain
{
  private Player p;
  private int count;
  private ArrayList tiles;

  public Chain(Player pParam)
  {
    count = 0;
    p = pParam;
    tiles = new ArrayList();
  }
  
  public Chain getLargerChain (Chain other) {
    if (other == null)
      return this;
    if (count >= other.count)
      return this;
    return other;
  }
  
  //Can't make this a static method because of the way processing works...
  public Chain getLargestChain (ArrayList cl) {
    Chain nextChain;
    Chain largestChain = (Chain)cl.get(0);
    for (int j=1;j<cl.size();j++)
    {
      nextChain = (Chain)cl.get(j);
      if (nextChain.count > largestChain.count)
      {
        largestChain = nextChain;
      }
    }
    return largestChain;
  }

  public void addTile(Tile z)
  {
    z.chainID = this;
    tiles.add(z);
  }
  
  public void addTiles(Tile[] z)
  {
    for (int j = 0; j<z.length; j++)
    {
      z[j].chainID = this;
      tiles.add(z[j]);
    } 
  }

  public void removeIdleTiles()
  {
    Tile t;
    for (int j = tiles.size()-1; j>=0; j--)
    {
      t = (Tile)tiles.get(j);
      if (t.swappable())
        tiles.remove(j);
    }  
  }

  public int incrementChain()
  {
    count++;
    return count;
  }

  public int redeemChain() 
  {
    if (tiles.isEmpty())
    {
      int c = count;
      count = 0;
      return c;
    }
    else
      return 0;
  }
  
  public int getSomeY() { //dummy function for debugging
    return 10;
  }
}
