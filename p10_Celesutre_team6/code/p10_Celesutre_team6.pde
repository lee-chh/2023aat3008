import java.util.ArrayList; 
import peasy.*;
import ddf.minim.*;

Minim minim;
AudioPlayer player;
PeasyCam cam;
ArrayList<PImage> planetTexture =  new ArrayList<>(); //여러 개의 행성 texture을 저장하기 위한 PImage arraylist
boolean making;
float type; //gesture type
PImage[] stickers; // 배경 스티커 array
int totalimages = 15; 
int planetnum = 1; //planet의 
PImage TextureImage;
PImage CanvasImage;
PImage backgroundImage;
int tilesize; //돌려서 섞을 때 조합할 image의 크기 

PShape mainPlanet;
Planet[] planets;

int lastTime;  // 마지막으로 동작이 실행된 시간을 저장
int currentTime; //현재 시간 저장

//슬라이싱 제스-------
PShader shade;
PImage slicing_bg;

float pixelnum_x=801;
float pixelnum_y=801;
//슬라이싱 제스-------

import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;

void setup() {
  size(1000, 800, P3D);
  background(0);
  minim = new Minim(this);
  String musicload = "First Step.mp3";
  player = minim.loadFile(musicload);
  player.play();
  player.loop();
  making = true;
  cam = new PeasyCam(this, width/2, height/2, 0, 500);
  
  imageMode(CENTER);
  stickers = new PImage[totalimages];
  CanvasImage = loadImage("Canvas.png");
  backgroundImage = loadImage("background.png");
  backgroundImage.resize(1000,800);
  
  for (int i = 0; i < totalimages; i++) { //sticker image 선언 
    String filename = "images_refer/img" + (i+1) + ".png";  // 이미지 파일명
    println(filename);
    stickers[i] = loadImage(filename);
    stickers[i].resize(400,400);
  }
  
  //슬라이싱 제스처 
  slicing_bg= loadImage("bg.jpeg");
  setupShader();
  //----------
  
  
  oscP5 = new OscP5(this,12000);
  dest = new NetAddress("127.0.0.1",6448);
}

void draw() {
  
  if (making)
  {
    makingTexture();
  } else { //testure 생성이 끝나면 실행 
    makingUniverse();
  }
}

