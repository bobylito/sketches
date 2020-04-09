/**
 * Name: Day 89 ** cosmos
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
}

void reset() {
  noStroke();
  background(255);
}

void animation() {
  float n = frameCount / maxFrameNumber;
  translate(width * 0.5, height * 0.5);
  stroke(0);
  fill(255);
  for(int i = 20; i < 320; i++){
    float a = TWO_PI * (1.07 + sin(0.3 * cos(n * TWO_PI) * TWO_PI) * 0.001) * i;
    float r = log(i * i * 0.1 * sin((0.25 + 0.7 * sin(n * PI)) * PI)) * 30;
    circle(r * cos(a), r * sin(a), 10);
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
