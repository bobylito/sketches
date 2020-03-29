/**
 * Name: Day 79 =-= sign
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 720; // The number of frame to record

color[] p138132 = {
  color(100, 100, 100, 0), #000000, color(100, 100, 100, 0)
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
  color bg = #fefefe; 
  fill(bg);
  pushMatrix();
  rect(0, 0, width, height);
  popMatrix();
}

float freqX = 4;
float freqY = 3;
PVector lissajouPoint(float i) {
  float angle = radians(i);
  float x = 100 * sin(angle * 7 + PI * 0.5) * cos(angle * (freqX));
  float y = 100 * sin(angle * 5) * cos(angle * (freqY));
  return new PVector(x, y);
}

float mainStrain = 0.001;
void animation() {
  noFill();

  translate(width * 0.5, height * 0.5, 350);

  strokeWeight(0.6);
  for (int j = 0; j < 25; j++) {
    int shift = 100 * j;
    beginShape();
    strokeWeight(0.6 + j * 0.1);
    for (int i = 0; i < 100; i++) {
      color c = getFromPalette(p138132, i * 0.02);
      stroke(c);

      if (i % 30 == 1) beginShape();
      float f = frameCount + 0.3 * i;
      float n = f % 360;

      PVector p1 = lissajouPoint(n);

      float dx = noise((p1.x + shift) * 0.01, (p1.y + shift) * 0.01, (p1.z + shift) * mainStrain) * 30;
      float dy = noise((p1.x + shift) * mainStrain, (p1.y + shift) * 0.01, (p1.z + shift) * 0.01) * 30;

      curveVertex(p1.x + dx, p1.y + dy);
      if (i % 30 == 0) endShape();
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
