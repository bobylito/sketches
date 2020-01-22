/**
Name: <insert name here>
*/

import com.hamoid.*;

VideoExport export;
float frame = 0;
int maxFrameNumber = 500; // The number of frame to record
// `width` and `height` are automagically set by size

void setup() {
  size(500, 500);

  // Uncomment next line for high DPI support, makes larger files
  // pixelDensity(displayDensity());

  colorMode(HSB, 100);

  // export = new VideoExport(this, "out.mp4");
  // export.startMovie();
}

void draw() {
  noStroke();
  background(100);

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
