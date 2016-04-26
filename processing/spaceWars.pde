/**
Megan Quach
Bingyu Li
Anthony DiTocco

--------First Stage-------------
User Interface Class is complete
  main menu
  instruction
  game over
**/
/* @pjs preload="processing/bomb.png, 
processing/title_bg.jpg, 
processing/instruction.jpg,
processing/back.png,
processing/back_h.png,
processing/over.jpg,
processing/play.png,
processing/play_h.png,
processing/play2.png,
processing/play2_h.png,
processing/htp.png,
processing/htp_h.png,
processing/exit.png,
processing/exit_h.png,
processing/Sprites/spaceship005.png,
processing/background.png,
processing/live.png,
processing/Sprites/explosion1.png,
processing/Sprites/explosion2.png,
processing/Sprites/explosion3.png,
processing/Sprites/explosion4.png,
processing/sprites/asteroid1.png,
processing/sprites/asteroid2.png,
processing/sprites/asteroid3.png,
processing/sprites/RD1.png,
processing/sprites/RD3.png,
processing/sprites/UFO.png,
processing/menu_bgm.mp3,
processing/space-battle_jamie-nord.mp3,
processing/sounds/blaster2.wav,
processing/sounds/boss1Death.wav,
processing/sounds/Blast.mp3,
processing/sounds/superLaser.wav"; */

import ddf.minim.*;

AudioPlayer menu_bgm;
AudioPlayer game_bgm;
AudioPlayer shootSound;
AudioPlayer bombSound;
AudioPlayer gameOver;
AudioPlayer grenade;
Minim minim;//audio context

