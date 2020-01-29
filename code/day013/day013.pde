/**
 Name: Day13 .> funkaleidoscope
 */

import com.hamoid.*;

VideoExport export;
float frame = 0;
int maxFrameNumber = 720; // The number of frame to record
// width and height are automagically set by size

PImage original;
PImage cutout;
PGraphics mask;

PImage createFirst(int x, int y) {  
  mask.beginDraw();
  mask.background(0);
  mask.fill(255);
  mask.scale(2);
  mask.triangle(0, 0, 100, 173.2, 200, 0);
  mask.endDraw();

  cutout = original.get(x, y, width, height);
  cutout.mask(mask);
  return cutout;
}

void drawKaleidoscope(PImage triangle, int x, int y) {
  pushMatrix();
  translate(x, y);
  for (int i = 0; i < 6; i++) {
    image(triangle, 20, 0);
    rotate(radians(60));
  }

  popMatrix();
}

void setup() {
  size(500, 500, P2D);
  noStroke();
  colorMode(HSB, 100);
  original = loadImage("nature.jpg");
  mask = createGraphics(width, height);
  noiseSeed(0);

  export = new VideoExport(this, "out.mp4");
  export.setFrameRate(60);
  export.startMovie();
}

void draw() {
  // Background reset
  background(0);

  // Animation should come here
  PImage triangle = createFirst(int(sin(radians(frame / 2)) * 500 + 500), int(cos(radians(frame / 2)) * 500 + 500));
  drawKaleidoscope(triangle, 250, 250);

  export.saveFrame();


  if (frame == 0) saveFrame("screenshot-1.png");
  if (frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
  if (frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");

  if (frame++ >= maxFrameNumber) {
    export.endMovie();
    exit();
  }
}
