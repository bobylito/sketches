/**
 Name: Day 42 /\ duel
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 554; // The number of frame to record

void setup() {
  size(500, 500, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(0);
}

int W = 100;
int H = 100;
float[][] getGrid(PVector[] centers) {
  float[][] grid = new float[W][H];
  for (int i = 0; i < W; i++) {
    for (int j = 0; j < H; j++) {
      grid[i][j] = 0;
      for (PVector center : centers) {
        grid[i][j] += 1 / (1 + dist(center.x, center.y, i, j));
      }
    }
  }
  return grid;
}

void drawGrid(float[][] grid) {
  float wSize = (width - 100) / W;
  float hSize = (height - 100) / H;

  noFill();
  // stroke(palette(((y + frame) % 90) / 90));
  stroke(#ffffff);

  translate(0, 50);

  for (int j = 0; j < H; j++) {
    translate(0, hSize);
    beginShape();

    curveVertex(50, 0);

    for (int i = 1; i < W; i++) {
      float v = grid[i][j];
      float y = v > 0.1 ? -50 + 0.5 / (v * v) : -1 ;
      curveVertex(i * wSize + 50, y );
    }
    
    curveVertex(width - 50, 0);
     

    endShape();
  }
}

void animation() {
  float n = frameCount / maxFrameNumber;
  float t = sin(n * n * TWO_PI);
  PVector[] centers = {
    new PVector(50 + 30 * cos(t * t * TWO_PI + PI / 2), 50 + 30 * sin(t * TWO_PI + PI / 2)), 
    new PVector(50 + 30 * cos(t * TWO_PI), 50 + 30 * sin(t * t * TWO_PI)), 
  };
  float[][] grid = getGrid(centers);
  drawGrid(grid);
}

void draw() {
  reset();
  animation();

  if (isReadyForExport && frameCount > 1) {
    export.saveFrame();
    if (frameCount == 2) saveFrame("screenshot-1.png");
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