int gameState = 0;
int score = 0;
PImage first;
PImage second;
PImage third;
PImage fourth;
PImage menu;
PImage instruction;
PImage back;
PImage back_h;
PImage play;
PImage play_h;
PImage play2;
PImage play2_h;
PImage htp;
PImage htp_h;
PImage exit;
PImage exit_h;
PImage over;
PImage ship;
PImage background;
PImage background2;
PImage lives;
PImage bombImg;
float transparency = 255;
float opacity = 0;
Shooter shooter;
ArrayList<Enemy> basicEnemies = new ArrayList<Enemy>();
ArrayList<Enemy> mediumEnemies = new ArrayList<Enemy>();
ArrayList<Enemy> hardEnemies = new ArrayList<Enemy>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
boolean shooterUp=false;
boolean shooterDown=false;
boolean shooterLeft=false;
boolean shooterRight=false;
boolean mouseHeld=false;
boolean bomb=false;
float startMusic = 0.0;
float angle = 0.0;
int bombCount=0;
UI ui;
void setup(){
  smooth();
  background(255);
  size(800,800);
  minim = new Minim(this);
  menu_bgm = minim.loadFile("processing/menu_bgm.mp3", 2048);
  game_bgm = minim.loadFile("processing/space-battle_jamie-nord.mp3", 2048);
  shootSound = minim.loadFile("processing/sounds/blaster2.wav",2048);
  bombSound = minim.loadFile("processing/sounds/boss1Death.wav",2048);
  gameOver = minim.loadFile("processing/sounds/Blast.mp3",2048);
  grenade = minim.loadFile("processing/sounds/superLaser.wav",2048);
  //load imgs
  bombImg = loadImage("processing/bomb.png");
  menu = loadImage("processing/title_bg.jpg");
  instruction = loadImage("processing/instruction.jpg");
  back = loadImage("processing/back.png");
  back_h = loadImage("processing/back_h.png");
  over = loadImage("processing/over.jpg");
  play = loadImage("processing/play.png");
  play_h = loadImage("processing/play_h.png");
  play2 = loadImage("processing/play2.png");
  play2_h = loadImage("processing/play2_h.png");
  htp = loadImage("processing/htp.png");
  htp_h = loadImage("processing/htp_h.png");
  exit = loadImage("processing/exit.png");
  exit_h = loadImage("processing/exit_h.png");
  ship = loadImage("processing/Sprites/spaceship005.png");
  background = loadImage("processing/background.png");
  lives = loadImage("processing/live.png");
  first = loadImage("processing/Sprites/explosion1.png");
  second = loadImage("processing/Sprites/explosion2.png");
  third = loadImage("processing/Sprites/explosion3.png");
  fourth = loadImage("processing/Sprites/explosion4.png");
  //constructor
  ui = new UI();
  shooter = new Shooter();
  fill(0);
  image(ship,(int)shooter.positionX,(int)shooter.positionY,35,35);
  basicEnemies.add(new Enemy(shooter.positionX,shooter.positionY,1));
  basicEnemies.get(0).enemyImg=loadImage("processing/sprites/asteroid1.png");
  image(basicEnemies.get(0).enemyImg,(int)basicEnemies.get(0).positionX,(int)basicEnemies.get(0).positionY,18,18);

}
void draw(){
  frameRate(500);
  background(255);
  //menu
  if(!ui.playGame){
    ui.display();
    score = 0;
    shooter.lives = 5;
    shooter.gunUpgrade=5;
    shooter.isDead=false;
    score=0;
    shooter.enemiesKilled=0;
    shooter.positionX=width/2;
    shooter.positionY=height/2;
    shooter.bombCount=3;
    gameOver.rewind();
    gameOver.pause();
  }
  //game Start
  else{
    if(ui.start){
      startMusic= millis();
      ui.start=false;
    }
    //loop music
    if(millis()-startMusic>game_bgm.length()){
      game_bgm.pause();
      game_bgm.rewind();
      startMusic=millis();
    }
    score = shooter.enemiesKilled * 10;
    menu_bgm.pause();
    game_bgm.play();
    image(background,width/2,height/2,800,800);
    fill(255);
    textSize(30);
    text("Score: "+score, 20, 50);
    //add bombs 
    if(score%2000==0){
        if(shooter.bombCount<3){
          if(frameCount%20==0){
            shooter.bombCount+=1;
          }
        }
      }
    displayLives();
    //explosion animation
    if(!explosions.isEmpty()){
      for(int i=0;i<explosions.size();i++){
        if(frameCount%2==0){
          explosions.get(i).frame++;
        }
        if(explosions.get(i).frame<4){
          image(first,(int)explosions.get(i).positionX,(int)explosions.get(i).positionY,explosions.get(i).size,explosions.get(i).size); 
        }
        else if(explosions.get(i).frame<8){
          image(second,(int)explosions.get(i).positionX,(int)explosions.get(i).positionY,explosions.get(i).size,explosions.get(i).size); 
        }
        else if(explosions.get(i).frame<12){
          image(third,(int)explosions.get(i).positionX,(int)explosions.get(i).positionY,explosions.get(i).size,explosions.get(i).size); 
        }
        else if(explosions.get(i).frame<16){
          image(fourth,(int)explosions.get(i).positionX,(int)explosions.get(i).positionY,explosions.get(i).size,explosions.get(i).size);         
        }
        if(explosions.get(i).frame==17){
          explosions.remove(i);
        }
      }
    }
    //hard and normal settings for releasing enemies
    int c;
    if(shooter.gunUpgrade<1){
      if(ui.hard){
        c=40;
      }
      else{
        c=60;
      }
    }
    else if(shooter.gunUpgrade<5){
      if(ui.hard){
        c=25;
      }
      else{
        c=40;
      }
    }
    else if(shooter.gunUpgrade<6){
      if(ui.hard){
        c=15;
      }
      else{
        c=25;
      }
    }
    else{
      if(ui.hard){
        c=10;
      }
      else{
        c=20;
      }
    }
    if(frameCount%c==0){
        //
        Enemy x = new Enemy(shooter.positionX,shooter.positionY,1);// basicEnemies.add(new Enemy(shooter.positionX,shooter.positionY));
       float n = random(1);
       if(n<.33){
          x.enemyImg = loadImage("processing/sprites/asteroid1.png");
       }
       else if(n<.66){
          x.enemyImg = loadImage("processing/sprites/asteroid2.png");
       }
       else{
          x.enemyImg = loadImage("processing/sprites/asteroid3.png");
       }
        basicEnemies.add(x);
    }
    if(shooter.gunUpgrade>=2){
      int m;
      if(shooter.gunUpgrade<4){
        if(ui.hard){
          m=70;
        }
        else{
          m=100;
        }
      }
      else if(shooter.gunUpgrade<5){
        if(ui.hard){
          m=50;
        }
        else{
          m=70;
        }
      }
      else if(shooter.gunUpgrade<6){
        if(ui.hard){
          m=25;
        }
        else{
          m=45;
        }
      }
      else{
        if(ui.hard){
          m=20;
        }
        else{
          m=35;
        }
      }
      if(frameCount%m==0){
        Enemy x = new Enemy(shooter.positionX,shooter.positionY,2);
        float n = random(1);
        if(n<.5){
          x.enemyImg=loadImage("processing/sprites/RD1.png");
        }
        else{
          x.enemyImg=loadImage("processing/sprites/RD3.png");
        }
        mediumEnemies.add(x);
      }
    }
    if(shooter.gunUpgrade>=4){
      int m;
      if(shooter.gunUpgrade<5){
        if(ui.hard){
          m=100;
        }
        else{
          m=150;
        }
      }
      else if(shooter.gunUpgrade<6){
        if(ui.hard){
          m=50;
        }
        else{
          m=100;
        }
      }
      else{
        if(ui.hard){
          m=30;
        }
        else{
          m=70;
        }
      }
      if(frameCount%m==0){
        Enemy x = new Enemy(shooter.positionX,shooter.positionY,3);
        x.enemyImg=loadImage("processing/sprites/UFO.png");
        hardEnemies.add(x);
      }
    }
    //move the shooter
    if(!shooter.isDead){
      if(shooterUp){
          if(shooter.positionY<0){
            shooter.positionY=height-1;
          }
          else{
            shooter.positionY-=1.3;
          }
      }
      if(shooterDown){
        if(shooter.positionY>height-1){
          shooter.positionY=0;
        }
        else{
          shooter.positionY+=1.3;
        }
      }
      if(shooterLeft){
          if(shooter.positionX<-10){
            shooter.positionX=width-1;
          } 
          else{
            shooter.positionX-=1.3;
          }
      }
      if(shooterRight){
          if(shooter.positionX>width){
            shooter.positionX=0;
          }
          else{
            shooter.positionX+=1.3;
          }
      }
      shooterMove();
      //shoot projectiles
      if(mouseHeld){
         shooter.shoot();
         if(frameCount%12==0){
           shootSound.play();
           shootSound.rewind();
         }
      }
      else{
        //image(ship,(int)shooter.positionX,(int)shooter.positionY,35,35);
      }
      //bomb count for 5 bombs
      if(bomb){
        if(bombCount<5){
          if(bombCount==0){
            bombSound.play();
            bombSound.rewind();
          }
          if(frameCount%20==0){
            shooter.bomb(120,shooter.positionX,shooter.positionY);
            bombCount++;
          }
        }
        else{
          bombCount=0;
          bomb=false;
        }
      }
      //process hard enemies 
      for(int i=0;i<hardEnemies.size();i++){
        if(!hardEnemies.get(i).isDead){
          hardEnemies.get(i).chasePlayer(shooter.positionX,shooter.positionY);
          if(hardEnemies.get(i).hitPlayer(shooter.positionX,shooter.positionY)){
            shooter.lives--;
            if(shooter.lives==0){
              shooter.isDead=true;
            }
          }
          //ellipse((int)basicEnemies.get(i).positionX,(int)basicEnemies.get(i).positionY,5,5);
          image(hardEnemies.get(i).enemyImg,(int)hardEnemies.get(i).positionX,(int)hardEnemies.get(i).positionY,hardEnemies.get(i).imageSize,hardEnemies.get(i).imageSize);
        }
      }
      //process medium enemies
      for(int i=0;i<mediumEnemies.size();i++){
        if(!mediumEnemies.get(i).isDead){
          mediumEnemies.get(i).chasePlayer(shooter.positionX,shooter.positionY);
          if(mediumEnemies.get(i).hitPlayer(shooter.positionX,shooter.positionY)){
            shooter.lives--;
            if(shooter.lives==0){
              shooter.isDead=true;
            }
          }
          //ellipse((int)basicEnemies.get(i).positionX,(int)basicEnemies.get(i).positionY,5,5);
          image(mediumEnemies.get(i).enemyImg,(int)mediumEnemies.get(i).positionX,(int)mediumEnemies.get(i).positionY,mediumEnemies.get(i).imageSize,mediumEnemies.get(i).imageSize);

        }
      }
      //process basic enemies
      for(int i = 0;i<basicEnemies.size();i++){
        if(!basicEnemies.get(i).isDead){
          basicEnemies.get(i).chasePlayer(shooter.positionX,shooter.positionY);
          if(basicEnemies.get(i).hitPlayer(shooter.positionX,shooter.positionY)){
            shooter.lives--;
            if(shooter.lives==0){
              shooter.isDead=true;
            }
          }
          //ellipse((int)basicEnemies.get(i).positionX,(int)basicEnemies.get(i).positionY,5,5);
          image(basicEnemies.get(i).enemyImg,(int)basicEnemies.get(i).positionX,(int)basicEnemies.get(i).positionY,basicEnemies.get(i).imageSize,basicEnemies.get(i).imageSize);

        }
      }
      //projectiles
      if(!shooter.projectiles.isEmpty()){
        for(int i=0;i<shooter.projectiles.size();i++){
          shooter.projectiles.get(i).shot();
          //projectile hit basic
          for(int j=0;j<basicEnemies.size();j++){
            if(!basicEnemies.get(j).isDead&&shooter.projectiles.get(i).positionX<basicEnemies.get(j).positionX+15&&shooter.projectiles.get(i).positionX>basicEnemies.get(j).positionX-15 &&shooter.projectiles.get(i).positionY<basicEnemies.get(j).positionY+15 &&shooter.projectiles.get(i).positionY>basicEnemies.get(j).positionY-15){
              if(shooter.projectiles.get(i).isGrenade){
                fill(255,0,0);
                grenade.play();
                grenade.rewind();
                shooter.grenade(basicEnemies.get(j).positionX,basicEnemies.get(j).positionY);
              }
              fill(0);
              shooter.projectiles.get(i).endLifeTime=true;
              basicEnemies.get(j).isDead=true;
              Explosion e = new Explosion(basicEnemies.get(j).positionX, basicEnemies.get(j).positionY,18);
              explosions.add(e);
              basicEnemies.remove(j);
              shooter.enemiesKilled++;
            }
          }
          //projectile hit medium
          for(int j=0;j<mediumEnemies.size();j++){
            if(!mediumEnemies.get(j).isDead&&shooter.projectiles.get(i).positionX<mediumEnemies.get(j).positionX+20&&shooter.projectiles.get(i).positionX>mediumEnemies.get(j).positionX-20 &&shooter.projectiles.get(i).positionY<mediumEnemies.get(j).positionY+20 &&shooter.projectiles.get(i).positionY>mediumEnemies.get(j).positionY-20){
              if(mediumEnemies.get(j).shotCount>=20){
                if(shooter.projectiles.get(i).isGrenade){
                  fill(255,0,0);
                  grenade.play();
                  grenade.rewind();
                  shooter.grenade(mediumEnemies.get(j).positionX,mediumEnemies.get(j).positionY);
                }
                fill(0);
                shooter.projectiles.get(i).endLifeTime=true;
                mediumEnemies.get(j).isDead=true;
                Explosion e = new Explosion(mediumEnemies.get(j).positionX, mediumEnemies.get(j).positionY,35);
                explosions.add(e);
                mediumEnemies.remove(j);
                shooter.enemiesKilled+=2;
              }
              else{
                if(shooter.projectiles.get(i).isGrenade){
                  fill(255,0,0);
                  shooter.grenade(mediumEnemies.get(j).positionX,mediumEnemies.get(j).positionY);
                }
                mediumEnemies.get(j).shotCount++;
                shooter.projectiles.get(i).endLifeTime=true;
              }
            }
          }
          //projectile hit hard
          for(int j=0;j<hardEnemies.size();j++){
            if(!hardEnemies.get(j).isDead&&shooter.projectiles.get(i).positionX<hardEnemies.get(j).positionX+20&&shooter.projectiles.get(i).positionX>hardEnemies.get(j).positionX-20 &&shooter.projectiles.get(i).positionY<hardEnemies.get(j).positionY+20 &&shooter.projectiles.get(i).positionY>hardEnemies.get(j).positionY-20){
              if(hardEnemies.get(j).shotCount>=60){
                if(shooter.projectiles.get(i).isGrenade){
                  fill(255,0,0);
                  shooter.grenade(hardEnemies.get(j).positionX,hardEnemies.get(j).positionY);
                  grenade.play();
                  grenade.rewind();
                }
                fill(0);
                shooter.projectiles.get(i).endLifeTime=true;
                hardEnemies.get(j).isDead=true;
                Explosion e = new Explosion(hardEnemies.get(j).positionX, hardEnemies.get(j).positionY,50);
                explosions.add(e);
                hardEnemies.remove(j);
                shooter.enemiesKilled+=3;
              }
              else{
                if(shooter.projectiles.get(i).isGrenade){
                  fill(255,0,0);
                  shooter.grenade(hardEnemies.get(j).positionX,hardEnemies.get(j).positionY);
                }
                hardEnemies.get(j).shotCount++;
                shooter.projectiles.get(i).endLifeTime=true;
              }
            }
          }
          //remove projectile
          if(shooter.projectiles.get(i).endLifeTime){
            shooter.projectiles.remove(i);
          }
          else{
            fill(127,255,0);
            if(shooter.gunUpgrade<4){
              rect(shooter.projectiles.get(i).positionX,shooter.projectiles.get(i).positionY,5,5);
            }
            else{
              rect(shooter.projectiles.get(i).positionX,shooter.projectiles.get(i).positionY,5,10);
            }
            fill(255,0,0);
          }
        }
      }
    }
    else{
      //game over restart
      //shooter.isDead=false;
      for(int i=0;i<basicEnemies.size();i++){
        basicEnemies.remove(i);
      }
      for(int i=0;i<mediumEnemies.size();i++){
        mediumEnemies.remove(i);
      }
      for(int i=0;i<hardEnemies.size();i++){
        hardEnemies.remove(i);
      }
      for(int i=0;i<shooter.projectiles.size();i++){
        shooter.projectiles.remove(i);
      }
      for(int i=0;i<explosions.size();i++){
        explosions.remove(i);
      }
      game_bgm.pause();
      game_bgm.rewind();
      gameOver.play();
      ui.over();
      fill(0);
      text("You scored: " + score,width/2-100,height/2+100);
    }
  }
}
 void keyPressed() {
    if (keyPressed) {
      if (key == 'w') {
        shooterUp=true;
      } if (key == 's') {
        shooterDown=true;
      } if(key == 'a'){
        shooterLeft=true;
      } if(key =='d'){
        shooterRight=true;
      }
      if(key=='b'){
        if(shooter.bombCount>0){
          bomb=true;
          shooter.bombCount--;
        }
      }
    } 
  }
  void keyReleased(){
    if(key=='w'){
      shooterUp=false;
    }
    if(key=='a'){
      shooterLeft=false;
    }
        if(key=='s'){
      shooterDown=false;
    }
        if(key=='d'){
      shooterRight=false;
    }
  }
  void mousePressed(){
    mouseHeld=true;
  }
  void mouseReleased(){
    mouseHeld=false;
  }
  //to move and rotate the spaceship
  void shooterMove(){
    pushMatrix();
    translate(shooter.positionX, shooter.positionY);
    rotate(angle + radians(90));
    image(ship,0,0,35,35);
    popMatrix();
  }
  void mouseDragged(){
    angle = atan2(mouseY-shooter.positionY, mouseX - shooter.positionX);
  }
  void mouseMoved(){
    angle = atan2(mouseY-shooter.positionY, mouseX - shooter.positionX);
  }
  void displayLives(){
   for (int i = 0; i<shooter.lives; i++){
     image(lives,width/2+150+i*50,50);
   }
   for (int i = 0; i<shooter.bombCount; i++){
     image(bombImg,width/2-50+i*50,50);
   }
  }
 
  void bgFade(){
    if (transparency > 0) { transparency -= 1; }
    tint(255, transparency);
    image(background, width/2, height/2);
    if (opacity <255) { opacity += 1; }
    tint(255, opacity);
    image(background2, width/2, height/2);
  }
