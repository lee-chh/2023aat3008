import peasy.*;
import processing.core.PImage;

PeasyCam cam;
int total = 100;
PVector[][] globe;
import controlP5.*;
ControlP5 cp5;
ControlP5 cp52;
ControlP5 colors;
ControlP5 tota;

ControlP5 redButton;
ControlP5 blueButton;
ControlP5 greenButton;
ControlP5 basicButton;
ControlP5 s1Button;
ControlP5 s2Button;
ControlP5 s3Button;
ControlP5 s0Button;

Slider tot;
Slider col;
Slider sl;
Slider sl2;

int sliderValue=1;
int sliderValue2=5;
int colorValue;
int totalValue;
int totalPoints = 100; 

int Shape = 0;

PImage img;


void setup(){
  size(800,800, P3D);
  
  translate(-400,-400);
  
  cp5 = new ControlP5(this);//make controller
  sl= cp5.addSlider("sliderValue");
    sl.setPosition(10, 10);
    sl.setSize(260, 30);
    sl.setRange(1, 7);
    sl.setColorCaptionLabel(color(255));//text color
    sl.setCaptionLabel("radius");
    sl.setColorForeground(color(200,70));
    sl.setColorBackground(color(200,0));
    cp5.setAutoDraw(false);
  //
  cp52 = new ControlP5(this);//make controller
  sl2 = cp5.addSlider("sliderValue2");
    sl2.setPosition(10, 50);
    sl2.setSize(260, 30);
    sl2.setRange(5, 10);
    sl2.setColorCaptionLabel(color(255));//text color
    sl2.setCaptionLabel("thickness");
    sl2.setColorForeground(color(200,70));
    sl2.setColorBackground(color(200,0));
    cp52.setAutoDraw(false);
   //
  colors = new ControlP5(this);//make controller
  col = cp5.addSlider("colorValue");
    col.setPosition(10, 90);
    col.setSize(260, 30);
    col.setRange(0, 255);
    col.setColorCaptionLabel(color(255));//text color
    col.setCaptionLabel("Pin color");
    col.setColorForeground(color(200,70));
    col.setColorBackground(color(200,0));
    colors.setAutoDraw(false);
   //
  tota = new ControlP5(this);//make controller
  tot = tota.addSlider("totalValue");
    tot.setPosition(10, 130);
    tot.setSize(260, 30);
    tot.setRange(3, 60);
    tot.setColorCaptionLabel(color(255));//text color
    tot.setCaptionLabel("ring shape");
    tot.setColorForeground(color(200,70));
    tot.setColorBackground(color(200,0));
    tota.setAutoDraw(false);
  //
  redButton = new ControlP5(this);
  redButton.addButton("Fire").setPosition(80,170).setSize(50,30).setValue(2);
  redButton.setColorBackground(color(170,0,0));
  redButton.setAutoDraw(false);
  
  blueButton = new ControlP5(this);
  blueButton.addButton("Water").setPosition(150,170).setSize(50,30).setValue(3);
  blueButton.setColorBackground(color(0,0,170));
  blueButton.setAutoDraw(false);
  
  greenButton = new ControlP5(this);
  greenButton.addButton("Leaf").setPosition(220,170).setSize(50,30).setValue(4);
  greenButton.setColorBackground(color(0,170,0));
  greenButton.setAutoDraw(false);
  
  basicButton = new ControlP5(this);
  basicButton.addButton("Basic").setPosition(10,170).setSize(50,30).setValue(1);
  basicButton.setColorBackground(color(120));
  basicButton.setAutoDraw(false);
  //
  s0Button = new ControlP5(this);
  s0Button.addButton("Shape").setPosition(10,220).setSize(50,30).setValue(0)
  .setCaptionLabel("normal").setColorBackground(color(220));;
  s0Button.setAutoDraw(false);
  
  s1Button = new ControlP5(this);
  s1Button.addButton("Shape").setPosition(80,220).setSize(50,30).setValue(1)
  .setCaptionLabel("Snowman").setColorBackground(color(210,170,170));;;
  s1Button.setAutoDraw(false);
  
  s2Button = new ControlP5(this);
  s2Button.addButton("Shape").setPosition(150,220).setSize(50,30).setValue(2)
  .setCaptionLabel("Flower").setColorBackground(color(30,165,210));
  s2Button.setAutoDraw(false);
  
  s3Button = new ControlP5(this);
  s3Button.addButton("Shape").setPosition(220,220).setSize(50,30).setValue(3)
  .setCaptionLabel("Complex").setColorBackground(color(190,230,75));
  s3Button.setAutoDraw(false);
  //
  globe = new PVector[total+1][total+1];
  cam = new PeasyCam(this, width/2);
}

