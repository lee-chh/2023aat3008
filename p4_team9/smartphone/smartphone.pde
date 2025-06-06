import peasy.PeasyCam;
import controlP5.*;

PeasyCam cam;
int bodyW = 50;
int bodyD = 100;
int thickness = 10;
int bezel = 5;
int radius_camera = 10;
int camera = 3;
float rotX, rotY;
ControlP5 cp5;

void setup() {
  size(600, 600, P3D);
  colorMode(RGB, 1);
  noFill();

  cam = new PeasyCam(this, 300);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
  cam.lookAt(width/2.0, height/2.0, 0);


  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  cp5.addSlider("bodyW").setPosition(10, 10).setRange(40, 50).setColorCaptionLabel(color(0,0,0)).setCaptionLabel("Width");
  cp5.addSlider("bodyD").setPosition(10, 30).setRange(80, 100).setColorCaptionLabel(color(0,0,0)).setCaptionLabel("length");
  cp5.addSlider("thickness").setPosition(10, 50).setRange(5, 10).setColorCaptionLabel(color(0,0,0)).setCaptionLabel("thickness");
  cp5.addSlider("bezel").setPosition(10, 70).setRange(2, 5).setColorCaptionLabel(color(0,0,0)).setCaptionLabel("bezel");
  cp5.addSlider("camera").setPosition(10, 90).setRange(1, 3).setColorCaptionLabel(color(0,0,0)).setCaptionLabel("camera");
  cp5.addSlider("radius_camera").setPosition(10, 110).setRange(5, 10).setColorCaptionLabel(color(0,0,0)).setCaptionLabel("camera radius");
}

void draw() {
  background(1);
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();

  translate(width / 2, height / 2, 0);
  rotateX(rotX);
  rotateY(rotY);

  drawPhone();
}

void drawPhone() {
  translate(0, 0, 0);
  
  //body
  fill(0,0,0);
  box(bodyW,bodyD, thickness);
  
  //display
  translate(0,0,thickness/2+0.001);
  fill(255,255,255);
  box(bodyW-bezel, bodyD-bezel,0);
  translate(0, 0,-(thickness/2+0.001));
  
  //camera
  for(int i =0;i<camera;i++){
    
    translate(bodyW/2-radius_camera-radius_camera*i,bodyD/2-radius_camera,-(thickness/2+0.001));
    ellipseMode(CENTER);
    ellipse(0, 0, radius_camera, radius_camera);
    translate(-(bodyW/2-radius_camera-radius_camera*i),-(bodyD/2-radius_camera),(thickness/2+0.001));
  }
}

void mouseClicked() {
  float sensitivity = 0.01;
  rotX -= (pmouseY - mouseY) * sensitivity;
  rotY += (pmouseX - mouseX) * sensitivity;
}
