/**
 Name: Day 39 ': old school
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

int maxFrameNumber = 554; // The number of frame to record

void setup() {
  size(500, 500, P2D);
  smooth(8);
  // pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
  
  ellipseMode(CENTER);
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


color[] purpleDark = {
  #400082, 
  #7e0cf5, 
  #cd4dcc, 
  #f7beff
};

color[] fire = {
  #9d0b0b, 
  #da2d2d, 
  #eb8242, 
  #f6da63
};

color[] colors = purpleDark;

void drawGrid(float[][] grid) {
  float wSize = width / W;
  float hSize = height / H;

  for (int i = 0; i < W; i++) {
    for (int j = 0; j < H; j++) {
      float v = grid[i][j];
      if(v >= 0.1 && v < 0.13) fill(colors[0]);
      if(v >= 0.13 && v < 0.2) fill(colors[1]);
      if(v >= 0.2 && v < 0.3) fill(colors[2]);
      if(v >= 0.3) fill(colors[3]);

      ellipse(i * wSize + wSize * 0.5, j * hSize + hSize * 0.5, wSize * 0.7, hSize * 0.7);
    }
  }
}

float speed = 1.3;
void animation() {
  PVector[] centers = {
    new PVector(50 + 25 * cos(radians(frameCount * speed)), 50 + 30 * sin(radians(frameCount * speed))), 
    new PVector(50 + 40 * cos(radians(frameCount * speed + 90)), 50 + 30 * sin(radians(frameCount * speed - 90))), 
    new PVector(50 + 20 * cos(radians(frameCount * speed + 180)), 50 + 30 * sin(radians(frameCount * speed - 120))), 
  };
  float[][] grid = getGrid(centers);
  drawGrid(grid);
}

void draw() {
  reset();
  animation();

  if (isReadyForExport && frameCount > 1) {
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
