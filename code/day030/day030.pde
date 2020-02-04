/**
 Name: <insert name here>
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

  //colorMode(HSB, 100);

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

PVector getPoint(float i, float size) {
  float H = size;
  float W = size;
  float f = frameCount + size;
  return new PVector(
    H
    * cos(TWO_PI * i / 100.0)
    * cos(TWO_PI * i / 100.0 + f * .05)
    , 
    W
    * sin(TWO_PI * i / 100.0)
    * sin(TWO_PI * i / 100.0 + f * 0.02)
    );
}

void drawShape(float size) {
  beginShape();
  PVector p0 = getPoint(0.0, size);
  curveVertex(p0.x, p0.y);
  for (float i = 0.0; i <= 101.0; i++ ) {
    PVector p = getPoint(i, size);
    curveVertex(p.x, p.y);
  }
  endShape();
}

color[] colors = {
  color(221, 41, 32), 
  color(0, 94, 157), 
  color(237, 219, 109), 
  color(3, 14, 11), 
  color(253, 252, 253)
};

void animation() {
  // noFill();
  strokeWeight(5);
  translate(width/ 2, height / 2);
  for (int i = 0; i < 4; i ++) {
    stroke(colors[i]);
    fill(colors[4]);
    drawShape(100.0 + i * 60);
  }
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
