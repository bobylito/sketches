/**
 * Name: Day 83 \v/ blooming
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
  background(255);
}

PVector lissajouPoint(float i, float freqX, float freqY) {
  float angle = radians(i);
  float x = TWO_PI * sin(angle * 7 + PI * 0.5) * cos(angle * (freqX));
  float y = TWO_PI * sin(angle * 5) * cos(angle * (freqY));
  return new PVector(x, y);
}

void animation() {
  lights();
  float n2 = frameCount / maxFrameNumber;

  noFill();

  float nRadius = 150;

  float angleY = TWO_PI * n2;

  translate(width * 0.5, height * 0.5);
  rotateY(angleY);

  ArrayList<PVector> points = new ArrayList<PVector>();
  stroke(0, 0, 0, 200);
  strokeWeight(0.5);
  fill(250, 80, 80);

  for (int j = 1; j < 10; j++) {
    beginShape(TRIANGLE_STRIP);

    for (int i = 0; i < 5; i++) {
      float f = (i + j) * sin(n2 * PI);

      PVector p1 = lissajouPoint(f, 10 - j, j + 5);
      float radius = (1 + noise(i, j)) * nRadius;

      PVector pSphere = new PVector(radius * cos(p1.x) * cos(p1.y), radius * sin(p1.x) * cos(p1.y), radius * sin(p1.y));
      points.add(pSphere);
      vertex(pSphere.x, pSphere.y, pSphere.z);
      vertex(0,0,0);
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
