/**
 * Name: Day 75 ?? Roses
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

void setup() {
  size(700, 700, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(#45454d);
}

color[] p2324 = {
  #ff4893, 
  #ffd5d5, 
  #fff1e9
};

color getFromPalette(color[] palette, float n) {
  int nbColors = palette.length;
  int startColorIndex = max(0, floor(n * nbColors));
  float amt = (n * nbColors) - startColorIndex; 

  color start = palette[startColorIndex % nbColors];
  color end = palette[(startColorIndex + 1) % nbColors];

  return lerpColor(start, end, amt);
}

void animation() {
  translate(width * .5, height * .5);
  strokeWeight(.4);
  float n = frameCount / maxFrameNumber;
  for (int j = 0; j <= 22; j++) {
    int direction = ((j % 2) * 2) - 1;
    color c = getFromPalette(p2324, 10 * n + j / 8.0);
    stroke(c);
    for (int i = 0; i < 10; i++) {
      float x = 280 / log(j * j) * cos(direction * (n + i * .9) * TWO_PI);
      float y = 280 / log(j * j) * sin(direction * (n + i * .9) * TWO_PI);
      noFill();
      circle(x, y, 100);
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
