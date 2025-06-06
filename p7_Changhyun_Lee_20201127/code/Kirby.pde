/*

 Project #7 by Changhyun Lee
 
 "Kerby"
 
 This is a fireworks display using Particles.
 
 Process : 
 
  - Get the position of the mouth, eyes, nose, etc. via faceOSC.
  - Based on this information, draw a Kirby.
  - Initially, create a single mob.
  - If the size of the mouth is larger than a certain size,
  the mob will shrink and be sucked into the mouth.
  - A hat is created based on the mob being sucked in.
  - When the key is pressed, the hat disappears and a new mob is randomly generated.


 
 background image source : https://www.nintendo.co.kr/switch/ah26a/pc/
 
 */
 
 
import oscP5.*;
OscP5 oscP5;

PImage eye;
PImage beam;
PImage fire;
PImage sand;
PImage waddledoo;
PImage burningleo;
PImage sandran;
PImage back;

// num faces found
int found;

// pose
float poseScale;
PVector posePosition = new PVector();
PVector poseOrientation = new PVector();

// gesture
float mouthHeight;
float mouthWidth;
float eyeLeft;
float eyeRight;
float eyebrowLeft;
float eyebrowRight;
float jaw;
float nostrils;

int kerby = 80;

int checkhat = 0;

// 몹 이미지 배열
PImage[] mobs;

// 몹 및 관련
float mobSize = 40;
float mobSize_d = 0;
int checkmob = 0;
int cheakhat = 0;
float mobX = 100;
float mobY = 0;

// 모자 이미지 배열
PImage[] hats;


void setup() {
  size(1000, 700);
  frameRate(120);
  
  back = loadImage("back.png");
  back.resize(1000,700);
  
  eye = loadImage("eye.png");
  beam = loadImage("beam.png");
  fire = loadImage("fire.png");
  sand = loadImage("sand.png");
  waddledoo = loadImage("waddledoo.png");
  burningleo = loadImage("burningleo.png");
  sandran = loadImage("sandran.png");
  
  beam.resize(kerby, kerby);
  fire.resize(kerby, kerby);
  sand.resize(kerby, kerby);
  eye.resize(10,20);

  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "poseScale", "/pose/scale");
  oscP5.plug(this, "posePosition", "/pose/position");
  oscP5.plug(this, "poseOrientation", "/pose/orientation");
  oscP5.plug(this, "mouthWidthReceived", "/gesture/mouth/width");
  oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
  oscP5.plug(this, "eyeLeftReceived", "/gesture/eye/left");
  oscP5.plug(this, "eyeRightReceived", "/gesture/eye/right");
  oscP5.plug(this, "eyebrowLeftReceived", "/gesture/eyebrow/left");
  oscP5.plug(this, "eyebrowRightReceived", "/gesture/eyebrow/right");
  oscP5.plug(this, "jawReceived", "/gesture/jaw");
  oscP5.plug(this, "nostrilsReceived", "/gesture/nostrils");
  
  // 몹 이미지 배열 초기화
  mobs = new PImage[]{waddledoo, burningleo, sandran};
  // 모자 이미지 배열 초기화
  hats = new PImage[]{beam, fire, sand};
  
  
}



