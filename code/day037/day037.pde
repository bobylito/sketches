/**
 Name: Day 37 ,. landscapes
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
float maxFrameNumber = 600; // The number of frame to record
// `width` and `height` are automagically set by size

void setup() {
  size(500, 500);
  smooth(8);

  // Uncomment next line for high DPI support, makes larger files
  pixelDensity(displayDensity());

  colorMode(HSB, 100);

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(#fff8cd);
}

int nbSteps = 11;
float noiseScale = 0.01;
int nbRows = 20;

void drawCurve() {
  float stepSize = width / nbSteps;
  float rowSize = height / nbRows;

  rotate(PI / 4);

  randomSeed(0);
  noiseDetail(3, 0.65);
  noiseSeed(3);

  fill(#ff78ae);

  float x = frameCount / maxFrameNumber;
  float t = sin(PI * (x*(2-x))) * 40; 

  beginShape();
  for (int r = -20; r < (nbRows* 2); r++) {

    curveVertex(-100, r * rowSize + noise(-1 * noiseScale * t) * 100);
    curveVertex(-100, r * rowSize + noise(-1 * noiseScale * t) * 100);

    for (float i = 0.5; i < nbSteps; i++) {
      curveVertex(i * stepSize, r * rowSize + noise(i * noiseScale * t) * 100);
    }

    curveVertex(width + 100, r * rowSize + noise(nbSteps * noiseScale * t) * 100);

    for (float i = nbSteps - 0.5; i >= 0.5; i--) {
      curveVertex(i * stepSize, r * rowSize +  rowSize * 0.5 + noise(i * noiseScale * t) * 100);
    }

    curveVertex(-100, r * rowSize+  rowSize * 0.5 + noise(-1 * noiseScale * t) * 100);
    curveVertex(-100, r * rowSize+  rowSize * 0.5 + noise(-1 * noiseScale * t) * 100);
  }
  endShape();
}

void animation() {
  drawCurve();
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

  if (frame++ >= maxFrameNumber) {
    if (isReadyForExport) {
      export.endMovie();
    }
    exit();
  }
}
