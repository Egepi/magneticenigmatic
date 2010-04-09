public class Slider {
  
  private int maxValue;
  private int minValue;
  private int initValue;
  private int currValue;
  
  public Slider(int theMin, int theMax, int theInit)
  {
    this.maxValue = theMax;
    this.minValue = theMin;
    this.initValue = theInit;
  }
  
  public getCurrValue()
  {
    return this.currValue;
  }
}
