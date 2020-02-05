/**
 * Name: Day 31 :.. Light side
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
int maxFrameNumber = 628; // The number of frame to record
// `width` and `height` are automagically set by size

void setup() {
  size(500, 500, P2D);
  smooth(8);

  // Uncomment next line for high DPI support, makes larger files
  pixelDensity(displayDensity());

  colorMode(HSB, 100);

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(100);
}

float baseRadius = 250;
void animation() {
  blendMode(EXCLUSION);
  strokeWeight(2);
  fill(100);
  translate(width / 2, height / 2);

  beginShape();
  circle(0, 0, baseRadius);

  for (int i = 1; i < 5; i++) {
    float p = pow(2, i);
    translate((baseRadius / p) * sin(frameCount * 0.01 * i), (baseRadius / p) * cos(frameCount * 0.01 * i));
    circle(0, 0, baseRadius / p);
  }
  endShape();
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
