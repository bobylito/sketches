/**
 Name: Day 47 ø checkered
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 360; // The number of frame to record

void setup() {
  size(1000, 1000, P2D);
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
  background(255);
}

float rows = 10;
float cols = 10;
void animation() {
  float w = width / cols;
  float h = height / rows;
  PVector center = new PVector(height / 2, width / 2);
  stroke(0);
  strokeWeight(8);
  strokeJoin(ROUND);
  strokeCap(ROUND);

  for (int i = -1; i <= rows; i++) {
    for (int j = -1; j <= cols; j++) {
      PVector left = new PVector(j * w, (i + 0.5) * h);
      PVector bottom = new PVector((j + 0.5) * w, (i + 1) * h);
      PVector right = new PVector((j + 1) * w, (i + 0.5) * h);
      PVector top = new PVector((j + 0.5) * w, i * h);

      float scale =  cos(radians(frameCount)) * 0.05 - 0.05;
      float[] ds = {
        dist(left.x, 0, center.x, 0)   * ( left.x < center.x ? 1 : -1) * scale, 
        dist(0, bottom.y, 0, center.y) * ( bottom.y < center.y ? 1 : -1) * scale, 
        dist(right.x, 0, center.x, 0)  * ( right.x < center.x ? 1 : -1) * scale, 
        dist(0, top.y, 0, center.y)    * (top.y < center.y? 1: -1) * scale, 

        dist(j * w, i * h, center.x, center.y) / 707 * cos(radians(frameCount))// normed distance to center 
      };

      color c = ((i + j % 2) % 2) == 0 ?
        lerpColor(#e8f9e9, #baf1a1, ds[4]) :
        lerpColor(#f688bb, #fe346e, ds[4]);
      fill(c);

      pushMatrix();
      translate(j * w, i * h);
      beginShape();
      vertex(0, 0);
      vertex(ds[0], h/2);
      vertex(0, h);
      vertex(w / 2, h + ds[1]);
      vertex(w, h);
      vertex(w + ds[2], h / 2);
      vertex(w, 0);
      vertex(w/2, ds[3]);
      vertex(0, 0);
      endShape();
      popMatrix();
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
