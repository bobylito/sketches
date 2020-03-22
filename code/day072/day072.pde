/**
 * Name: Day 72 $$ ICE
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

color[] neon = {
  #0099db, 
  #6638f0, 
  #371c78, 
  #f460c6
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
  size(700, 700, P3D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  colorMode(HSB);
}

color bg = #150c6d;
void reset() {
  noStroke();
  background(bg);
}

void animation() {
  pushMatrix();
  rotateX(PI / 5);
  fill(hue(bg), saturation(bg), brightness(bg) + 30);
  float nbBars = 101;
  for (int i = 0; i < nbBars; i++) {
    if (i % 2 == 1) {
      rect(0, 0, width / nbBars, height);
    }
    translate(width / nbBars, 0);
  }
  popMatrix();

  noFill();
  float n =frameCount / maxFrameNumber;
  translate(width * 0.5, height * 0.5, (500 - 75));
  rotateY(PI / 6 + n * TWO_PI );
  rotateX(PI / 6 + n * TWO_PI );
  translate(0, 0, 75);
  strokeWeight(5);
  for (int i = 0; i < 30; i++) {
    stroke(getFromPalette(neon, i / 30.0));
    float radius = sin((float(i) / 30.0) * PI + TWO_PI * n + PI / 2) * 90;
    circle(0, 0, radius);
    translate(0, 0, -5 );
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
