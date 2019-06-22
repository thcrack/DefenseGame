class BouncingCannon extends Cannon {
  
  int maxBouncingTimes = 5;
  int bouncedTimes = 0;
  Soldier lastSoldier = null;
  
  BouncingCannon(float x, float y, float targetAngle){
    super(x, y, targetAngle);
    img = bouncingcannonImg;
    damage = 60;
  }
  
  void onHit(Soldier soldier){
    // First, check if the hit soldier is the last soldier it hit before
    // If true, to avoid repeatedly hitting and bouncing on the same soldier, 
    // the cannon should just ignore this hit
    if(soldier == lastSoldier) return;
    
    // Apply damage to the soldier
    soldier.hurt(damage);
    
    // Check if the cannon has bounced FEWER times than max bouncing times
    // - If true, it means that it can still bounce:
    //      - Bounced times + 1
    //      - Remember the soldier it just hit
    //      - Update targetAngle to make a reflection effect
    // - If false, it means that it should "die" now
    if(bouncedTimes < maxBouncingTimes){
      bouncedTimes++;
      lastSoldier = soldier;
      targetAngle = getReflectionAngle(targetAngle);
    }else{
      isAlive = false;
    }
  }
  
  float getReflectionAngle(float inAngle){
    float outAngle = inAngle + radians(random(-30, 30)) + PI;
    if(outAngle > PI) outAngle -= TWO_PI;
    return outAngle;
  }
}
