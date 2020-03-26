/**
 * Name: Day 76 <> organically
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

color[] p138132 = {
  #ea168e, 
  #612570, 
  #1eafed
};
color getFromPalette(color[] palette, float n) {
  int nbColors = palette.length;
  int startColorIndex = max(0, floor(n * nbColors));
  float amt = (n * nbColors) - startColorIndex; 

  color start = palette[startColorIndex % nbColors];
  color end = palette[(startColorIndex + 1) % nbColors];

  return lerpColor(start, end, amt);
}

void setup() {
  size(700, 700, P2D);
  smooth(8);
  //pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  noiseSeed(0);
}

void reset() {
  noStroke();
  float n = map(frameCount, 0, maxFrameNumber, 0, 1);
  background(getFromPalette(p138132, n));
}

void animation() {
  stroke(#eef2f5);
  strokeWeight(0.5);
  noFill();
  translate(width * 0.5, height * 0.5);
  float n = map(frameCount, 0, maxFrameNumber, 0, 1);
  //beginShape();
  for (int i = 0; i < 3000; i++) {
    float angle = map(i, 0, 3000, 0, TWO_PI);
    float x = 300 * sin(angle * 7 + radians(50));
    float y = 300 * sin(angle * 5 + TWO_PI * n);
    float radius = noise((i + n * 600) * 0.05) * 60;
    circle(x, y, radius);
  }
  //endShape();
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frameCount == 1) saveFrame("screenshot-1.png");
    if (frameCount == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
    if (frameCount == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");
  }

  if (frameCount >= maxFrameNumber) {
    if (isReadyForExport) {
      export.endMovie();
    }
    exit();
  }
}
