/**
 Name: Day 44 o longlat
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

PGraphics drawStencil() {
  noStroke();

  PGraphics pgText = createGraphics(width, height);
  rectMode(CORNER);
  pgText.beginDraw();
  pgText.background(255);
  pgText.fill(0);
  pgText.ellipse(width * 0.5, height * 0.5, width * 0.5, height * 0.5);
  pgText.endDraw();

  PGraphics pgStencil = createGraphics(width, height);
  pgStencil.beginDraw();
  pgStencil.fill(0);
  pgStencil.rect(0, 0, width, height);
  pgStencil.mask(pgText);
  pgStencil.endDraw();
  return pgStencil;
}

PGraphics stencil;
void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  stencil = drawStencil();
}

void reset() {
  noStroke();
  background(0);
}

void animation() {
  float n = sin(PI / 2 + PI * (frameCount) / (maxFrameNumber));
  float t = n * n ;

  noFill();
  stroke(255, 255, 255, 255);

  strokeWeight(1);
  for (int i = 0; i< 20; i++) {
    ellipse(
      width * 0.5 - 300 * cos(t * TWO_PI * sin(radians(i * 10)) + i * PI * 0.1), 
      height * 0.5 - 300 * sin(t * TWO_PI* sin(radians(i * 10 )) + i * PI * 0.1), 
      width * 0.5 + 300 + i * 3, 
      height * 0.5 + 300 + i * 3);
  }

  image(stencil, 0, 0, width, height);

  strokeWeight(4);
  ellipse(width * 0.5, height * 0.5, width * 0.5 + 10, height * 0.5 + 10);
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
