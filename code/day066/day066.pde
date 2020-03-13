/**
 * Name: day 66 ^ resonnance
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

int steps;
float stepX;
float stepY;

void setup() {
  size(700, 700, P2D);
  smooth(8);
  //pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  steps = 50;
  stepX = 1.5 * width / steps;
  stepY = 1.5 * height / steps;

  noiseSeed(100);
}

color bg = #0b032d;
color[] p20 = {
  #843b62, 
  #f67e7d, 
  #ffb997, 
};

void reset() {
  noStroke();
  background(bg);
}

color getFromPalette(color[] palette, float n) {
  int nbColors = palette.length;
  int startColorIndex = max(0, floor(n * nbColors));
  float amt = (n * nbColors) - startColorIndex; 

  color start = palette[startColorIndex % nbColors];
  color end = palette[(startColorIndex + 1) % nbColors];

  return lerpColor(start, end, amt);
}

float l = 40;
void animation() {
  strokeWeight(1.1);
  fill(bg);
  translate(width * 0.5, height * 0.5);

  PVector p = new PVector(0, 0);
  PVector[] stack = new PVector[steps];

  for (int i = 0; i < steps; i++) {
    float n = (i - frameCount) % (maxFrameNumber);
    float angle = noise(n * 0.01) * TWO_PI;
    stack[i] = new PVector(l* cos(angle), l* sin(angle)).add(p);
  }

  for (int i = 0; i < steps; i++) {
    int iPrime = steps - 1 - i;
    float n = float(i) / float(steps);
    stroke(getFromPalette(p20, n));
    PVector current = stack[iPrime];
    ellipse(current.x, current.y, stepX * iPrime, stepY * iPrime);
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
