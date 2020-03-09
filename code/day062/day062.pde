/**
 Name: Day 62 <-> polarized
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 400; // The number of frame to record

color bg = #403121;
color[] p2 = {
  #df760b, 
  #f6b61e, 
  #ffebaf, 
};

color getFromPalette(color[] palette, float n) {
  int nbColors = palette.length;
  int startColorIndex = max(0, floor(n * nbColors));
  float amt = (n * nbColors) - startColorIndex; 

  color start = palette[startColorIndex % nbColors];
  color end = palette[(startColorIndex + 1) % nbColors];

  return lerpColor(start, end, amt);
}

void setup() {
  size(800, 800, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  noiseSeed(600);
}

void reset() {
  noStroke();
  background(bg);
}

int W = 100;
int H = 100;
float[][] getGrid(float t) {
  float[][] grid = new float[W][H];

  for (int i = 0; i < W; i++) {
    float x = sin((i / float(W - 1)) * PI * 7);
    for (int j = 0; j < H; j++) {
      float v = ((noise(x, j * 0.01 + t)) % 2) / 2;
      grid[i][j] = v * 150;
    }
  }

  return grid;
}

float scale = 8;
void drawGrid(float[][] grid, float n) {
  float a = TWO_PI / 100;
  translate(width * .5, height * .5);
  rotate(TWO_PI * n);

  noFill();
  strokeWeight(0.9);

  for (int j = 0; j < H; j++) {
    stroke(getFromPalette(p2, j/float(H) ));
    beginShape();
    float v = grid[0][j];
    curveVertex(scale * v * cos(PI * .5), scale * v * sin(PI * .5));
    for (int i = 0; i < W; i++) {
      v = grid[i][j];

      curveVertex(scale * v * cos(i * a + PI * .5), scale * v * sin(i * a + PI * .5));
    }

    v = grid[W - 1][j];
    curveVertex(scale * v * cos((W ) * a + PI * .5), scale * v * sin((W) * a + PI * .5));
    curveVertex(scale * v * cos((W ) * a + PI * .5), scale * v * sin((W) * a + PI * .5));


    endShape();
  }
}

float easeInOutQuad(float t) {
  return t < .5 ? 2*t*t: -1+(4-2*t)*t;
}

void animation() {
  float n = frameCount / maxFrameNumber;
  float t = sin(easeInOutQuad(n) * PI);
  float[][] grid = getGrid(t * 5);
  drawGrid(grid, t * .1);
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
