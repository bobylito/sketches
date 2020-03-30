/**
 * Name: Day 80 oOo golden
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 720; // The number of frame to record

void setup() {
  size(700, 700, P3D);
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
  background(#4a4a4a);
}

PVector lissajouPoint(float i, float freqX, float freqY) {
  float angle = radians(i);
  float x = TWO_PI * sin(angle * 7 + PI * 0.5) * cos(angle * (freqX));
  float y = TWO_PI * sin(angle * 5) * cos(angle * (freqY));
  return new PVector(x, y);
}

float nRadius = 250;
void animation() {
  lights();
  translate(width * 0.5, height * 0.5);
  rotateY(TWO_PI * frameCount / maxFrameNumber);
  rotateX(-PI * 0.5);

  noFill();
  strokeWeight(2);
  for (int j = 1; j < 9; j++) {
    beginShape();
    for (int i = 0; i < 50; i++) {
      stroke(#ffcd38);

      float f = frameCount + 0.5 * i + j * 4;
      float n = f % maxFrameNumber;

      PVector p1 = lissajouPoint(n, 8 - j, j);
      float radius = nRadius;

      curveVertex(radius * cos(p1.x) * cos(p1.y), radius * sin(p1.x) * cos(p1.y), radius * sin(p1.y));
    }
    endShape();
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
