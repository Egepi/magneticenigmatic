/* Project: POL
 * Authors: Jeremy Meador, Todd Silvia, 
 *          Karan Chakrapani, Lee Vanderlick
 * Date: March 3, 2010
 * Class - GameBoard: <Description goes here>
*/



class Momentum {
  static final int ACTIVE = 1,
                   INACTIVE = 0; 
  
  private double v; //v stands for velocity (scale: -100 to 100 % of MAX_V)
  private double y; // the relative location (0 is center)
  private int state;
  
  public Momentum() 
  {
     v = 0;
     y = 0;
     state = 1;
  }
  
  public double incrementY() {
    if ((state == ACTIVE)&&(MOMENTUM_ON)){
        y += v*MAX_V*0.0001; 
    }
    return y;
  }
  
  private void increaseMomentum(double x) 
  {
    v += x;
    if (v > MAX_V)
      v = MAX_V;
    else if (v < -MAX_V)
      v = -MAX_V;  
  }
  
  public void decreaseMomentum()
  {
    v-=(v*MOMENTUM_DECAY);
  }
  
  public void evaluateChain(int comboTotal, int tileCount, int sign)
  {
    double x = sign*(tileCount*(1.0+(comboTotal-1.0)*PER_COMBO_BONUS))*MOMENTUM_COEFF;
    increaseMomentum(x*momentumAdd);
  }
  
  public double getY() {
    return y;
  }
}

