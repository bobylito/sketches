/**
Name: <insert name here>
*/

import com.hamoid.*;

VideoExport export;
float frame = 0;
int maxFrameNumber = 100; // The number of frame to record
// width and height are automagically set by size

void setup() {
  size(500, 500);
  pixelDensity(displayDensity());
  noStroke();
  colorMode(HSB, 100);

  // export = new VideoExport(this, "out.mp4");
  // export.startMovie();
}

void draw() {
  // Background reset
  fill(100); // white
  rect(0, 0, width, height);

  // Animation should come here

  // export.saveFrame();

  /*
  if(frame == 0) saveFrame("screenshot-1.png");
  if(frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
  if(frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");
  */
  if (frame++ >= maxFrameNumber) {
    // export.endMovie();
    exit();
  }
}