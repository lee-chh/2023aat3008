import processing.sound.*;

float startFrequency = 174.61; // frequency of [중]
float endFrequency = 293.66;   // frequency of [태]

SinOsc[] oscillators = new SinOsc[5];

void setup() {
  size(200, 200);

  for (int i = 0; i < oscillators.length; i++) {
    oscillators[i] = new SinOsc(this);
    oscillators[i].amp(0); // volume OFF
    
    // map
    float mappedFrequency = map(i, 0, oscillators.length - 1, startFrequency, endFrequency);
    
    oscillators[i].freq(mappedFrequency);
    oscillators[i].play();
  }
}

void draw() {
  background(255);
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
