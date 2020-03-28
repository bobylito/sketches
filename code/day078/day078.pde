/**
 * Name: Day 78 .. constrained
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 360; // The number of frame to record

color[] p138132 = {
  #ea168e, 
  #612570, 
  #1eafed
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
  //pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  colorMode(HSB, 100);
  noiseSeed(0);
}

void reset() {
  noStroke();
  color bg = #000839; 
  fill(bg);
  pushMatrix();
  rect(0, 0, width, height);
  popMatrix();
}

float freqX = 4;
float freqY = 3;
PVector lissajouPoint(float i) {
  float angle = radians(i);
  float x = 50 * sin(angle * 7 + PI * 0.5) * cos(angle * (freqX));
  float y = 50 * sin(angle * 5) * cos(angle * (freqY));
  float z = 50 * sin(angle * 2) * cos(angle * (freqY));
  return new PVector(x, y, z);
}

void animation() {
  stroke(#eef2f5);
  strokeWeight(2);
  noFill();

  float n0 = map(frameCount, 0, maxFrameNumber, 0, 1);

  translate(width * 0.5, height * 0.5, 350);

  pushMatrix();
  rotateZ(n0 * TWO_PI);
  rotateY(n0 * TWO_PI);

  box(150);
  popMatrix();

  pushMatrix();
  rotateY(-n0 * TWO_PI);
  rotateX(-n0 * TWO_PI);
  
  strokeWeight(4);

  beginShape();
  for (int i = 0; i < 100; i++) {
    float f = frameCount + 2 * i;
    float n = f % 360;

    PVector p1 = lissajouPoint(n);

    curveVertex(p1.x, p1.y, p1.z);
  }
  endShape();

  popMatrix();
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
