/**
 * Name: Day 95 @@ quicksand
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 1500; // The number of frame to record

void setup() {
  size(700, 700, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  ellipseMode(RADIUS);
}

void reset() {
  noStroke();
  background(#30475e);
}

float easeOutQuint(float t) {
  return t < .5 ? 2*t*t : -1+(4-2*t)*t;
}

void recurCircle(int r, float n, PVector center, float radius) {
  if (r == 0) return;
  fill(r % 2 ==0 ? #f2a365 : #30475e);

  circle(center.x, center.y, radius);

  recurCircle(
    r - 1, 
    n * 1.5, 
    new PVector(center.x + 0.2 * radius * cos(n * TWO_PI + PI * 0.5), center.y + 0.2 * radius * sin(n * TWO_PI+ PI * 0.5)), 
    0.8 * radius
    );
}

void animation() {
  float n = frameCount / (maxFrameNumber);
  float t = easeOutQuint(n);
  float t2 = sin( sin(t * TWO_PI) * PI * 0.1);
  noFill();
  strokeWeight(2);
  // stroke(#cf7500);
  translate(width * 0.5, height * 0.5);

  recurCircle(8, t2, new PVector(0, 0), 300);
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
