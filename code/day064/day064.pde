/**
 * Name: Day 64  [/] Double vision
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

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

  noiseSeed(5100);
  rectMode(CENTER);
}

void reset() {
  noStroke();
  background(#2c003e);
}

void animation() {
  ArrayList<PVector> points = new ArrayList<PVector>();
  PVector lastP = new PVector(0, 0);
  points.add(lastP);

  float xSum = 0;
  float ySum = 0;
  float xMin = 0;
  float xMax = 0;
  float yMin = 0;
  float yMax = 0;

  for (int i = 0; i < 1000; i++) {
    float angle = noise(((i + frameCount) % maxFrameNumber) * 0.002) * PI * 10;
    float l = 2;

    lastP = (new PVector(l * cos(angle), l * sin(angle))).add(lastP);

    xSum += lastP.x;
    ySum += lastP.y;
    xMin = xMin > lastP.x ? lastP.x : xMin;
    yMin = yMin > lastP.y ? lastP.y : yMin;
    xMax = xMax < lastP.x ? lastP.x : xMax;
    yMax = yMax < lastP.y ? lastP.y : yMax;

    points.add(lastP);
  }

  translate(width / 2, height / 2);

  float viewportWidth = xMax - xMin;
  float viewportHeight = yMax - yMin;
  float viewportMax = max(viewportWidth, viewportHeight);
  // special case: height and width have the same value
  float viewportScale = height / viewportMax;

  pushMatrix();
  scale(2 * (frameCount % 4 == 2 ? 3 : 1));
  translate(- (xSum / points.size()) * 2, - (ySum / points.size()) * 2);

  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(i);
    color f = i % 2 == 1 ? #ea0599 : #512b58;
    fill(f);

    circle(p.x, p.y, cos(i * .15 - .85) * 50);
  }
  popMatrix();

  fill(0, 0, 0, 150);
  rect(0, 0, 1000, 1000);

  scale(viewportScale * 0.8 * 1); //
  translate(- (xSum / points.size()) * viewportScale, - (ySum / points.size()) * viewportScale);

  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(i);
    color f = i % 2 == 1 ? #ea0599 : #512b58;
    fill(f);

    circle(p.x, p.y, cos(i * .15 - .85) * 50);
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
