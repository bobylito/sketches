/**
 Name: Day 17 ][ hectic
 */

import com.hamoid.*;

VideoExport export;
float frame = 0;
int maxFrameNumber = 300; // The number of frame to record
// `width` and `height` are automagically set by size

void setup() {
  size(500, 500);

  // Uncomment next line for high DPI support, makes larger files
  pixelDensity(displayDensity());

  colorMode(HSB, 100);

  export = new VideoExport(this, "out.mp4");
  export.setFrameRate(60);
  export.startMovie();
}



void draw() {
  noStroke();
  background(0);

  translate(250, 250);
  scale((sin(PI * frame / maxFrameNumber) + 2) / 2);

  // Animation should come here
  blendMode(SCREEN);

  stroke(33, 100, 90, 100);
  strokeWeight(10);
  noFill();
  circle( noise(frame) * 10, noise(frame * 10) * 10, 150);

  stroke(66, 100, 90, 100);
  strokeWeight(10);
  noFill();
  circle(noise(frame * 20) * 10, noise(frame * 30) * 10, 150);

  stroke(0, 100, 90, 100);
  strokeWeight(10);
  noFill();
  circle(noise(frame * 40) * 10, noise(frame * 50) * 10, 150);

  export.saveFrame();

  if (frame == 0) saveFrame("screenshot-1.png");
  if (frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
  if (frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");


  if (frame++ >= maxFrameNumber) {
    export.endMovie();
    exit();
  }
}
