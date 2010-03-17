class GameSounds //extends Minim
{
  AudioPlayer player;
  public GameSounds(String theFile)
  {
    player = minim.loadFile(theFile);
  }
  
  public void play()
  {
    player.play();
  }
  
  
  public void stop()
  {
    //player.close();
    minim.stop();
    //Minim.stop();
  }
  
  public void stopIfOver()
  {
    
    minim.stop();
  }
}
