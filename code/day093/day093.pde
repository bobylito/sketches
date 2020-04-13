/**
 * Name: Day 93 -> hide and seek
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 1440; // The number of frame to record

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

  rectMode(CENTER);
}

void reset() {
  noStroke();
  background(bg);
}

float freqX = 3;
float freqY = 4;
PVector lissajouPoint(float angle) {
  float x = 300 * sin(angle * 5) * cos(angle * (freqX));
  float y = 300 * sin(angle * 7) * cos(angle * (freqY));
  return new PVector(x, y);
}

PVector getPoint(int step, float t) {
  float angle = (step + t) * TWO_PI / (steps);
  return lissajouPoint(angle);
}

// Taken from https://gist.github.com/gre/1650294
float easeOutQuint(float t) {
  return t<.5 ? 16*pow(t, 5) : 1 + 16 * pow(t-1, 5);
}
float steps = 8;
int framesPerStep = floor(maxFrameNumber / steps);
PVector point = new PVector(0, 0);
float segmentLength = 250;
color bg = #000000;
color[] colors = {
  #fe019a, 
  #d1adf2, 
  #8bffff, 
  #00faac, 
  #7cfbad, 
  #c5fed7, 
  #fffdaf, 
  bg
};

void drawCircles(float frame) {
  // current step or "scene". Each does a different animation.
  int step = (int(frame) / framesPerStep);
  // current frame in the step, so that we can keep track
  float frameInCurrentStep = frame % framesPerStep;

  int nbColors = colors.length;
  for (int i = 0; i < nbColors; i++) {
    float n = constrain(frameInCurrentStep - (nbColors - i) * 3, 0, framesPerStep - nbColors * 3) / (framesPerStep - nbColors * 3);
    float t = easeOutQuint(n);
    PVector p = getPoint(step, t);
    if(i == nbColors - 1) {
      noStroke();
      //fill(colors[i]);
    }
    else {
      noFill();
      strokeWeight(2);
      stroke(colors[i]);
    }
      
    square(p.x, p.y, 50 + i * 10);
  }
}

void animation() {
  translate(width * 0.5, height * 0.5);
  for (int i = 0; i < 5; i++) {
    drawCircles((300 + frameCount + 200 * i));
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
