/**
 Name: Day 7
 */

import com.hamoid.*;

VideoExport export;
float frame = 0;
int maxFrameNumber = 703; // The number of frame to record
// width and height are automagically set by size

void setup() {
  size(500, 500);
  pixelDensity(displayDensity());
  noStroke();
  colorMode(HSB, 100);

  export = new VideoExport(this, "out.mp4");
  export.startMovie();
}

color colorA = #ffffff;
color colorB = #555555;

void drawElipse(float angle, float n) {
  pushMatrix();
  translate(width / 2, height / 2);
  rotate(radians(angle));
  stroke(lerpColor(colorA, colorB, n / 15));
  noFill();
  ellipseMode(CENTER);
  ellipse(0, 0, 150 + 30 * n, 30 + 50 * n);
  popMatrix();
}

void draw() {
  // Background reset
  noStroke();
  fill(0, 0, 0, frame == 0 ? 100 : 30);
  rect(0, 0, width, height);

  // Animation should come here

  for (int n = 0; n < 15; n++) {
    float f2 = max(frame - n * 30, 0); // delay
    // 4.71: min value at 3pi/2
    // 360: remap to full circle
    float angle = f2 < 283 ? - (sin(f2 / 60) * f2 / 60) / 4.71 * 360 : 0;
    drawElipse(angle, n);
  }

  if(frame == 0) saveFrame("screenshot-1.png");
  if(frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
  if(frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");
  export.saveFrame();

  if (frame++ >= maxFrameNumber) {
    export.endMovie();
    exit();
  }
}
