class Rocket extends FireCannon {
  
  float maxFollowingAngle = 30;
  float speedIncreasePerSecond = 4;
  
  Trail trail;
  
  Rocket(float x, float y, float targetAngle){
    super(x, y, targetAngle);
    damage = 60;
    img = rocketImg;
    speed = 1;
    explosionTime = 0.8;
    explosionRadius = 100;
    trail = new Trail(x, y);
  }
  
  void update(){
    // First, do what FireCannon does in its update()
    // Then check if the rocket has exploded
    // - If not:
    //   - Update the trail with the rocket's current X/Y
    //   - Update the rocket's speed (use updateSpeed())
    //   - Update the rocket's angle to follow the mouse (use updateAngle())
    super.update();
    if(explosion == null){
      trail.update(x, y);
      updateSpeed();
      updateAngle();
    }
  }
  
  void display(){
    // Check if the rocket has exploded
    // - If not:
    //   - Display the trail
    // Then do what FireCannon does in its display()
    // (We display the trail first so that the trail won't be on top of the rocket)
    if(explosion == null) trail.display();
    super.display();
  }
  
  void updateSpeed(){
    speed += speedIncreasePerSecond / 60;
  }
  
  void updateAngle(){
    float newMouseAngle = atan2(mouseY - y, mouseX - x);
    if(getRadiansDifference(targetAngle, newMouseAngle) <= radians(maxFollowingAngle)){
      targetAngle = newMouseAngle;
    }
  }
}
