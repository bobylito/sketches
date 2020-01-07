/**
 Name: <insert name here>
 */

import com.hamoid.*;

VideoExport export;
int frame = 0;
int maxFrameNumber = 360; // The number of frame to record
// width and height are automagically set by size
int background = 0;
int foreground = 100;

void setup() {
  size(500, 500);
  pixelDensity(displayDensity());
  noStroke();
  colorMode(HSB, 100);

  export = new VideoExport(this, "out.mp4");
  export.startMovie();
}


void drawCircle(int x, int y, int angle) {
  pushMatrix();
  translate(x + 25, y + 25);
  rotate(radians(angle));

  fill(foreground);
  circle(0, 0, 40);
  fill(background);
  rectMode(CORNER);
  rect(0, 0, 20, 20);
  popMatrix();
}

void draw() {
  // Background reset
  fill(background);
  rect(0, 0, width, height);

  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      drawCircle(i*50, j*50, frame + (i + 10 * j) * 50);
    }
  }

  export.saveFrame();

  if (frame++ >= maxFrameNumber) {
    export.endMovie();
    exit();
  }
}
