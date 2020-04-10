/**
 * Name: Day 90 –– 
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 720; // The number of frame to record

void setup() {
  size(700, 700, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if(isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
  rectMode(CENTER);
}

void reset() {
  noStroke();
  background(255);
}

void animation() {
  float n = frameCount / maxFrameNumber;
  translate(width * 0.5, height * 0.5);
  scale(1.8);
  stroke(0);
  noFill();
  strokeWeight(0.2);
  for(int i = 300; i < 3000; i++){
    float a = TWO_PI * (1.07 + sin(1.3 - TWO_PI - 0.8 * sin(n * TWO_PI) ) * 0.002) * i * 0.1;
    float r = log(pow(i, 1.3) * 0.01 * sin((0.15 + 0.1 * sin(n * PI)) * PI)) * 30;
    pushMatrix();
    translate(r * cos(a), r * sin(a));
    rotate(a * 1.8);
    square(0,0, 10 + 50 * (i / 3000.0));
    popMatrix();
  }
}

void draw() {
  reset();
  animation();

  if(isReadyForExport) {
    export.saveFrame();
    if(frameCount == 1) saveFrame("screenshot-1.png");
    if(frameCount == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
    if(frameCount == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");
  }

  if (frameCount >= maxFrameNumber) {
    if(isReadyForExport) {
      export.endMovie();
    }
    exit();
  }
}
