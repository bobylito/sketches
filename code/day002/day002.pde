/**
 Name: <insert name here>
 */

import com.hamoid.*;

VideoExport export;
int frame = 0;
int maxFrameNumber = 141; // The number of frame to record
// width and height are automagically set by size

void setup() {
  size(500, 500);
  noStroke();
  colorMode(HSB, 100);

  export = new VideoExport(this, "out.mp4");
  export.startMovie();
}

void draw() {
  // Background reset
  fill(frame < 71 ? 100 : 0); // white
  rect(0, 0, width, height);

  // Animation should come here
  fill(frame < 71 ? 0 : 100);

  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      circle(50 * i + 25, 50 * j + 25, frame % 71);
    }
  }

  export.saveFrame(); //<>//

  if (frame == 20) saveFrame("screenshot-1.png");
  if (frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
  if (frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");

  if (frame++ >= maxFrameNumber) {
    export.endMovie();
    exit();
  }
}
