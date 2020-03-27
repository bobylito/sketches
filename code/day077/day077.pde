/**
 * Name: Day 77 \\ amoeba
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 720; // The number of frame to record

color[] p138132 = {
  #ea168e, 
  #612570, 
  #1eafed
};
color getFromPalette(color[] palette, float n) {
  int nbColors = palette.length;
  int startColorIndex = max(0, floor(n * nbColors));
  float amt = (n * nbColors) - startColorIndex; 

  color start = palette[startColorIndex % nbColors];
  color end = palette[(startColorIndex + 1) % nbColors];

  return lerpColor(start, end, amt);
}

void setup() {
  size(700, 700, P2D);
  smooth(8);
  //pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  colorMode(HSB, 100);
  noiseSeed(0);
}

void reset() {
  noStroke();
  for (int i = 0; i < height; i += 2) {
    color bg = color(0, 0, 10 * (i % 4), 100); 
    fill(bg);
    pushMatrix();
    translate(0, i * 2);
    rect(0, 0, width, height);
    popMatrix();
  }
}

void animation() {
  stroke(#eef2f5);
  strokeWeight(0.7);
  noFill();
  translate(width * 0.5, height * 0.5);
  float n = map(frameCount, 0, maxFrameNumber, 0, 1);
  int mod30 = frameCount % 30;
  int mod90 = frameCount % 90;
  if (mod90 == 10 || mod90 == 24) scale(3); 
  if (mod30 > 9 && mod30 < 12) rotate(PI * 0.25 + mod30 * 0.1); 
  if (mod30 > 23 && mod30 < 25) rotate(PI * 0.25 - mod30 * 0.1); 
  beginShape();
  for (int i = 0; i < 30000; i++) {
    float angle = map(i, 0, 30000, 0, PI * 0.5);
    float x = 300 * sin(angle * 3 + radians(50 ));
    float y = 300 * sin(angle * (7 )  + TWO_PI * n);
    float radius = noise((i + frameCount) * 0.05) * 70 + 50;
    vertex(x + radius * cos(i * 0.1)  * cos(radians(i)), y + radius * cos(i * 0.1) * sin(radians(i)));//, radius);
  }
  endShape();
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
