class Rambo extends Soldier {
  Rambo(float x, float y) {
    super(x, y);
    scoreValue = 5;
    health = 255;
    img = ramboImg;
    speed = 0.75;
  }
  
  void display(){
    pushStyle();
    tint(255, health, health);
    super.display();
    popStyle();
  }
}
