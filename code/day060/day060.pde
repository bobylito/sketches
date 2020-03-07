/**
 Name: Day 60 ,, disolved
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 300; // The number of frame to record

// https://colorhunt.co/palette/163897
color[] aqua = {
  #ffffff, 
  #46b3e6, 
  #4d80e4, 
  #2e279d, 
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
  size(500, 500, P2D);
  // smooth(8);
  // pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  rectMode(CENTER);
  noiseSeed(0);
}

void reset() {
  noStroke();
  background(255);
}

void animation() {

  int cols = 200;
  int rows = 200;
  float colSize = width / float(cols);
  float rowSize = height / float(rows);

  PVector center = new PVector(
    width * 0.5, 
    height * 0.5
    );

  PVector norm = new PVector(1, 0);
  float n = frameCount / maxFrameNumber;
  float t = sin(n * PI);

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      PVector currentCenter = new PVector(
        (i + 0.5) * colSize, 
        (j + 0.5) * rowSize
        );

      float d = currentCenter.dist(center) * cos(PVector.angleBetween(currentCenter, norm) - PI / 10)* cos(PVector.angleBetween(currentCenter, norm) - PI / 10);

      float x = noise(currentCenter.x * 0.01, currentCenter.y * 0.01);
      color c = getFromPalette(aqua, x < t + 0.1  ? d / frameCount  : 0);
      fill(c);
      rect(currentCenter.x, currentCenter.y, colSize, rowSize);
    }
  }
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frameCount == 60) saveFrame("screenshot-1.png");
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
