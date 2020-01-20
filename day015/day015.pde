/**
 Name: Day 15 o/ scales
 */

import com.hamoid.*;

VideoExport export;
float frame = 0;
int maxFrameNumber = 200; // The number of frame to record
// width and height are automagically set by size

void setup() {
  size(500, 500, P2D);
  colorMode(HSB, 100);
  ellipseMode(CENTER);

  export = new VideoExport(this, "out.mp4");
  export.startMovie();
}

color skyBlue = #edf7fa;
color darkBlue = #eff9fc;

void drawTile(float x, float y, float darkness) {
  fill(lerpColor(darkBlue, skyBlue, darkness));
  stroke(100);
  strokeWeight(3);
  //pushMatrix();
  //translate(x, y);
  circle(x, y, 50);
  //popMatrix();
}

void draw() {
  // Background reset
  noStroke();
  background(100); // white

  for (int j = -1; j < 21; j++) {
    for (int i = 0; i < 13; i++) {
      boolean isEvenRow = j % 2 == 0;
      float currentPushedRow = (-0.08 * i) + 21 * (max(frame - 50, -20) / 100);
      println(currentPushedRow);
      float distCurrentPushedRow = dist(0, float(j), 0, currentPushedRow);

      drawTile(i * 50 - (isEvenRow ? 25 : 50), j * 25 + constrain(distCurrentPushedRow, 0, 2) * 10, constrain(distCurrentPushedRow, 0, 1));
    }
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