class Enemy{
    float positionX;
    float positionY;
    boolean isDead;
    int typeOfEnemy;
    PImage enemyImg;
    float imageSize;
    float speed;
    float shotCount;
    Explosion explosion;
    //make enemies come from sides and top
  Enemy(float playerX, float playerY,int enemyNum){
    typeOfEnemy=enemyNum;
    shotCount=0;
    if(enemyNum==1){
       imageSize= random(10,20);
    }
    else if(enemyNum==2){
       imageSize= random(30,40);
    }
    else if(enemyNum==3){
      imageSize= random(70,80);
    }
    isDead=false;
    positionX = random(0,width);
    positionY = random(0,height);
    //spawning
    if(((positionX<=playerX+200)&& (positionX>=playerX-200)) && ((positionY>=playerY-200)&&(positionY<=playerY+200))){
      float y = random(1);
      if(y<.5){
        positionX+=random(200,240);
      }
      else{
        positionX-=random(200,240);
      }
      //positionY+=random(500,510);
    }
  }
  //if the projectile hits the player its dead
  boolean hitPlayer(float playerX, float playerY){
    if(typeOfEnemy==1){
      if(positionX>=playerX-1 && positionX<=playerX+10 && positionY>=playerY-1 && positionY<=playerY+10){
        isDead=true;
        return true;
      }
    }
    else if(typeOfEnemy==2){
      if(positionX>=playerX-1 && positionX<=playerX+20 && positionY>=playerY-1 && positionY<=playerY+20){
        isDead=true;
        return true;
      }
    }
    else if(typeOfEnemy==3){
      if(positionX>=playerX-1 && positionX<=playerX+40 && positionY>=playerY-1 && positionY<=playerY+40){
        isDead=true;
        return true;
      }
    }
    else{
      return false;
    }
    return false;
  }
  //interpolate between enemies point and players point
  void chasePlayer(float playerX,float playerY){
    float distanceX=playerX-positionX;
    if(distanceX<0){distanceX*=-1;}
    float distanceY=playerY-positionY;
    if(distanceY<0){distanceY*=-1;}
    float step;
    if(distanceX>distanceY){
      step=distanceX;
    }
    else{
      step=distanceY;
    }
    if(distanceY<0){distanceY*=-1;}
    float alphaX = (playerX-positionX)/step;
    float alphaY = (playerY-positionY)/step;
    //alphaX*=2;
    //alphaY*=2;
    positionX+=alphaX;
    positionY+=alphaY;
    if(playerX==positionX && playerY==positionY){
      positionX-=.01;
      positionY-=.01;   
      isDead=true;
    }
  }
}
class Explosion{
  int size;
  float positionX;
  float positionY;
  int frame;
  Explosion(float posX, float posY,int s){
    frame=0;
    size=s;
    //print(size);
    positionX=posX;
    positionY=posY;
  } 
}
class Projectile{
  float positionX;
  float positionY;
  float endX;
  float endY;
  boolean isGrenade;
  boolean endLifeTime;
  Projectile(float playerX, float playerY){
    endLifeTime=false;
    isGrenade=false;
    positionX = playerX;
    positionY = playerY;
  }
  //get initial direction and extend vector off screen
  void initialDirection(float mousePosX, float mousePosY){
    float distance = sqrt((mousePosX-positionX)*(mousePosX-positionX)+(mousePosY-positionY)*(mousePosY-positionY));
    endX = mousePosX+((mousePosX-positionX)/distance) *1500;
    endY = mousePosY+((mousePosY-positionY)/distance) *1500;
  }
  //move projectile
  void shot(){
    float distanceX=endX-positionX;
    if(distanceX<0){distanceX*=-1;}
    float distanceY=endY-positionY;
    if(distanceY<0){distanceY*=-1;}
    float step;
    if(distanceX>distanceY){
      step=distanceX;
    }
    else{
      step=distanceY;
    }
    float alphaX = (endX-positionX)/step;
    float alphaY = (endY-positionY)/step;
    positionX+=alphaX;
    positionY+=alphaY;
    if(endX==positionX || endY==positionY){
      positionX-=.01;
      positionY-=.01;
    }
    if(positionX>width+5||positionX<-5){
      endLifeTime=true;
    }
    if(positionY>height+5||positionY<-5){
      endLifeTime=true;
    }
  }
}
class Shooter{
  int lives;
  boolean isDead;
  String typeOfEnemy;
  int gunUpgrade;
  int enemiesKilled;
  float positionX;
  float positionY;
  PImage ShooterImage; 
  ArrayList<Projectile> projectiles;
  int bombCount;
  Shooter(){
    bombCount=3;
    enemiesKilled=0;
    projectiles = new ArrayList<Projectile>();
    positionX = width/2;
    positionY = height/2;
    isDead=false;
    gunUpgrade=0;
    lives = 5;
  }
  void shoot(){
    //gun upgrade
    if(enemiesKilled<40){
      gunUpgrade=0;
    }
    else if(enemiesKilled<150){
      gunUpgrade=1;
    }
    else if(enemiesKilled<250){
      gunUpgrade=2;
    }
    else if(enemiesKilled<400){
      gunUpgrade=3;
    }
    else if(enemiesKilled<550){
      gunUpgrade=4;
    }
    else if(enemiesKilled<700){
      gunUpgrade=5;
    }
    else if(enemiesKilled>1000){
      gunUpgrade=6;
    }
    //different projectile speeds and amounts
    if(gunUpgrade==0){
      if(frameCount%10==0){
        Projectile shot = new Projectile(positionX,positionY);
        shot.initialDirection(mouseX, mouseY);
        //shot.isGrenade=true;
        projectiles.add(shot);
      }
    }
    else if(gunUpgrade==1){
      if(frameCount%8==0){
        Projectile shot = new Projectile(positionX,positionY);
        shot.initialDirection(mouseX, mouseY);
        projectiles.add(shot);
      }
    }
    else if(gunUpgrade==2){
      if(frameCount%10==0){
        Projectile shot = new Projectile(positionX,positionY);
        shot.initialDirection(mouseX, mouseY);
        projectiles.add(shot);
        Projectile shot2 = new Projectile(positionX,positionY);
        shot2.initialDirection(mouseX+20, mouseY-10);
        projectiles.add(shot2);
        Projectile shot3 = new Projectile(positionX,positionY);
        shot3.initialDirection(mouseX-20, mouseY-10);
        projectiles.add(shot3);
      }
    }
    else if(gunUpgrade==3 || gunUpgrade==4){
      if(frameCount%8==0){
        Projectile shot = new Projectile(positionX,positionY);
        shot.initialDirection(mouseX, mouseY);
        shooter.projectiles.add(shot);
        Projectile shot2 = new Projectile(positionX,positionY);
        shot2.initialDirection(mouseX+15, mouseY-10);
        shooter.projectiles.add(shot2);
        Projectile shot3 = new Projectile(positionX,positionY);
        shot3.initialDirection(mouseX-15, mouseY-10);
        shooter.projectiles.add(shot3);
        Projectile shot4 = new Projectile(positionX,positionY);
        shot4.initialDirection(mouseX+30, mouseY-20);
        shooter.projectiles.add(shot4);
        Projectile shot5 = new Projectile(positionX,positionY);
        shot5.initialDirection(mouseX-30, mouseY-20);
        shooter.projectiles.add(shot5);
      }
    }
    else if(gunUpgrade==5 || gunUpgrade==6){
      if(frameCount%8==0){
        Projectile shot = new Projectile(positionX,positionY);
        shot.initialDirection(mouseX, mouseY);
        shot.isGrenade=true;
        shooter.projectiles.add(shot);
      }
    }
  }
  //hit enemy and explode
  void grenade(float enemyX, float enemyY){
    float xPos=enemyX;
    float yPos=enemyY;
    float angle=0.0;
    float tmp=13;
    /*for(int i=0;i<30;i++){
      Projectile shot = new Projectile(enemyX,enemyY);
      xPos+=xPos*cos(angle)*10;
      yPos+=yPos*sin(angle)*10;
      shot.initialDirection(xPos,yPos);
      angle+=tmp;
      print(xPos +  " ");
      shooter.projectiles.add(shot);
    }
    */
    bomb(40,enemyX,enemyY);
  }
  //bomb function, shoot projectiles in a circle from a point
  void bomb(int size,float positionX,float positionY){
      int first=0;
      int second=0;
      int third=width;
      int fourth=height;
      float b = 360/size;
      float a = 0;
      float angle;
      float xTmp=positionX;
      float yTmp=positionY;
      for(int i=0;i<size;i++){
        angle=radians(a);
        Projectile shot = new Projectile(positionX,positionY);
        xTmp= positionX + cos(angle);
        yTmp= positionY + sin(angle);
        shot.initialDirection(xTmp, yTmp);
        //shot.isGrenade=true;
        shooter.projectiles.add(shot);
        a+=b;
      }
      /*
      for(int i=0;i<size;i++){
        if(i<size*.3){
          Projectile shot = new Projectile(positionX,positionY);
          shot.initialDirection(first, 0);
          first+=width/(size/3);
          shooter.projectiles.add(shot);
        }
        else if(i<size*.5){
          Projectile shot = new Projectile(positionX,positionY);
          shot.initialDirection(width, second);
          second+=height/(size/6);
          shooter.projectiles.add(shot);
        }
        else if(i<size*.8){
          Projectile shot = new Projectile(positionX,positionY);
          shot.initialDirection(third, height);
          third-=width/(size/3);
          shooter.projectiles.add(shot);
        }
        else{
          Projectile shot = new Projectile(positionX,positionY);
          shot.initialDirection(0, fourth);
          fourth-=height/(size/6);
          shooter.projectiles.add(shot);
        }
      }
      */
  }
}
//UI ui;
PFont font;
color c_s1, c_s2,c_s3;


