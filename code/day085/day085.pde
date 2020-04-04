/**
 * Name: Day 85 \\ threat
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

void setup() {
  size(720, 720, P3D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
  
  randomSeed(0);
}

void reset() {
  noStroke();
  boolean flash = random(1) < 0.2;
  background(flash ? #323232 :  #000000);
  if(flash) {
    scale(1.1);
    rotateX(0.1);
  }
  
}

PVector lissajouPoint(float i, float freqX, float freqY) {
  float angle = radians(i);
  float x = sin(angle * 7 + PI * 0.5) * cos(angle * (freqX));
  float y = sin(angle * 5) * cos(angle * (freqY));
  return new PVector(x, y);
}

float nbStep = 100;
float lissajouStepLength = 360 / nbStep;
PVector center = new PVector(0,0,0);
void animation() {
  float n = frameCount / maxFrameNumber;

  // Data
  ArrayList<PVector> points = new ArrayList<PVector>();
  for (int a = 0; a < 5; a++) { 
    for (int b = 0; b < 5; b++) {
      PVector direction = new PVector(a * 0.2 * TWO_PI, b * 0.2 * TWO_PI);
      PVector currentP = new PVector(0, 0, 0);
      points.add(currentP);

      for (int i = 0; i < 100; i++) {
        float iPrime = ((100 - i) * lissajouStepLength + frameCount) % 360;
        PVector move = lissajouPoint(iPrime, 2, 4).mult(PI * 0.2).add(direction);

        PVector pSphere = new PVector(
          currentP.x + 10 * cos(move.x) * cos(move.y), 
          currentP.y + 10 * sin(move.x) * cos(move.y), 
          currentP.z + 10 * sin(move.y)
          );
        currentP = pSphere;
        points.add(pSphere);
      }
    }
  }

  // Rendering
  stroke(0);
  strokeWeight(0.5);
  noFill();
  translate(width * 0.5, height * 0.5, 400);
  rotateY(n*TWO_PI + PI * 0.5);

  for (int i = 0; i < points.size() - 1; i++) {
    for (int j = (i + 1); j < points.size(); j++) { 
      PVector p1 = points.get(i);
      PVector p2 = points.get(j);
      float d = p1.dist(p2);
      if (d < 40 && d > 30) {
        float dc = p1.dist(center);
        color c = lerpColor(#ff1e56, #ffac41, dc / 80.0);
        stroke(c);
        line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
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
