
class Chain
{
  private Player p;
  private int count;
  private int totalTiles;
  private ArrayList tiles;

  public Chain(Player pParam)
  {
    count = 0;
    totalTiles = 0;
    p = pParam;
    tiles = new ArrayList();
    chainList.add(this);
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
    z.setChainID(this);
    tiles.add(z);
  }
  
  public void addTiles(Tile[] z)
  {
    for (int j = 0; j<z.length; j++)
    {
      z[j].setChainID(this);
      tiles.add(z[j]);
    } 
  }
  public void removeTile(Tile t)
  {
    tiles.remove(tiles.indexOf(t));
  }
  
  
  public void removeIdleTiles()
  {
    Tile t;
    for (int j = tiles.size()-1; j>=0; j--)
    {
      t = (Tile)tiles.get(j);
      if (t.isIdle())
      {
        tiles.remove(j);
        t.setChainID(null);
      }
      else if (theBoard.isNotInPuzzle(t))
      {
        tiles.remove(j);
        t.setChainID(null);
      }
    }  
  }

  public int incrementChain()
  {
    count++;
    return count;
  }
  
  public int increaseTotal(int x)
  {
    totalTiles+=x;
    return totalTiles;
  }

  public int redeemChain() 
  {
    if (tiles.isEmpty())
    {
      int c = count;
      count = 0;
      println("Chain redeemed with " + c + " combo(s) for " + p.getName() + ".");
      if (p == player1)
        theMomentum.increaseMomentum(totalTiles*totalTiles*MOMENTUM_COEFF);
      else if (p == player2)
        theMomentum.increaseMomentum(-totalTiles*totalTiles*MOMENTUM_COEFF);  
      chainList.remove(chainList.indexOf(this));
      return c;
    }
    else
    {
      Tile t = (Tile)tiles.get(0);
      //println ("Contains " + tiles.size() + " tiles. " + t.getState());
      return 0;
    }
  }
  
  public Player getPlayer()
  {
    return p;
  }
  
  public int getSomeY() { //dummy function for debugging
    return 10;
  }
}

