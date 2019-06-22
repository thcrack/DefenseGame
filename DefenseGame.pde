//
//  Created by rarakasm on 2019/5/13
//  Assets courtesy of kenney.nl
//  Font by Valentin Antonov under non-commericial use
//  Revised by Prof. Jones Yu.
//

final int GAME_RUN = 0;
final int GAME_OVER = 1;

final int CANNON_NORMAL = 0;
final int CANNON_FIRE = 1;
final int CANNON_BOUNCING = 2;
final int CANNON_ROCKET = 3;
final int CANNON_MISSILE = 4;

int gameState = GAME_RUN;

PImage bg, towerBase;
PImage iconImg;
PImage towerImg;
PImage soldierImg, ramboImg;
PImage cannonImg, firecannonImg, rocketImg, missileImg, bouncingcannonImg;
PImage explosionImg;

PFont font;

int score = 0;

Tower tower;
Soldier soldiers[];
int maxSoldierCount = 16;
float ramboSpawnChance = 0.1;
int spawnInterval = 15;
int spawnTimer = 0;

Icon[] icons = new Icon[5];
float scoreTextMinSize = 72;
float scoreTextMaxSize = 96;
float scoreTextSize = scoreTextMinSize;

Trail mouseTrail;

void setup(){
  size(512, 512, P2D);
  bg = loadImage("img/bg.png");
  iconImg = loadImage("img/icon.png");
  towerBase = loadImage("img/tower_base.png");
  towerImg = loadImage("img/tower_lv1.png");
  soldierImg = loadImage("img/soldier.png");
  ramboImg = loadImage("img/rambo.png");
  cannonImg = loadImage("img/cannon.png");
  firecannonImg = loadImage("img/firecannon.png");
  rocketImg = loadImage("img/rocket.png");
  missileImg = loadImage("img/missile.png");
  bouncingcannonImg = loadImage("img/bouncingcannon.png");
  explosionImg = loadImage("img/explosion.png");
  
  font = createFont("ObelixPro.ttf", 64, true);
  textFont(font);
  
  createIcons();
  
  initGame();
}

void createIcons(){
  icons[0] = new Icon(40, height - 40, cannonImg, 1);
  icons[1] = new Icon(100, height - 40, firecannonImg, 2);
  icons[2] = new Icon(160, height - 40, bouncingcannonImg, 3);
  icons[3] = new Icon(220, height - 40, rocketImg, 4);
  icons[4] = new Icon(280, height - 40, missileImg, 5);
}

void initGame(){
  soldiers = new Soldier[maxSoldierCount];
  tower = new Tower();
  mouseTrail = new Trail(mouseX, mouseY);
  noCursor();
  score = 0;
  gameState = GAME_RUN;
}

void spawnSoldier(){
  for(int i = 0; i < soldiers.length; i++){
    if(soldiers[i] == null || !soldiers[i].isAlive){
      float angle = random(TWO_PI);
      float distance = random(400, 600);
      float x = width / 2 + cos(angle) * distance;
      float y = height / 2 + sin(angle) * distance;
      soldiers[i] = (random(1) > ramboSpawnChance) ? new Soldier(x, y) : new Rambo(x, y);
      break;
    }
  }
}

void draw(){
  
  switch(gameState){
    case GAME_RUN:
  
    // draw background
    for(int i = - bg.width; i < width + bg.width; i += bg.width){
      for(int j = - bg.height; j < height + bg.height; j += bg.height){
        image(bg, i, j);
      }
    }
    
    drawScore();
    
    spawnTimer++;
    if(spawnTimer >= spawnInterval){
      spawnTimer = 0;
      spawnSoldier();
    }
    
    for(int i = 0; i < soldiers.length; i++){
      if(soldiers[i] != null && soldiers[i].isAlive){
        soldiers[i].update();
        soldiers[i].display();
        if(tower.isHit(soldiers[i])){
          gameState = GAME_OVER;
        }
      }
    }
    
    tower.update();
    tower.display();
    
    drawIcons();
    drawMouseCursor();
    
    if(gameState == GAME_OVER){
      cursor(0);
      drawGameOverText();
    }
    break;
    
    case GAME_OVER:
    break;
  }
}

void drawMouseCursor(){
  // Trail
  mouseTrail.update(mouseX, mouseY);
  mouseTrail.display();
  
  // Cursor circle
  pushStyle();
  ellipseMode(CENTER);
  noFill();
  stroke(#FFF646);
  strokeWeight(2);
  ellipse(mouseX, mouseY, 16, 16);
  popStyle();
}

void drawScore(){
  scoreTextSize = lerp(scoreTextSize, scoreTextMinSize, 0.12);
  textAlign(CENTER, CENTER);
  textSize(scoreTextSize);
  fill(#ffffff, 100);
  text(score, width / 2, height / 2 + 100);
}

void drawGameOverText(){
  textAlign(CENTER, CENTER);
  textSize(64);
  fill(0, 120);
  text("GAME OVER", width / 2 + 3, height / 2 - 120 + 3);
  fill(#ff0000);
  text("GAME OVER", width / 2, height / 2 - 120);
  
  textSize(32);
  fill(0, 120);
  text("SCORE: " + score, width / 2 + 3, height / 2 + 3);
  text("click to restart", width / 2 + 3, height / 2 + 200 + 3);
  fill(#ffffff);
  text("SCORE: " + score, width / 2, height / 2);
  text("click to restart", width / 2, height / 2 + 200);
}

void drawIcons(){
  for(int i = 0; i < icons.length; i++){
    icons[i].display(i != tower.currentCannonType);
  }
}

void addScore(int value){
  score += value;
  scoreTextSize = scoreTextMaxSize;
}

float getRadiansDifference(float a, float b){
  float result = b - a;
  if(result > PI) result -= TWO_PI;
  else if(result < - PI) result += TWO_PI;
  return abs(result);
}

void keyReleased(){
  switch(gameState){
    case GAME_RUN:
    switch(key){
      case ' ': tower.fire(); break;
    }
    break;
  }
}

void keyPressed(){
  switch(gameState){
    case GAME_RUN:
    switch(key){
      case '1':
      tower.setCannonType(0);
      break;
      case '2':
      tower.setCannonType(1);
      break;
      case '3':
      tower.setCannonType(2);
      break;
      case '4':
      tower.setCannonType(3);
      break;
      case '5':
      tower.setCannonType(4);
      break;
    }
    break;
  }
}

void mouseReleased(){
  switch(gameState){
    case GAME_RUN:
    tower.fire();
    break;
    
    case GAME_OVER:
    initGame();
    break;
  }
}
