class Player
{
  //Modifiers
  public double speedModifier;
  public int speedEffectDuration;
  public int blindEffectDuration;
  public boolean blind;
  public boolean freeze;
  //Statistics
  public int statSwaps, statClears, statChains, statPowerups;
  private String name;
  private int roundsWon;
  
  public Player(String n)
  {
    name  = n;
    roundsWon = 0;
    speedModifier = 1;
    speedEffectDuration = -1;
    blind = false;
    blindEffectDuration = -1;
    freeze = false;
    statSwaps = 0;
    statClears = 0;
    statChains = 0;
    statPowerups = 0;
  }
  
  public void reset()
  {
    speedModifier = 1;
    speedEffectDuration = -1;
    blind = false;
    blindEffectDuration = -1;
    freeze = false;
    statSwaps = 0;
    statClears = 0;
    statChains = 0;
    statPowerups = 0;
  }
  
  public String getName()
  {
    return name;
  }
  
  public void drawPlayer()
  {
    if (speedEffectDuration > 0)
      speedEffectDuration -= timeDifference();
    else
      speedModifier = 1;
    if (blindEffectDuration > 0) 
      blindEffectDuration -= timeDifference();
    else
      blind = false;
  }
  
  public int getRoundsWon()
  {
    return this.roundsWon;
  }
  
  public void setRoundsWon(int inc)
  {
    this.roundsWon = inc;
  }
}

