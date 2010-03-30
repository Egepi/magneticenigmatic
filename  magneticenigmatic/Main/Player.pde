class Player
{
  //Modifiers
  private int speedModifier;
  private int blockStateModifier;
  //Statistics
  private int statSwaps, statClears, statChains, statPowerups;
  private String name;
  
  public Player(String n)
  {
    name  = n;
    
    speedModifier = 1;
    blockStateModifier = 0;
    
    statSwaps = 0;
    statClears = 0;
    statChains = 0;
    statPowerups = 0;
  }
  
  public String getName()
  {
    return name;
  }
}