void draw() {  
  
  image(back,0,0);
  //background(255,255,255,50);
  stroke(0);
  
  if(found > 0) {
    translate(posePosition.x, posePosition.y);
    scale(poseScale);
    
    noStroke();
    
    if (mouthHeight > 5) {
      //rignt arms
      
      translate(kerby/2*cos(5.76),kerby/2*sin(5.76));
      rotate(5.5);
      fill(#FFA8CF);
      ellipse(0,0,30,20);
      rotate(-5.5);
      translate(-kerby/2*cos(5.76),-kerby/2*sin(5.76));
      
      
      //left amrs   
      translate(kerby/2*cos(3.665),kerby/2*sin(3.665));
      rotate(0.78);
      fill(#FFA8CF);
      ellipse(0,0,30,20);
      rotate(-0.78);
      translate(-kerby/2*cos(3.665),-kerby/2*sin(3.665));
      
      //left leg
      translate(kerby/2*cos(2.1),kerby/2*sin(2.1));
      rotate(5.76);
      fill(#F04A51);
      ellipse(0,0,30,20);
      rotate(-5.76);
      translate(-kerby/2*cos(2.1),-kerby/2*sin(2.1));
      
      //right leg
      translate(kerby/2*cos(1),kerby/2*sin(1));
      rotate(0.5);
      fill(#F0586A);
      ellipse(0,0,30,20);
      rotate(-0.5);
      translate(-kerby/2*cos(1),-kerby/2*sin(1));
      
      //face
      fill(#FFB8D8);
      ellipse(0,0,kerby,kerby);    

    }
    else{
      //rignt arms
      rotate(100);
      translate(kerby/2*cos(0),kerby/2*sin(0));
      fill(#FFA8CF);
      ellipse(0,0,30,20);
      translate(-kerby/2*cos(0),-kerby/2*sin(0));
      rotate(-100);
      
      //left amrs
      rotate(100);
      translate(kerby/2*cos(180),kerby/2*sin(180));
      fill(#FFA8CF);
      ellipse(0,0,30,20);
      translate(-kerby/2*cos(180),-kerby/2*sin(180));
      rotate(-100);
      
      //left leg
      translate(kerby/2*cos(2.1),kerby/2*sin(2.1));
      rotate(5.76);
      fill(#F04A51);
      ellipse(0,0,30,20);
      rotate(-5.76);
      translate(-kerby/2*cos(2.1),-kerby/2*sin(2.1));
      
      //face
      fill(#FFB8D8);
      ellipse(0,0,kerby,kerby);
      
      //right leg
      translate(kerby/2*cos(1),kerby/2*sin(1));
      rotate(5.5);
      fill(#F0586A);
      ellipse(0,0,30,20);
      rotate(-5.5);
      translate(-kerby/2*cos(1),-kerby/2*sin(1));
    }
    

    

    
    //eye
    image(eye,-12, eyeLeft * -9-10);
    image(eye,2, eyeLeft * -9-10);
    
    //mouth
    noStroke();
    float mouthTopY = -5; // 입 상단의 기본 y 좌표
    // 입의 상단의 y 좌표를 입이 커질 때에 따라 조절
    float adjustedMouthTopY = mouthTopY + (mouthHeight * 4) / 2; 
    fill(255, 0, 0);
    ellipse(0, adjustedMouthTopY, mouthHeight * 5, mouthHeight * 5);
    
    //flushing
    fill(#FF99C7);
    noStroke();
    ellipse(-20, nostrils * -1-5, 10, 5);
    ellipse(20, nostrils * -1-5, 10, 5);
    rectMode(CENTER);
    fill(0);
    
    drawMob();
    
  }
  else {
    text("Where is KERBY!\nfind your head!",width/2, height/2);
  }
}

// 몹 그리기
void drawMob() {
  
  
  if (mouthHeight > 5) {
    mobSize_d = 0.6;
  }
  else{
    mobSize_d = 0;
  }
  
  mobX = mobX-mobSize_d*5/2; 
  mobY = 10-mobSize;
  mobSize = mobSize - mobSize_d;
  if(mobSize > 0){
    image(mobs[checkmob], mobX,mobY, mobSize,mobSize);
  }
  if(mobSize<0){
    cheakhat = checkmob;
    image(hats[cheakhat],0-kerby/2+5,0-(kerby*5/4));
    textSize(10);
    text("press [SPACE] to create new MOB!",-60, 60);
  }
  
}

void keyPressed() {
  // 키를 누르면 랜덤한 몹 생성
  mobSize = 40;
  checkmob = int(random(3));
  mobX = 100;
  mobY = 0;
}

// OSC CALLBACK FUNCTIONS

public void found(int i) {
  println("found: " + i);
  found = i;
}

public void poseScale(float s) {
  println("scale: " + s);
  poseScale = s;
}

public void posePosition(float x, float y) {
  println("pose position\tX: " + x + " Y: " + y );
  posePosition.set(x, y, 0);
}

public void poseOrientation(float x, float y, float z) {
  println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
  poseOrientation.set(x, y, z);
}

public void mouthWidthReceived(float w) {
  println("mouth Width: " + w);
  mouthWidth = w;
}

public void mouthHeightReceived(float h) {
  println("mouth height: " + h);
  mouthHeight = h;
}

public void eyeLeftReceived(float f) {
  println("eye left: " + f);
  eyeLeft = f;
}

public void eyeRightReceived(float f) {
  println("eye right: " + f);
  eyeRight = f;
}

public void eyebrowLeftReceived(float f) {
  println("eyebrow left: " + f);
  eyebrowLeft = f;
}

public void eyebrowRightReceived(float f) {
  println("eyebrow right: " + f);
  eyebrowRight = f;
}

public void jawReceived(float f) {
  println("jaw: " + f);
  jaw = f;
}

public void nostrilsReceived(float f) {
  println("nostrils: " + f);
  nostrils = f;
}

// all other OSC messages end up here
void oscEvent(OscMessage m) {
  if(m.isPlugged() == false) {
    println("UNPLUGGED: " + m);
  }
}
