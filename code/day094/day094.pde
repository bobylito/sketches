/**
 * Name: Day 94 |> Omen
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 300; // The number of frame to record

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
  background(#30475e);
}
// Taken from https://gist.github.com/gre/1650294
float easeOutQuint(float t) {
  return t<.5 ? 16*pow(t, 5) : 1 + 16 * pow(t-1, 5);
}
void animation() {
  float n = frameCount / maxFrameNumber;
  float t = easeOutQuint(n);

  noFill();
  strokeWeight(2);
  translate(width * 0.5, height * 0.5);
  stroke(#f2a365);
  
  for (int i = 0; i < 10; i++) {
    float r = 50 + 20 * i;
    beginShape();
    for (int j = 0; j < 100; j++) {
      float a = map(
        j,
        0,
        99,
        max(TWO_PI - t * TWO_PI * (10 - i), 0),
        min(TWO_PI,  t * TWO_PI * (10 - i))
        );
      vertex(r * cos(a), r * sin(a));
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
