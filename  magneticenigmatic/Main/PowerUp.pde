class PowerUp {
  int type;
  int picNum;
  Player player;
  public int oldSec;
  int pTimer;
  
  public PowerUp(int theType, Player thePlayer)
  {
    type = theType;
    player = thePlayer;
    switch(type) {
      case SLOW: addSlow(); break;
      case FAST: addFast(); break;
      case STEAL: addSteal(); break;
      case BLIND: addBlind(); break;
      case FREEZE: addFreeze(); break;
    }
  }
  
  public int getOldSec()
  {
    return oldSec;
  }
  private void addSlow()
  {
    otherPlayer(this.player).speedModifier = SLOW_POWERUP_MULTIPLIER;
    otherPlayer(this.player).speedEffectDuration = SLOW_POWERUP_DURATION;
    picNum = 8;
    setTimer(SLOW_POWERUP_DURATION);
  }
  
  private void addFast()
  {
    this.player.speedModifier = SPEED_POWERUP_MULTIPLIER;
    this.player.speedEffectDuration = SPEED_POWERUP_DURATION;
    picNum = 6;
    setTimer(SPEED_POWERUP_DURATION);

  }
  
  private void addSteal()
  {
      if (this.player == player1)
      {
        plyOneMove += TILE_SIZE;
        plyTwoMove += TILE_SIZE;
        lineOfGravity += STEAL_POWERUP_NUMBER_OF_ROWS;
      }
      if (this.player == player2)
      {
        plyOneMove -= TILE_SIZE;
        plyTwoMove -= TILE_SIZE;
        lineOfGravity -= STEAL_POWERUP_NUMBER_OF_ROWS; 
      }
  }
  
  private void addBlind()
  {
    otherPlayer(this.player).blind = true;
    otherPlayer(this.player).blindEffectDuration = BLIND_POWERUP_DURATION;
    picNum = 9;
    setTimer(BLIND_POWERUP_DURATION);
  }
  
  private void addFreeze()
  {
    otherPlayer(this.player).freeze = true;
     //not implemented yet
     //should make the next blocks that come in for opp. player appear differently when they come in from outside the puzzle and he/she won't be able to move them for a while
  }
  
  private Player otherPlayer(Player p)
  {
    if (p == player1)
      return player2;
    if (p == player2)
      return player1;  
    return null;
  }
  
  private void setTimer(int dur)
  {
      if(this.player.name == "Player 1")
      {
        pTimer = dur/1000;
        timer1 = dur/1000;
        imageTime1 = tileImageType[picNum];
//        pOneUp[0] = this;
      }
      else if(this.player.name == "Player 2")
      {
        timer2 = dur/1000;
        pTimer = dur/1000;
        imageTime2 = tileImageType[picNum];
//        pTwoUp[0] = this;
      }
      oldSec = second();
  }
}
