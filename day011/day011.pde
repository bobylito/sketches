/**
 Name: Day11
 */

import com.hamoid.*;

VideoExport export;
float frame = 0;
int maxFrameNumber = 62; // The number of frame to record
// width and height are automagically set by size

PImage photo;
PImage photo2;
PGraphics mask0;

PImage[] croppedPhotos = new PImage[8];

void setup() {
  size(500, 500, P2D);
  noStroke();
  colorMode(HSB, 100);

  photo = loadImage("skyscrapper.jpeg");

  photo2 = createImage(500, 500, RGB);
  photo2.set(0, 0, photo);

  mask0 = createGraphics(photo.width, photo.height, P2D);

  for (int i=0; i < croppedPhotos.length; i++) {
    mask0.beginDraw();
    mask0.background(0);
    mask0.fill(255);
    mask0.circle(250, 250, 100 + 50 * i);
    mask0.endDraw();
    croppedPhotos[i] = loadImage("skyscrapper.jpeg");
    croppedPhotos[i].mask(mask0.get());
  }

  export = new VideoExport(this, "out.mp4");
  export.startMovie();
}

void draw() {
  // Background reset
  fill(100); // white
  rect(0, 0, width, height);
  //image(photo, 0, 0);

  imageMode(CORNER);
  image(photo2, 0, 0);

  pushMatrix();
  imageMode(CENTER);
  translate(250, 250);
  for (int i = croppedPhotos.length - 1; i >=0; i--) {
    rotate(radians(sin(frame / 10) * PI));
    image(croppedPhotos[i], 0, 0);
  }
  popMatrix();

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
