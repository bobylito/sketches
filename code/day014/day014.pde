/**
 Name: Day 14 |} 
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
  mask.scale(1);
  mask.triangle(0, 0, 100, 172, 198, 1);
  mask.endDraw();

  cutout = original.get(x, y, width, height);
  cutout.mask(mask);
  return cutout;
}

void drawKaleidoscope(PImage triangle, int x, int y) {
  pushMatrix();
  translate(x, y);
  for (int i = 0; i < 6; i++) {
    pushMatrix();
    rotate(radians(60 * i));
    translate(-3, -3);
    image(triangle, 0, 0);
    popMatrix();
  }

  popMatrix();
}



void setup() {
  size(500, 500, P2D);
  noStroke();
  colorMode(HSB, 100);
  original = loadImage("sunset.jpg");
  mask = createGraphics(width, height);
  noiseSeed(0);

  export = new VideoExport(this, "out.mp4");
  export.setFrameRate(60);
  export.startMovie();
}

void draw() {
  // Background reset
  background(100); // white

  PImage triangle = createFirst(int(sin(radians(frame / 2)) * 750 + 2000), int(cos(radians(frame / 2)) * 400 + 1200));
  drawKaleidoscope(triangle, 250, 250);
  drawKaleidoscope(triangle, 250, -86);
  drawKaleidoscope(triangle, 250, 586);
  drawKaleidoscope(triangle, -40, 82);
  drawKaleidoscope(triangle, -40, 418);
  drawKaleidoscope(triangle, 540, 82);
  drawKaleidoscope(triangle, 540, 418);

  // Animation should come here

  export.saveFrame();


  if (frame == 0) saveFrame("screenshot-1.png");
  if (frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
  if (frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");

  if (frame++ >= maxFrameNumber) {
    export.endMovie();
    exit();
  }
}
