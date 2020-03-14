/**
 * Name: Day 67 <> hexagon
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

PVector[] hexa;
float radius = 30;
float xStep = radius * sin(PI / 3);
float yStep = radius * cos(PI / 3);

color getFromPalette(color[] palette, float n) {
  int nbColors = palette.length;
  int startColorIndex = max(0, floor(n * nbColors));
  float amt = (n * nbColors) - startColorIndex; 

  color start = palette[startColorIndex % nbColors];
  color end = palette[(startColorIndex + 1) % nbColors];

  return lerpColor(start, end, amt);
}

color[] p234 = {
  #721b65, 
  #b80d57, 
  #f8615a, 
  #ffd868
};

void setup() {
  size(700, 700, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  noiseSeed(13);

  hexa = new PVector[6];
  for (int i = 0; i < 6; i ++) {
    hexa[i] = new PVector(cos(i * TWO_PI / 6 + PI / 6), sin(i * TWO_PI / 6+ PI / 6));
  }
}

void reset() {
  noStroke();
  background(255);
}

void drawHexa(float x, float y, float radius) {
  pushMatrix();
  translate(x, y);
  beginShape();
  for (PVector p : hexa) {
    vertex(p.x * radius, p.y * radius);
  }
  endShape(CLOSE);
  popMatrix();
}

void animation() {
  strokeWeight(3);
  for (int i = 0; i < 20; i++) {
    for (int j = 0; j < 20; j++) {
      boolean isOdd = j % 2 == 0;
      float v = noise(0.2 * i, 0.2 *  (j + frameCount * 0.05) % (maxFrameNumber / 200));
      color c = getFromPalette(p234, (max(0.5, v) - .5) * 2);
      stroke(#721b65);
      fill(c);
      if (isOdd) {
        drawHexa(i * xStep * 2 + xStep, j * 1.5 * radius, radius);
      } else {
        drawHexa(i * xStep * 2, j * 1.5 * radius, radius);
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