void makingTexture()
{
  
  // ************** Class 1 ==> Nothing ****************//
  //*************************************************************//
  
  // ************** Class 2 ==> Slicing ****************//
  //*************************************************************//
  
  if(type==2.0 && (currentTime - lastTime > 400)){
    if(pixelnum_x>1)
    {pixelnum_x=pixelnum_x-100;
      pixelnum_x=map(pixelnum_x,0,800,0,150);}
      else{pixelnum_x=800;}
  //슬라이싱 제스처-----
  setShaderParameters();
  shader(shade);
  if(CanvasImage!=null)
   image(CanvasImage,0,0,2000,1600);
  resetShader();
  // 현재 시간으로 갱신
  lastTime = currentTime;
}
  
  // ************** Class 3 ==> Changingcolor ************************//
  //*************************************************************//
  
    if (type == 3.0&& currentTime - lastTime > 400)  // 0.4초 이상 지속했을 때 동작
  {
    
    loadPixels();
    int x = 0;
    int y = 0;
    
    // 색 랜덤하게 고르는 과정
    color targetColor = color(255, 0, 0); // Red
    int rand_choice = int(random(100))%3;
    if(rand_choice == 0){
      targetColor = color(255, 0, 0); // Red
    }else if(rand_choice == 1){
      targetColor = color(0, 255, 0); // Green
    }else if(rand_choice == 2){
      targetColor = color(0, 0, 255); // Blue
    }
    
    //화면의 상단 반을 특정 색 값만 남김
    for (int i = 0; i < width; i++) {
      x++;
      for (int h = 0; h < height / 2; h++) {
        color currentColor = pixels[x + (y + h) * width];
        
        // 픽셀의 색상을 특정 색상으로 변경
        float r = red(currentColor) + red(targetColor);
        float g = green(currentColor) + green(targetColor);
        float b = blue(currentColor) + blue(targetColor);
        
        // 경계를 초과하지 않도록 클램핑(clamping)
        r = constrain(r, 0, 255);
        g = constrain(g, 0, 255);
        b = constrain(b, 0, 255);
        
        pixels[x + (y + h) * width] = color(r, g, b);
      }
    }
    updatePixels();
    
    // 현재 시간으로 갱신
    lastTime = currentTime;
  }
  
  
  // ************** Class 4 ==> Mixing (Circular) ****************//
  //*************************************************************//
  
  float radius = 10;
  float angle = 0;
  int posx = int(random(0,width));
  int posy = int(random(0,height));
  int tilesize = int(random(30,60));
  
  while(radius < width/2 && (type==4.0))
  {
    int portionX = int(random(0,CanvasImage.width-tilesize));
    int portionY = int(random(0,CanvasImage.height-tilesize));
    PImage portion = CanvasImage.get(portionX,portionY,tilesize,tilesize);
    
    pushMatrix();
    translate(width/2,height/2);
    rotate(angle);
    translate(radius,0);
    image(portion,posx,posy);
    popMatrix();
    angle += radians(6);
    radius += 0.5;
    
    // 현재 시간으로 갱신
    lastTime = currentTime;
  }
  
  // ************** Class 5 ==> Make new image(Sticker)****************//
  //*************************************************************//

  if (type == 5.0 && currentTime - lastTime > 400)
  {
    image(stickers[int(random(0,totalimages))],random(100,width-100),random(100,height-100));
    saveFrame("Canvas.png");
    //use saveFrame to save current Canva's graphics
    CanvasImage = loadImage("Canvas.png");  
     // 현재 시간으로 갱신
    lastTime = currentTime;
  }
}


//change MODE
//*********************************

void makingUniverse()
{
    background(backgroundImage);
    translate(width / 2, height / 2);
    // 태양 그리기
    lights(); // 조명 활성화
    noStroke();
    //sphere(50);
    shape(mainPlanet);
  
    // 각 행성 그리기
    for (Planet planet : planets) {
      planet.update();
      planet.display();
    }
}

void keyPressed()
{
  if (key == ENTER) //Enter key를 누르면 만들어진 texture 기반의 planet 생성 
  {
    planetnum = planetTexture.size(); //number of planets
    planets = new Planet[planetnum-1];
    background(backgroundImage);
    making = false; // stop texture making
    for (int i = 0; i < planets.length; i++) {
    float distance = 100 + i * 50; // 태양에서의 거리
    float diameter = 10 + i * 5; // 행성의 지름
    float orbitalSpeed = radians(random(0.1, 0.8)); // 공전 속도 (라디안 단위)
    float axisInclination = radians(random(0, 30)); // 궤도 경사 (라디안 단위)
    planets[i] = new Planet(distance, diameter, orbitalSpeed, axisInclination, planetTexture.get(i+1));
    }
    noStroke();
    mainPlanet = createShape(SPHERE,50);
    mainPlanet.setTexture(planetTexture.get(0));
  } else if (key == ' ')
  {
    saveFrame("Canvas.png");
    CanvasImage = loadImage("Canvas.png");
    planetTexture.add(CanvasImage);
    background(0);
  }
}
//*********************************


//slicing-gesture
//*********************************
void setupShader() 
{
  shade = loadShader("slicing.glsl");
}

void setShaderParameters() 
{
    shade.set("pixels", pixelnum_x, pixelnum_y);
    shade.set("texture2", slicing_bg);
}
//*********************************

//OSC MESSAGE
void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/wek/outputs"))
  {
    msg.print();
    type = msg.get(0).floatValue();
    currentTime = millis();
  } else {
    //msg.print();
  }
}

void stop() {
  // 스케치가 종료될 때 Minim 리소스 정리
  player.close();
  minim.stop();
  super.stop();
}
