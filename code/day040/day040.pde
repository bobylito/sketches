/**
 Name: Day 40 << reborn
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

int maxFrameNumber = 320; // The number of frame to record

void setup() {
  size(500, 500, P2D);
  smooth(0);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
  
  rectMode(CENTER);
}

void reset() {
  noStroke();
  background(0);
}

int W = 500;
int H = 500;
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

color[] blues = {
  #142850,
  #27496d,
  #0c7b93,
  #00a8cc,
};

color[] colors = blues;

float scale = 0.2;
void drawGrid(float[][] grid, float n) {
  float wSize = width / float(W);
  float hSize = height / float(H);
  float t = pow(n, 10);

  for (int i = 0; i < W; i++) {
    for (int j = 0; j < H; j++) {
      float v = grid[i][j];
      color fill = colors[0];
      
      if(v >= (0.1 * scale) && v < (0.13 * scale)) fill = colors[0];
      if(v >= (0.13 * scale) && v < (0.2 * scale)) fill = colors[1];
      if(v >= (0.2 * scale) && v < (0.3 * scale)) fill = colors[2];
      if(v >= (0.3 * scale)) fill = colors[3];
      
      if(t > 0.6) fill = lerpColor(fill, #ffffff, t);

      fill(fill);
      rect(
        i * wSize + wSize * 0.5,
        j * hSize + hSize * 0.5,
        wSize,
        hSize
      );
    }
  }
}

float speed = 3.0;
void animation() {
  float n = (frameCount % 160.0) / 160.0;
  float radius = .30 * (1 - pow(n, 5));
  float direction = ((frameCount / 160) % 2) * 2 - 1;
  float s = pow(n, 2) * 1080 * direction;
  
  PVector[] centers = new PVector[3];
  for(int i = 0; i < centers.length; i++) {
    centers[i] = new PVector(
      W * .5 + W * radius * cos(radians(s + 120 * i)),
      H * .5 + W * radius * sin(radians(s + 120 * i))
    );
  }
  
  float[][] grid = getGrid(centers);
  drawGrid(grid, n);
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