void draw(){
  if (img == null) {
    fill(colorValue);
  }else {
    texture(img);
  }
  
  total = totalValue;
  background(0);
  lights();
  ambientLight(51,colorValue, 255-colorValue);
  
  float R = sliderValue2;
  float r = sliderValue;
  
  for (int i =0; i<total+1; i++){
    float u = map(i,0,total, 0,2*PI);
    for (int j =0;j< total+1;j++){
      float v = map(j, 0, total, 0, 2*PI);
      float x = (R + r* cos(v)) *cos(u);
      float y = (R + r* cos(v))* sin(u);
      float z = r *sin(v);
      globe[i][j] = new PVector(x,y,z);
    }
  }
  
  for (int i =0; i<total; i++){
    beginShape(TRIANGLE_STRIP);
    texture(img);
    for (int j =0;j< total+1;j++){
      //float hu = map(j,0,total,0,255*1);
      fill(255);//hu%255
      PVector v1 = globe[i][j];
      noStroke();
      vertex(v1.x*10,v1.y*10,v1.z*10,j,0);
      PVector v2 = globe[i+1][j];
      vertex(v2.x*10,v2.y*10,v2.z*10,j,i);
    }
    endShape();
  }
 cam.beginHUD();
 cp5.draw();
 tota.draw();
 basicButton.draw();
 redButton.draw();
 blueButton.draw();
 greenButton.draw();
 s0Button.draw();
 s1Button.draw();
 s2Button.draw();
 s3Button.draw();
 
 cam.endHUD();
 
 switch (Shape) {
    case 0:
      break;
    case 1:
      Snowman(R,r, 5); // Snowman 모양 그리기
      break;
    case 2:
      Flower(R,r,6); // Flower 모양 그리기
      break;
    case 3:
      Complex(R,r,7); // Complex 모양 그리기
      break;
  }

}

void Basic(int theValue){
  img = null;
  colorValue = (int)col.getValue(); 
  fill(colorValue);
}
void Fire(int theValue){
  img = loadImage("fire.jpeg");
}
void Water(int theValue){
  img = loadImage("water.jpeg");
}
void Leaf(int theValue){
  img = loadImage("leaf.jpeg");
}


void Snowman(float R, float r, int theValue) {
  float deltaU = TWO_PI / totalPoints;
  float deltaV = PI / totalPoints;

  float u = 0;
  float v = asin((R - r) / R);

  translate(11*R,0,0);

  for (u = 0; u < TWO_PI; u += deltaU) {
    beginShape();
    texture(img);
    for (v = -HALF_PI; v < HALF_PI; v += deltaV) {
      float x = r * 5 * cos(u) * (3 * cos(v) - cos(3 * v)); 
      float z = r * 5 * sin(u) * (3 * cos(v) - cos(3 * v)); 
      float y = r * 5 * (3 * sin(v) - sin(3 * v)); 
      vertex(x, y, z, u, v);
    }
    endShape(CLOSE);
  }
}

void Flower(float R, float r, int theValue) {
  float deltaU = PI / totalPoints; 
  float deltaV = PI / totalPoints;

  translate(12*R,0,0);

  for (float u = -PI; u < PI; u += deltaU) {
    beginShape();
    texture(img);
    for (float v = -PI; v < PI; v += deltaV) {
      float y = u - (u * u * u / 3) + u * v * v;
      float z = v - (v * v * v / 3) + u * u * v;
      float x = u * u - v * v;
      vertex(x * r, y * r, z * r, u, v);
    }
    endShape(CLOSE);
  }
}
void Complex(float R, float r, int theValue) {
  float deltaU = PI / totalPoints; 
  float deltaV = PI / totalPoints;

  translate(12*R,0,0);

  for (float u = -PI; u < PI; u += deltaU) {
    beginShape();
    texture(img);
    for (float v = -PI; v < PI; v += deltaV) {
      float y = 10*(sin(u) + 2*sin(2*u))/(2 + cos(v + 2*PI/3));
      float z = 5*(cos(u) - 2*cos(2*u))*(2 + cos(v))*(2 + cos(v + 2*PI/3))/4;
      float x = 10*sin(3*u)/(2 + cos(v));
      vertex(x * r, y * r, z * r, u, v);
    }
    endShape(CLOSE);
  }
}
