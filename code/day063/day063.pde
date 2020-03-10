/**
 * Name: Day 63  [\] worm
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

void setup() {
  size(500, 500, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  noiseSeed(1000);
}

void reset() {
  noStroke();
  background(0);
}


void animation() {
  translate(width / 2, height / 2);

  //float t = sin(frameCount / maxFrameNumber * TWO_PI) * 400;

  PVector p = new PVector(0, 0);
  for (int i = 1001; i > 1; i--) {
    color f = i % 2 == 0 ? #ffffff : #000000;
    fill(f);

    circle(p.x, p.y, cos(i * 70) * 50);

    float angle = noise(((i + frameCount) % maxFrameNumber) * 0.002) * PI * 10;
    float l = 2;

    p.add(l * cos(angle), l * sin(angle));
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
