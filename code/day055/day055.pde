/**
 Name: day 55 : better done
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 360; // The number of frame to record

void setup() {
  size(1000, 1000, P2D);
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

void animation() {
  fill(0);
  translate(width * 0.5, height * 0.5);
  circle(0, 0, 600);
  fill(255);
  randomSeed(0);

  float n = frameCount / maxFrameNumber;
  float t = n <.5 ? 16*n*n*n*n*n : 1+16*(--n)*n*n*n*n;

  for (int i = 0; i < 5; i++) {
    float originAngle = TWO_PI * i * 0.2;
    circle(
      350 * cos(originAngle + t * TWO_PI), 
      350 * sin(originAngle + t * TWO_PI), 
      250);
    circle(
      350 * cos(originAngle) + 350 * cos(originAngle + max(0, t - 0.2) * PI + PI), 
      350 * sin(originAngle) + 350 * sin(originAngle + max(0, t - 0.2) * PI + PI), 
      100);
  }

  float rad = 1 + pow((max(0, (frameCount / maxFrameNumber) - 0.7) * 5) - 1, 5);
  circle(
    0, 
    0,
    100 * rad);
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
