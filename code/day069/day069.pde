/**
 Name: Day 69 %% clock is ticking
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 400; // The number of frame to record

void setup() {
  size(700, 700, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(#fffdf9);
}

color[] p45 = {
  #f76a8c, 
  #f8dc88, 
  #f8fab8, 
  #ccf0e1
};
color getFromPalette(color[] palette, float n) {
  int nbColors = palette.length;
  int startColorIndex = max(0, floor(n * nbColors));
  float amt = (n * nbColors) - startColorIndex; 

  color start = palette[startColorIndex % nbColors];
  color end = palette[(startColorIndex + 1) % nbColors];

  return lerpColor(start, end, amt);
}

float margin = 100;
float items = 5;
float h = (700 - 2 * margin) / items;
float halfH = h / 2;
float stripes = 70;
void animation() {
  stroke(0);
  pushMatrix();
  translate(width * 0.5, height * 0.5);
  rotate(PI / 3);
  for (int i = 0; i < stripes; i++) {
    float x = -width * .5 + i * 10;
    strokeWeight(5);
    line(x, 0, x, height * 2);
  }
  popMatrix();

  for (int i = 0; i < items; i++) {
    for (int j = 0; j < items; j++) {
      ellipse(margin + h * i + halfH, margin + h * j + halfH, h - 10, h - 10);
      fill(getFromPalette(p45, (i + 5 * j) / 24.0));
      arc(margin + h * i + halfH, margin + h * j + halfH, h - 10, h - 10, 0, TWO_PI * frameCount / maxFrameNumber * 2);
      fill(255);
      arc(margin + h * i + halfH, margin + h * j + halfH, h - 10, h - 10, 0, -TWO_PI + TWO_PI * frameCount / maxFrameNumber * 2);
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
