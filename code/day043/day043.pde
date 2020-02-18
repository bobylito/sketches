/**
 Name: Day 43 {- waves
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

int maxFrameNumber = 360; // The number of frame to record

void setup() {
  size(500, 500, P3D);
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
  background(0);
}

float W = 20;
float H = 20;

void animation() {
  float w = width / W;
  float h = height / H;

  PVector center = new PVector(width / 2, height / 2);

  fill(#ffffff);
  stroke(0);

  for (int i = 0; i < W; i++) {
    for (int j = 0; j < H; j++) {
      float x = i * w;
      float y = j * h;
      float d = dist(x, y, center.x, center.y);
      float scale = sin(radians(d - frameCount)) * 1 ;
      pushMatrix();
      translate(0, 0, scale * 5);
      ellipse(x + w * 0.5, y + h * 0.5, w * scale, h * scale);
      popMatrix();
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
