/**
 Name: Day 61 >- topography
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 400; // The number of frame to record

color[] p2 = {
  #ff7c7c, 
  #ffd082, 
  #88e1f2, 
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
  size(500, 500, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  noiseSeed(100);
}

void reset() {
  noStroke();
  background(#21243d);
}

int W = 100;
int H = 100;
float[][] getGrid(float t) {
  float[][] grid = new float[W][H];
  for (int i = 0; i < W; i++) {
    for (int j = 0; j < H; j++) {
      float v = ((noise(i * 0.01, j * 0.01 + t)) % 2) / 2;
      grid[i][j] = v * 100;
    }
  }
  return grid;
}

void drawGrid(float[][] grid) {
  float wSize = (width - 100) / W;

  noFill();
  strokeWeight(0.9);

  for (int j = 0; j < H; j++) {
    stroke(getFromPalette(p2, j/float(H) ));
    beginShape();
    for (int i = 1; i < W; i++) {
      float v = grid[i][j];
      float y = v;
      curveVertex(i * wSize + 50, y * 10);
    }
    endShape();
  }
}

void animation() {
  float n = frameCount / maxFrameNumber;
  float t = sin(n * PI) * 5;
  float[][] grid = getGrid(t);
  drawGrid(grid);
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
