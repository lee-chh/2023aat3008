/*

 Project #7 by Changhyun Lee
 
 "Kerby"
 
 This is a fireworks display using Particles.
 
 Process : 
 
  - Define [SinOscillator] class for managing sound oscillations.
  - Set up an array of SinOscillators with diverse frequencies and volume controls.
  - Extract pixel data from camera video for Wekinator input.
  - Dynamically modify sound frequencies based on Wekinator output.
  - Visualize video, display a transparent guide circle at the user's hand position, and show Wekinator-based text.
 
 danso image source : https://www.11st.co.kr/products/4715720441
 
 */

import processing.video.*;
import processing.sound.*;
import oscP5.*;
import netP5.*;

PImage danso;

int boxWidth = 32;
int boxHeight = 24;

float startFrequency = 174.61; // frequency of [중]
float endFrequency = 293.66;   // frequency of [태]

float wek_output = 0; // for text, ellipse display

color[] downPix;

Capture video;
OscP5 oscP5;
NetAddress dest;
SinOsc[] oscillators;

void setup() {
  size(640, 680);
  danso = loadImage("danso.jpg");
  danso.resize(480,100);
  

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    video = new Capture(this, cameras[0]);
    video.start();
  }

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  dest = new NetAddress("127.0.0.1", 6448);

  noStroke();

  oscillators = new SinOsc[5];
  for (int i = 0; i < oscillators.length; i++) {
    oscillators[i] = new SinOsc(this);
    oscillators[i].amp(0); // volume OFF

    float mappedFrequency = map(i, 0, oscillators.length - 1, startFrequency, endFrequency);

    oscillators[i].freq(mappedFrequency);
    oscillators[i].play();
  }

  downPix = new color[(width / boxWidth) * (480 / boxHeight)];
}

void draw() {
  background(0);
  randomSeed(0);
  image(video, 0, 0);

  if (video.available()) {
    video.read();
    video.loadPixels();

    int boxNum = 0;
    int tot = boxWidth * boxHeight;

    for (int x = 0; x < width; x += boxWidth) {
      for (int y = 0; y < 480; y += boxHeight) {
        float red = 0, green = 0, blue = 0;

        for (int i = 0; i < boxWidth; i++) {
          for (int j = 0; j < boxHeight; j++) {
            int index = (x + i) + (y + j) * 640;
            red += red(video.pixels[index]);
            green += green(video.pixels[index]);
            blue += blue(video.pixels[index]);
          }
        }

        downPix[boxNum] = color(red / tot, green / tot, blue / tot);
        fill(downPix[boxNum]);
        boxNum++;
      }
    }
    //println("downPix array size: " + downPix.length);


    if (frameCount % 3 == 0) sendOsc(downPix);

  }
  fill(255,50);
  ellipse(320,240,260,280);
  fill(255);
  rect(0,480,640,680);
  image(danso,0,530);
  drawCirc(wek_output);
  
}

void keyPressed() {
  if (key >= '1' && key <= '5') {
    int index = key - '1';
    oscillators[index].amp(0.5); // volume ON
  }
}

void keyReleased() {
  if (key >= '1' && key <= '5') {
    int index = key - '1';
    oscillators[index].amp(0); // volume OFF
  }
}

void sendOsc(color[] px) {
  OscMessage msg = new OscMessage("/wek/inputs");
  for (int i = 0; i < px.length; i++) {
    msg.add(float(px[i]));
  }
  oscP5.send(msg, dest);
}

void oscEvent(OscMessage m) {
  if (m.checkAddrPattern("/wek/outputs") && m.checkTypetag("f")) {
    float ML_Out = m.get(0).floatValue();
    float freq = map(ML_Out, 0, 1, startFrequency, endFrequency);
    wek_output = ML_Out;
    println("wek : ",wek_output);

    for (int i = 0; i < oscillators.length; i++) {
      oscillators[i].freq(freq);
      oscillators[i].amp(0.5); // Sound ON
      
    }
  }
}

void drawCirc(float freq) {
  fill(0,0,255);
  textSize(50);
  if(freq>0.875){
    fill(0);
    text("TAE",450,600);
    fill(240);
  }
  ellipse(240,600,8,8);
  if(freq>0.625&&freq<=0.875){
    fill(0);
    text("HWANG",450,600);
    fill(240);
  }
  ellipse(255,580,8,8);
  if(freq>0.375&&freq<=0.625){
    fill(0);
    text("MOO",450,600);
    fill(240);
  }
  ellipse(287,580,8,8);
  if(freq>0.125&&freq<=0.375){
    fill(0);
    text("IM",450,600);
    fill(240);
  }
  ellipse(340,580,8,8);
  if(freq<=0.125){
    fill(0);
    text("JOONG",450,600);
    fill(240);
  }
  ellipse(376,580,8,8);
  
}
