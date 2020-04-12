/**
 * Name: Day 92 <- trails
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

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(#070dbc);
}

PVector getPoint(int step, float t) {
  PVector p = new PVector(0, 0);
  for (int i = 0; i < step; i++) {
    int d = directions[i];
    PVector dv = vds[d];
    p.add(PVector.mult(dv, segmentLength));
  }
  int currentD = directions[step];
  p.add(PVector.mult(vds[currentD], segmentLength * t));
  return p;
}

// Taken from https://gist.github.com/gre/1650294
float easeOutQuint(float t) {
  return t<.5 ? 16*pow(t, 5) : 1 + 16 * pow(t-1, 5);
}
float steps = 8;
int framesPerStep = floor(maxFrameNumber / steps);
int[] directions = {0, 1, 2, 3, 3, 2, 1, 0}; // right, up, left, down, down, left, up, right
PVector[] vds = {
  new PVector(1, 0), 
  new PVector(0, -1), 
  new PVector(-1, 0), 
  new PVector(0, 1)
};
PVector point = new PVector(0, 0);
float segmentLength = 250;
color[] colors = {
  #ff331c, 
  #fcc40d, 
  #001465, 
  #070dbc
};

void drawCircles(float frame) {
    // current step or "scene". Each does a different animation.
  int step = (int(frame) / framesPerStep) % int(steps);
  // current frame in the step, so that we can keep track
  float frameInCurrentStep = frame % framesPerStep;

  int nbColors = colors.length;
  for (int i = 0; i < nbColors; i++) {
    float n = constrain(frameInCurrentStep - (nbColors - i) * 3, 0, framesPerStep - nbColors * 3) / (framesPerStep - nbColors * 3);
    float t = easeOutQuint(n);
    PVector p = getPoint(step, t);
    fill(colors[i]);
    circle(p.x, p.y, 100);
  }
}

void animation() {
  translate(width * 0.5, height * 0.5);
  for (int i = 0; i < 3; i++) {
    drawCircles((30 + frameCount + 450 * i) % maxFrameNumber);
  }
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frameCount == 1) saveFrame("screenshot-1.png");
    if (frameCount == Math.floor(maxFrameNumber / 3) + 30) saveFrame("screenshot-2.png");
    if (frameCount == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");
  }

  if (frameCount >= maxFrameNumber) {
    if (isReadyForExport) {
      export.endMovie();
    }
    exit();
  }
}
