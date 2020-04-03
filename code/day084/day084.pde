/**
 * Name: Day 84 "" dancing
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

void setup() {
  size(720, 720, P2D);
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
  background(255);
}

color strawberry = #f35588;
color aqua = #05dfd7;
color lemon = #fff591;
color green = #a3f7bf;

float distDiagonalFromCenter = dist(0, 0, 360, 360);
void animation() {
  translate(width * 0.5, height * 0.5);
  float n = frameCount / maxFrameNumber;
  for (int i = -10; i < 10; i++) {
    for (int j = -10; j < 10; j++) {
      float x = 18 + i * 36;
      float y = 18 + j * 36;

      float shift = (dist(0, 0, x, y) / distDiagonalFromCenter); 

      color c0 = lerpColor(strawberry, lemon, (x + 0.5 * width) / width);
      color c1 = lerpColor(aqua, green, (x  + 0.5 * width)/ width);
      color c = lerpColor(c0, c1, (y + 0.5 * height) / height);

      fill(c);

      float scale = (noise(x * 0.1, y * 0.1, n * 30));
      ellipse(x, y, 36 * scale, 36 * scale);
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
