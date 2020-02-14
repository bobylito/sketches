/**
Name: <insert name here>
 */

import com.hamoid.*;

boolean isReadyForExport = false;

VideoExport export;

int maxFrameNumber = 600; // The number of frame to record

void setup() {
  size(500, 500, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if(isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(255);
}

void animation() {
}

void draw() {
  reset();
  animation();

  if(isReadyForExport) {
    export.saveFrame();
    if(frameCount == 1) saveFrame("screenshot-1.png");
    if(frameCount == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
    if(frameCount == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");
  }

  if (frameCount >= maxFrameNumber) {
    if(isReadyForExport) {
      export.endMovie();
    }
    exit();
  }
}
