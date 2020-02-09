/**
 Name: Day 34 <*> Compass
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
float maxFrameNumber = 500; // The number of frame to record
// `width` and `height` are automagically set by size

void setup() {
  size(500, 500, P2D);
  smooth(8);

  // Uncomment next line for high DPI support, makes larger files
  pixelDensity(displayDensity());

  rectMode(RADIUS);
  // colorMode(HSB, 100);

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(#ededed);
}

float cols = 10;
float rows = 10;

void drawOrientGrid(PVector p) {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      PVector currentP = new PVector(
        i * width / cols + width / (cols * 2), 
        j * height / rows + height / (rows * 2)
        );
      float normD = currentP.dist(p) / 250;
      fill(lerpColor(#ff5151, #ffa41b, normD));
      pushMatrix();
      translate(currentP.x, currentP.y);
      if (currentP.x < width / 2) rotate(PI/ 2 * max(-1, -(normD * normD * normD)) + PI / 2);
      if (currentP.x > width / 2) rotate(PI/ 2 * min(1, (normD * normD * normD)) + PI / 2);
      rect(0, 0, width / (cols * 3), height / (rows * 3));
      popMatrix();
    }
  }
}

void animation() {
  PVector p = new PVector(
    width / 2, 
    lerp(height * -0.5, height * 1.5, frameCount / maxFrameNumber)
    );
  // fill(#9818d6);
  // circle(p.x, p.y, 10);
  drawOrientGrid(p);
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frame == 0) saveFrame("screenshot-1.png");
    if (frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
    if (frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");
  }

  if (frame++ >= maxFrameNumber) {
    if (isReadyForExport) {
      export.endMovie();
    }
    exit();
  }
}
