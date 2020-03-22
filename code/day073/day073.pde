/**
 * Name: Day 73 \- direction
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

int framesPerStep = 20;
int size = 20;
int[][] directions;
int[][] nextDirections;

int[][] getDirections(int step) {
  noiseSeed(1000 * step);
  int[][] res = new int[size][size];
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      int v = round(noise(i * 0.2, j * 0.2) * 4);
      res[i][j] = v;
    }
  }
  return res;
}

void setup() {
  size(700, 700, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }


  nextDirections = getDirections(-1);
  directions = nextDirections;
  rectMode(CENTER);
}

void reset() {
  noStroke();
  background(#088c6f);
}

// Taken from https://gist.github.com/gre/1650294
float easeOutQuint(float t) {
  return t<.5 ? 16*pow(t, 5) : 1 + 16 * pow(t-1, 5);
}

void drawCell(float i, float j, int direction, int next, float amt) {
  pushMatrix();
  translate(i * 35 + 17.5, j * 35 + 17.5);
  float currentDirection = lerp(direction, next, amt);
  float angle = currentDirection * PI * 0.5;

  rotate(angle);

  noFill();
  strokeCap(ROUND);
  strokeWeight(5);
  stroke(#23033c);
  line(-5, -5, 5, 5); 

  popMatrix();
}

void drawBG(float i, float j, int direction, int next, float amt) {
  pushMatrix();
  translate(i * 35 + 17.5, j * 35 + 17.5);
  float currentDirection = lerp(direction, next, amt);

  noStroke();
  fill(lerpColor(#ffe037, #1dcd9f, currentDirection * 0.25));
  rect(0, 0, 32, 32, 4);

  popMatrix();
}

void animation() {  
  // current step or "scene". Each does a different animation.
  int step = frameCount / framesPerStep;
  // current frame in the step, so that we can keep track
  float frameInCurrentStep = frameCount % framesPerStep;
  // the current frame normalized [0, framePerStep] => [0, 1]. Makes it easy to apply easings
  float n = frameInCurrentStep / framesPerStep;
  float t = easeOutQuint(n);

  if (frameInCurrentStep == 0) {
    boolean isLastStep = (step + 1) == (maxFrameNumber / framesPerStep);
    directions = nextDirections;
    if (isLastStep) {
      nextDirections = getDirections(-1);
    } else {
      nextDirections = getDirections(step);
    }
  }
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      drawBG(i, j, directions[i][j], nextDirections[i][j], t);
    }
  }
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      drawCell(i, j, directions[i][j], nextDirections[i][j], t);
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
