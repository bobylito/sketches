/**
Name: <insert name here>
 */

import com.hamoid.*;

boolean isReadyForExport = false;

VideoExport export;
float frame = 0;
int maxFrameNumber = 500; // The number of frame to record
// `width` and `height` are automagically set by size

void setup() {
  size(500, 500);

  // Uncomment next line for high DPI support, makes larger files
  // pixelDensity(displayDensity());

  colorMode(HSB, 100);

  if(isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(100);
}

void animation() {
}

void draw() {
  reset();
  animation();

  if(isReadyForExport) {
    export.saveFrame();
    if(frame == 0) saveFrame("screenshot-1.png");
    if(frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
    if(frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");
  }

  if (frame++ >= maxFrameNumber) {
    if(isReadyForExport) {
      export.endMovie();
    }
    exit();
  }
}
