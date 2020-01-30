/**
 Name: Day 4 | Some will move faster
 */

import com.hamoid.*;

VideoExport export;
int frame = 0;
int maxFrameNumber = 720; // The number of frame to record
// width and height are automagically set by size
int background = 0;
int foreground = 100;

int[][] pillars = {
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
};

void initPillars() {
  randomSeed(0);
  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      pillars[i][j] = floor(random(4)) * 90;
    }
  }
}

void setup() {
  size(500, 500);
  pixelDensity(displayDensity());
  noStroke();
  colorMode(HSB, 100);
  initPillars();

  export = new VideoExport(this, "out.mp4");
  export.startMovie();
}

void drawCircle(int x, int y, int angle) {
  pushMatrix();
  translate(x + 25, y + 25);
  rotate(radians(angle));

  fill(foreground);
  rectMode(CENTER);
  rect(0, 0, 40, 40);
  fill(background);
  rectMode(CORNER);
  rect(0, 0, 20, 20);
  popMatrix();
}

void draw() {
  // Background reset
  fill(background); // white
  rect(0, 0, width, height);

  int seq = floor(frame / 30);
  pillars[(seq * seq * seq) % 10 ][seq % 10] += 3;
  pillars[(seq * seq * seq + 7) % 10 ][seq % 10] += 3;
  pillars[(seq * seq * seq + 3) % 10 ][(3 + seq * seq) % 10] += 3;
  pillars[(seq * seq * seq + 1) % 10 ][(1 + seq * seq) % 10] += 3;
  pillars[(seq * seq  + 1) % 10 ][(7 + seq ) % 10] += 3;
  pillars[(seq * seq  + 13) % 10 ][(9 + seq ) % 10] += 3;
  pillars[(seq * seq * seq * seq + 7) % 10 ][(5 + seq * seq) % 10] += 3;
  pillars[(seq * seq * seq * seq + 12) % 10 ][(7 + seq * seq) % 10] += 3;
  pillars[(seq * seq * seq + 9) % 10 ][(2 + seq) % 10] += 3;
  pillars[(seq * seq * seq + 99) % 10 ][(9 + seq) % 10] += 3;

  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      drawCircle(i*50, j*50, pillars[i][j]);
    }
  }

  export.saveFrame();

  if (frame == 60) saveFrame("screenshot-1.png");
  if (frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
  if (frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");

  if (frame++ >= maxFrameNumber) {
    export.endMovie();
    exit();
  }
}
