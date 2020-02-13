/**
 Name: Day 38 _/ snakes
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 720; // The number of frame to record

void setup() {
  size(500, 500, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  initVine();
}

void reset() {
  noStroke();
  background(#f1f3f4);
}

ArrayList<PVector> vine;
void initVine() {
  vine = new ArrayList<PVector>();
  vine.add(new PVector(0, 0));
  for (int i = 1; i < 1000; i++) {
    updateVine(i, vine);
  }
}

float stepSize = 2;
void updateVine(int i, ArrayList<PVector> vine) {
  PVector currentAngle = new PVector(
    stepSize * cos(PI / 2 + i * 0.05) * cos(PI / 2 + i * 0.05), 
    abs(
    stepSize * sin(PI / 2 + i * 0.05)* sin(PI / 2 + i * 0.05)
    ));
  vine.add(PVector.add(vine.get(i - 1), currentAngle));
}

int segmentSize = 100;
void drawVine(int currentF, float angle) {
  if (currentF < 1) return ;

  PVector init = vine.get(max(0, currentF - segmentSize - 1));
  PVector last = vine.get(currentF - 1);

  pushMatrix();
  translate(height / 2, width / 2);
  noFill();
  strokeWeight(3);

  rotate(angle);

  for (int i = 0; i < 9; i++) {
    rotate(i * PI / 4);
    beginShape(POINTS);
    vertex(init.x, init.y);
    for (int j = 0; j < segmentSize; j++) {
      PVector p = vine.get(max(0, currentF - j - 1));
      stroke(lerpColor(#79bac1, #512b58, dist(p.x, p.y, 0.0, 0.0) / 400));
      vertex(p.x, p.y);
    }
    vertex(last.x, last.y);
    endShape();
  }

  popMatrix();
}

void animation() {
  float n = frameCount / maxFrameNumber;
  float t = n < .5 ? 2 * n * n : -1 + (4 - 2 * n) * n ;
  float fCount = t * maxFrameNumber;
  for (int i = 0; i < 10; i++) {
    drawVine(int(fCount) - (40 * i), PI * i * .33 + 0.001 * fCount);
  }
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frameCount == 1) saveFrame("screenshot-1.png");
    if (frameCount == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
    if (frameCount == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");
  }

  if (frameCount >= maxFrameNumber) {
    if (isReadyForExport) {
      export.endMovie();
    }
    exit();
  }
}
