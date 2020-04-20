/**
 * Name: <insert name here>
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

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

  ellipseMode(CENTER);
}

void reset() {
  noStroke();
  background(255);
}

void renderCircle(int d, PVector p, float r, float a, float n) {
  if (d < 0) return;
  stroke(0);
  noFill();
  circle(p.x, p.y, 2 * r);

  PVector newP = new PVector(p.x + r * cos(a * sin(n * TWO_PI)), p.y + r * sin(a *  sin(n * TWO_PI)));

  line(p.x, p.y, newP.x, newP.y);

  fill(0);
  noStroke();
  circle(newP.x, newP.y, 5);

  renderCircle(d - 1, newP, r * 1.1, a + PI * 0.1, pow(n, 1.05));
}

float easeInOutQuad(float t) {
  return t<.5 ?
    2*t*t :
    -1+(4-2*t)*t;
}

void animation() {
  float n = frameCount / maxFrameNumber;
  float nEased = easeInOutQuad(n);

  translate(width * .5, height * .5);

  for (int i = 0; i < 20; i++) {
    rotate(PI * 0.1);
    renderCircle(20, new PVector(0, 0), 10, PI * 0.5, nEased);
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
