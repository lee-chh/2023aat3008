/*

 Project #3 by Changhyun Lee
 
 "Android"
 
 This is a representation of the Android as seen from the body part.
 
 Process : 
 
 Declare [prevFrame] by global variable
 Setup the video & initialize [prevFrame]
 Video mirroring
 Outputting video on the below
 Compare current and previous frames
 If difference is bigger than 75(distance),
 change point shows circle(random color, size by difference)
 Save the current frame to prevFrame
 
 */

import processing.video.*;

Capture video;
color[] prevFrame;

void setup() {
  size(640, 480);

  String[] cameras = Capture.list();
  if (cameras.length > 0) {
    video = new Capture(this, cameras[0]);
    video.start();
  } else {
    println("No cameras available");
    exit();
  }

  // initialize 'color' that save the pixel value of previous frame
  prevFrame = new color[width * height];
}

void draw() {
  if (video.available() == true) {
    video.read();

    // video mirroring
    scale(-1, 1);
    translate(-width, 0);

    loadPixels();

    // outputting video on the below
    image(video, 0, 0, width, height);

    // compare current and previous frames
    for (int i = 0; i < pixels.length; i++) {
      color current = video.pixels[i];
      color prev = prevFrame[i];

      float diff = dist(red(current), green(current), blue(current),
        red(prev), green(prev), blue(prev));

      // if difference is bigger than 75(distance)
      if (diff > 75) {
        // change point shows circle(random color)
        fill(random(255), random(255), random(255));
        noStroke();
        ellipse(i % width, i / width, diff / 25, diff / 25);
      }
    }

    // save the current frame to prevFrame
    arrayCopy(video.pixels, prevFrame);
  }
}
