/**
 Name: Day 16 .: 
 */

import com.hamoid.*;

VideoExport export;
float frame = 0;
int maxFrameNumber = 144; // The number of frame to record
// width and height are automagically set by size

void setup() {
  size(500, 500);
  colorMode(HSB, 100);

  export = new VideoExport(this, "out.mp4");
  export.setFrameRate(60);
  export.startMovie();
}

void drawSingleDedale(int x, int y) {
  vertex(x + 0, y + 0);
  vertex(x + 27, y + 0);
  vertex(x + 27, y + 22);
  vertex(x + 18, y + 22);
  vertex(x + 18, y + 8);
  vertex(x + 8, y + 8);
  vertex(x + 8, y + 30);
  vertex(x + 36, y + 30);
}

void draw() {
  // Background reset
  noStroke();
  background(#284177); // white

  noFill();
  stroke( #EDE8E4);
  strokeCap(PROJECT);

  strokeWeight(3);
  for (int j = 0; j < 20; j++) {
    beginShape();
    for (int i = -10; i < 20; i++) {
      if (j % 2 == 0) drawSingleDedale(int(frame) - 144 + i * 36, j* 38);
      else if (j % 2 == 1) drawSingleDedale(int(-frame) + 144 + i * 36, j* 38);
      //else drawSingleDedale( i * 36, j* 38);
    }
    endShape();
  }

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
