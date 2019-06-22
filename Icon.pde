class Icon {
  
  float x, y;
  PImage content;
  int displayNum;
  
  Icon(float x, float y, PImage content, int displayNum){
    this.x = x;
    this.y = y;
    this.content = content;
    this.displayNum = displayNum;
  }
  
  void display(boolean isTransparent){
    pushStyle();
    pushMatrix();
    translate(x, y);
    imageMode(CENTER);
    tint(255, (isTransparent) ? 100 : 255);
    image(iconImg, 0, 0);
    image(content, 0, 0);
    fill(255, (isTransparent) ? 100 : 255);
    textAlign(RIGHT, BOTTOM);
    textSize(16);
    text(displayNum, 32, 32);
    popMatrix();
    popStyle();
  }
}
