/*************************************************************
 * Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: April 23rd, 2010
 * Class - PowerUp: <Description goes here>
*************************************************************/
class PowerUp {
  int type;            //What kind of power up this is
  int picNum;          //Which picture in array of pictures
  Player player;       //Which player this powerup came from
  public int oldSec;   //Determines the current second the powerup was made or last updated
  int pTimer;          //Amount of time powerup has remaining - not applicale for all powerups
  AudioPlayer soundEffect;
  
  /************************************************************
  * Basic constructor for new PowerUp's
  *
  * Author: Todd Silvia
  */
  public PowerUp(int theType, Player thePlayer)
  {
    type = theType;
    player = thePlayer;
    player.addPowerups();
    switch(type) { //Determines which kind of powerup to make
      case SLOW: addSlow(); break;
      case FAST: addFast(); break;
      case STEAL: addSteal(); break;
      case BLIND: addBlind(); break;
      case FREEZE: addFreeze(); break;
    }
  }
  
  /************************************************************
  * Activates the slow powerup, where the opposite player of who
  * activated the powerup has slower swaps for a period of time.
  *
  * Author: Todd Silvia
  */
  private void addSlow()
  {
    otherPlayer(this.player).speedModifier = SLOW_POWERUP_MULTIPLIER;
    otherPlayer(this.player).speedEffectDuration = SLOW_POWERUP_DURATION;
    player = otherPlayer(player);
    this.setIcon(1);
    slowSound.play();
    slowSound.rewind();
    setTimer(SLOW_POWERUP_DURATION);
  }
  
  /************************************************************
  * Activates the speed up power effect, where the user who activated
  * the can swap blocks faster for a period of time.
  *
  * Author: Todd Silvia
  */
  private void addFast()
  {
    this.player.speedModifier = SPEED_POWERUP_MULTIPLIER;
    this.player.speedEffectDuration = SPEED_POWERUP_DURATION;
    this.setIcon(0);
    speedSound.play();
    speedSound.rewind();
    setTimer(SPEED_POWERUP_DURATION);

  }
  
  /************************************************************
  * Activates the powerup where the line of gravity moves towards
  * the opposite player who acitivated the powerup.
  *
  * Author: Todd Silvia,
  *         Jeremy Meador
  */
  private void addSteal()
  {
      if (this.player == player1)
      {
        plyOneMove += TILE_SIZE;  //Move the labels that hold the timers and players names
        plyTwoMove += TILE_SIZE;
        lineOfGravity += STEAL_POWERUP_NUMBER_OF_ROWS;
      }
      if (this.player == player2)
      {
        plyOneMove -= TILE_SIZE;  //Move the labels that hold the timers and players names
        plyTwoMove -= TILE_SIZE;
        lineOfGravity -= STEAL_POWERUP_NUMBER_OF_ROWS; 
      }
  }
  
  /************************************************************
  * Activates the blind powerup, where the blocks on the other
  * side of the board into all grey squares for a period of time.
  *
  * Author: Todd Silvia,
  *         Jeremy Meador
  */
  private void addBlind()
  {
    otherPlayer(this.player).blind = true;
    otherPlayer(this.player).blindEffectDuration = BLIND_POWERUP_DURATION;
    player = otherPlayer(player);
    this.setIcon(2);
    blindSound.play();
    blindSound.rewind();
    setTimer(BLIND_POWERUP_DURATION);
  }
  
  /************************************************************
  * Activiates the freeze powerup
  *
  * Author: Todd Silvia,
  *         Jeremy Meador
  */
  private void addFreeze()
  {
    otherPlayer(this.player).freeze = true;
     //not implemented yet
     //should make the next blocks that come in for opp. player appear differently when 
     //    they come in from outside the puzzle and he/she won't be able to move them for a while
  }
  
  /************************************************************
  * If the powerup was activated by a player, this method switches
  * the effect of the powerup to the opposite player.
  *
  * Author: Todd Silvia,
  *         Jeremy Meador
  */
  private Player otherPlayer(Player p)
  {
    if (p == player1)
      return player2;
    if (p == player2)
      return player1;  
    return null;
  }

  /************************************************************
  * Sets a timer until the given powerup wears off. Also determines
  * which picture to display while timer is on the screen.
  *
  * Author: Todd Silvia
  */
  private void setTimer(int dur)
  {
      if(this.player.name == "Player 1")
      {
        pTimer = dur/1000;
        timer1 = dur/1000;
      }
      else if(this.player.name == "Player 2")
      {
        timer2 = dur/1000;
        pTimer = dur/1000;
      }
      oldSec = second();
  }
  
  private void setIcon(int theIcon)
  {
    if(this.player.name == "Player 1")
    {
      imageTime1 = powerArray[theIcon];
    }
    else if(this.player.name == "Player 2")
    {
      imageTime2 = powerArray[theIcon];
    }
  }
  
  public void setOldSec(int theNewSec)
  {
    this.oldSec = theNewSec;
  }
  
  public void setNewTime(int newTime)
  {
    this.pTimer = newTime;
  }
  
  public int getOldSec()
  {
    return this.oldSec;
  }
  
  public int getTime()
  {
    return this.pTimer;
  }
}//END Class PowerUp
