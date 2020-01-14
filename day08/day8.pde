/**
 Name: Day8 \\ better days ahead
 */

import com.hamoid.*;

VideoExport export;
float frame = 0;
float maxFrameNumber = 500; // The number of frame to record
// width and height are automagically set by size

void setup() {
  size(500, 500);
  pixelDensity(displayDensity());
  noStroke();
  colorMode(HSB, 100);

  export = new VideoExport(this, "out.mp4");
  export.startMovie();
}

void drawEllipse(int x, int y, float angleValue, float scaleValue) {
  pushMatrix();
  translate(x, y);
  rectMode(CENTER);
  fill(100); // white
  blendMode(SUBTRACT);
  rect(0, 0, 250, 250);
  blendMode(BLEND);
  scale(scaleValue);
  rotate(radians(angleValue));
  rect(0, 0, 250, 250);
  popMatrix();
}

float angleValue = 0;
float scaleValue = 1;

void draw() {
  // Background reset
  blendMode(BLEND);
  fill(100); // white
  rect(0, 0, width, height);

  // Animation should come here


  if (frame < 180) scaleValue -= 1 / maxFrameNumber;
  if (frame >= 180 && frame < 270) {
    angleValue += 1;
  }
  if (frame >= 270) {
    scaleValue += 1 / maxFrameNumber;
  }

  drawEllipse(0, 0, angleValue, scaleValue);
  drawEllipse(width / 2, 0, angleValue, scaleValue);
  drawEllipse(width, 0, angleValue, scaleValue);

  drawEllipse(0, height / 2, angleValue, scaleValue);
  drawEllipse(width / 2, height / 2, angleValue, scaleValue);
  drawEllipse(width, height / 2, angleValue, scaleValue);

  drawEllipse(0, height, angleValue, scaleValue);
  drawEllipse(width / 2, height, angleValue, scaleValue);
  drawEllipse(width, height, angleValue, scaleValue);

  export.saveFrame();


  if (frame == 10) saveFrame("screenshot-1.png");
  if (frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
  if (frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");

  if (frame++ >= maxFrameNumber) {
    export.endMovie();
    exit();
  }
}
