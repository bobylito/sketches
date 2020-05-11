/**
 * Name: Day 110 --- scratch that
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

void setup() {
  size(700, 700, P2D);
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

void drawLines(PVector position, PVector direction, float nFrame, float l) {

  PVector end = new PVector(
      position.x + direction.x * min(nFrame, 0.3) * l,
      position.y + direction.y * min(nFrame, 0.3) * l
      );

  PVector start = new PVector(
    position.x + direction.x * max(nFrame - 0.3 , 0) * l,
    position.y + direction.y * max(nFrame - 0.3 , 0) * l
  );

  if(nFrame < 0.6) {
    line(start.x, start.y, end.x, end.y);
  }

  if(nFrame > 0.3) {
    drawLines(end, new PVector(direction.x, direction.y).rotate(PI * 0.3), (nFrame - 0.3), l * 0.8);
    drawLines(end, new PVector(direction.x, direction.y).rotate(-PI * 0.3), (nFrame - 0.3), l * 0.8);
  }
}

color pink = #ff427f;

void animation() {
  translate(width * .5, height * 0.5);

  float nFrame = frameCount / (maxFrameNumber);

  stroke(red(pink), green(pink), blue(pink), 255 * (1 - nFrame));
  strokeWeight(4 - 3 * nFrame);

  for(int i = 0; i < 5; i++) {
    drawLines(new PVector(0, 0), PVector.fromAngle(2 * i * PI / 5.), nFrame * 4, height * 0.5);
  }
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