class UI{
  boolean playGame=false;
  boolean start=false;
  boolean hard=false;
  void display(){
  imageMode(CENTER);

  //background(245);
  if(gameState == 0){
    menu();
    menu_bgm.play();
  }
  
  if(gameState ==1){
    play();
    start=true;
  }
  if(gameState ==3){
    play();
    start=true;
    hard=true;
  }
  
  // display instruction when gameState == 2
  if(gameState == 2){
    instruction();
  }
  
  // exit the game when gameState == 4
  if(gameState == 4){
    over();
  }
  }
  void menu (){
    background(menu);
    stroke(0);
/**
    fill(c_s1);
    rect(width/2-100, (height/2)+20,200,50);
    fill(c_s2);
    rect(width/2-100, (height/2)+90,200,50); 
    fill(c_s3);
    rect(width/2-100, (height/2)+160,200,50); 
 **/
 
  image(play,width/2,height/2+50,400,80);
    image(play2,width/2,height/2+120,400,80);
    image(htp,width/2,height/2+190,400,80);
    image(exit,width/2,height/2+260,400,80);
    
    //Buttom1 hover
    if (mouseX>width/2-200 && mouseX<width/2+200 && mouseY>height/2  && mouseY < height/2 +80){
       image(play_h,width/2,height/2+50,400,80);
        if(mousePressed){     
          gameState = 1;
        }
    }

  
       //Buttom2 hover
      if (mouseX>width/2-200 && mouseX<width/2+200 && mouseY>height/2 +90 && mouseY < height/2 +150){
          image(play2_h,width/2,height/2+120,400,80);
      if(mousePressed){
            gameState = 3;
          }
      }     

  
    
       //Buttom3 hover
      if (mouseX>width/2-200 && mouseX<width/2+200 && mouseY>height/2 +160 && mouseY < height/2 +220){
         image(htp_h,width/2,height/2+190,400,80);
      if(mousePressed){
            gameState = 2;
          }
      }
      
      if (mouseX>width/2-200 && mouseX<width/2+200 && mouseY>height/2 +230 && mouseY < height/2 +290){
         image(exit_h,width/2,height/2+260,400,80);
      if(mousePressed){
            exit();
          }
      }
      

  
    
  }


void play(){
  fill(255);
  background(0);
 //text("Sorry :( we are still working on it", width/2, height/2 );
 //returnMenu();
   playGame=true;
 
}
 // GameState == 1_____Instruction
void instruction(){
 background(instruction);
returnMenu();
}

// GameState == 4_____GameOver
  void over(){
  background(over);
  returnMenu();
  }
  
  void returnMenu(){
    if(mouseX<width/4+50 && mouseX>width/4-50 && mouseY > height-130 && mouseY < height-30){
  //  println("yessssssssss");  
   image(back_h, width/4,height-80,100,100);
     if(mousePressed){
       gameState = 0;
       playGame=false;
     }
 }
 else image(back,width/4,height - 80,100,100);
  }
  
  
}