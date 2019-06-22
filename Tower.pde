class Tower {
  int maxCannonCount = 16;
  float hitRadius = 26;
  int currentCannonType = CANNON_NORMAL;
  
  float towerTopXOffset = 0;
  float towerTopXMaxOffset = 16;
  
  Cannon[] cannons;
  
  Tower(){
    cannons = new Cannon[maxCannonCount];
  }
  
  void fire(){
    for(int i = 0; i < cannons.length; i++){
      if(cannons[i] == null || !cannons[i].isAlive){
        switch(currentCannonType){
          case CANNON_NORMAL:    cannons[i] = new Cannon(width / 2, height / 2, atan2(mouseY - height / 2, mouseX - width / 2)); break;
          case CANNON_FIRE:      cannons[i] = new FireCannon(width / 2, height / 2, atan2(mouseY - height / 2, mouseX - width / 2)); break;
          case CANNON_BOUNCING:  cannons[i] = new BouncingCannon(width / 2, height / 2, atan2(mouseY - height / 2, mouseX - width / 2)); break;
          case CANNON_ROCKET:    cannons[i] = new Rocket(width / 2, height / 2, atan2(mouseY - height / 2, mouseX - width / 2)); break;
          case CANNON_MISSILE:   cannons[i] = new Missile(width / 2, height / 2, atan2(mouseY - height / 2, mouseX - width / 2)); break;
        }
        towerTopXOffset = towerTopXMaxOffset;
        break;
      }
    }
  }
  
  void setCannonType(int type){
    currentCannonType = type;
  }
  
  void update(){
    for(int i = 0; i < cannons.length; i++){
      if(cannons[i] != null && cannons[i].isAlive){
        cannons[i].update();
      }
    }
  }
  
  void display(){
    pushStyle();
    imageMode(CENTER);
    image(towerBase, width / 2, height / 2);
    
    for(int i = 0; i < cannons.length; i++){
      if(cannons[i] != null && cannons[i].isAlive){
        cannons[i].display();
      }
    }
    
    pushMatrix();
    translate(width / 2, height / 2);
    rotate(atan2(mouseY - height / 2, mouseX - width / 2));
    towerTopXOffset = lerp(towerTopXOffset, 0, 0.2);
    image(towerImg, -towerTopXOffset, 0);
    popMatrix();
    popStyle();
  }
  
  boolean isHit(Soldier soldier){
    return soldier != null && soldier.isAlive && dist(width / 2, height / 2, soldier.x, soldier.y) <= hitRadius + soldier.getRadius();
  }
}
