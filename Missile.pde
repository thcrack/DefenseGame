class Missile extends Rocket {
  
  int currentTargetIndex = -1;
  
  Missile(float x, float y, float targetAngle){
    super(x, y, targetAngle);
    img = missileImg;
    speed = 2;
    damage = 25;
    explosionTime = 0.5;
    explosionRadius = 50;
    speedIncreasePerSecond = 1;
    maxFollowingAngle = 90;
  }
  
  void searchForTarget(){
    float shortestDist = 999999;
    for(int j = 0; j < soldiers.length; j++){
      
      // First, check if the soldier exists and is alive
      // if not, skip to the next one
      if(soldiers[j] == null || !soldiers[j].isAlive) continue;
      
      // Then check if the soldier is inside our max following angle
      // if not, skip to the next one
      float angle = atan2(soldiers[j].y - y, soldiers[j].x - x);
      if(getRadiansDifference(targetAngle, angle) > radians(maxFollowingAngle)) continue;
      
      // Then check if the soldier is closer to the missile than current closest soldier
      // if not, skip to the next one
      float distance = dist(soldiers[j].x, soldiers[j].y, x, y);
      if(distance >= shortestDist) continue;
      
      // This soldier is now the closest soldier that meets our requirement!
      // Remember who the soldier is (by the index) and update the shortest distance
      currentTargetIndex = j;
      shortestDist = distance;
    }
  }
  
  void updateAngle(){
    if(currentTargetIndex == -1
    || soldiers[currentTargetIndex] == null
    || !soldiers[currentTargetIndex].isAlive){
      currentTargetIndex = -1;
      searchForTarget();
    }else{
      float angle = atan2(soldiers[currentTargetIndex].y - y, soldiers[currentTargetIndex].x - x);
      if(getRadiansDifference(targetAngle, angle) <= radians(maxFollowingAngle)){
        targetAngle = lerpTowardsRadians(targetAngle, angle, 0.05);
      }else{
        searchForTarget();
      }
    }
  }
  
  float lerpTowardsRadians(float from, float to, float amount){
    if(from * to >= 0 || abs(to - from) <= PI) return lerp(from, to, amount);
    if(from < 0){
      from += TWO_PI;
    }else{
      to += TWO_PI;
    }
    float result = lerp(from, to, amount);
    if(result > PI) result -= TWO_PI;
    return result;
  }
}
