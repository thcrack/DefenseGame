class FireCannon extends Cannon {
  
  Explosion explosion;
  float explosionTime = 0.5;
  float explosionRadius = 64;
  
  FireCannon(float x, float y, float targetAngle){
    super(x, y, targetAngle);
    damage = 20;
    img = firecannonImg;
  }
  
  void update() {
    if(explosion != null){
      explosion.update();
      if(explosion.hasEnded()) isAlive = false;
    }else{
      super.update();
    }
  }
  
  void onHit(Soldier soldier){
    explosion = new Explosion(x, y, explosionTime, explosionRadius);
    for(int j = 0; j < soldiers.length; j++){
      if(isExplosionHit(soldiers[j])){
        soldiers[j].hurt(damage);
      }
    }
  }
  
  void display() {
    if(explosion != null){
      explosion.display();
    }else{
      super.display();
    }
  }
  
  boolean isExplosionHit(Soldier soldier){
    return soldier != null
        && soldier.isAlive
        && dist(x, y, soldier.x, soldier.y) <= explosionRadius + soldier.getRadius();
  }
}
