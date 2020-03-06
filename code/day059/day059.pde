/**
 Name: Day 59 [= ring of fire
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 300; // The number of frame to record

color[] p1 = {
  #000000, 
  #f8615a, 
  #ffd868, 
  #ffd868, 
  #f8615a, 
  #000000, 
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
  size(1000, 1000, P2D);
  //smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

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
  background(0);
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

  float n = frameCount / maxFrameNumber;
  float t = n;

  float[] currentRingRadius = {
    t * 900 - 100, 
    t * 900 + 100
  };

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      PVector currentCenter = new PVector(
        (i + 0.5) * colSize, 
        (j + 0.5) * rowSize
        );

      float d = currentCenter.dist(center);

      if (d > currentRingRadius[0] && d < currentRingRadius[1]) {
        float amt = (d - currentRingRadius[0] + 100) / 200;
        float x = noise(currentCenter.x * 0.01, currentCenter.y * 0.01);
        color c = getFromPalette(p1, 1 - (amt * amt * x));
        fill(c);
        rect(currentCenter.x, currentCenter.y, colSize * (amt + 0.5), rowSize * (amt + 0.5));
      }
    }
  }
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
