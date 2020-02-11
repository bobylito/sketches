/**
 Name: day 36 Oo Menu
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float maxFrameNumber = 100; // The number of frame to record

PGraphics drawStencil(PFont fnt, String text, color bg) {
  noStroke();

  PGraphics pgText = createGraphics(width, height);
  rectMode(CORNER);
  pgText.beginDraw();
  pgText.textFont(fnt);
  pgText.background(255);
  pgText.fill(0);
  pgText.textSize(180);
  pgText.textAlign(CENTER);
  pgText.text(text, 0, 160, width, height);
  pgText.endDraw();

  PGraphics pgStencil = createGraphics(width, height);
  pgStencil.beginDraw();
  pgStencil.fill(bg);
  pgStencil.rect(0, 0, width, height);
  pgStencil.mask(pgText);
  pgStencil.endDraw();
  return pgStencil;
}

PGraphics stencil;
color beige = #f2f0eb;
color green = #006241;
void setup() {
  size(500, 500);

  // Uncomment next line for high DPI support, makes larger files
  pixelDensity(displayDensity());

  colorMode(HSB, 100);

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  PFont fnt = createFont("Impact", 32);
  stencil = drawStencil(fnt, "Menu", beige);
}

void reset() {
  noStroke();
  background(green);
}

void drawBar(float pos, float w) {
  pushMatrix();
  translate(pos, height / 2);
  rotate(radians(20));
  rectMode(CENTER);
  fill(100, 0, 100, 95);
  rect(0, 0, w, 400);
  popMatrix();
}

void animation() {
  float t = frameCount / maxFrameNumber;
  float amt =t<.5 ? 16*t*t*t*t*t : 1+16*(--t)*t*t*t*t;
  float pos = lerp(-100, width + 1000, amt);
  drawBar(pos, 75);
  drawBar(pos - 200, 100);
  image(stencil, -1, -1, width + 1, height +1);
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frameCount == 0) saveFrame("screenshot-1.png");
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
