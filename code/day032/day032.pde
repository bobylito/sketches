/**
 Name: Day 32 <_ Glitches
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
int maxFrameNumber = 700; // The number of frame to record
// `width` and `height` are automagically set by size

float[][] values = new float[100][100];

void initValues() {
  for (int i = 0; i < 100; i++) {
    for (int j = 0; j < 100; j++) {
      values[i][j] = random(1);
    }
  }
}

void drawValues() {
  for (int i = 0; i < 100; i++) {
    for (int j = 0; j < 100; j++) {
      //stroke(0);
      pushMatrix();
      translate(i*5 + 2.5, j*5 + 2.5);
      //rotate(values[i][j] * PI / 2);
      fill((values[i][j] * 100) % 100);
      rect(0, 0, 5, 5);
      popMatrix();
    }
  }
}

void updateValues() {
  float[][] newValues = new float[100][100];
  for (int i = 0; i < 100; i++) {
    for (int j = 0; j < 100; j++) {
      int iMinus1 = i == 0 ? 99: i - 1;
      int jMinus1 = j == 0 ? 99: j - 1;
      newValues[i][j] = (
        (values[i][j] + values[(i + 1) % 100][j] + values[iMinus1][j]) +
        (values[i][(j + 1) % 100] + values[(i + 1) % 100][(j + 1) % 100] + values[iMinus1][(j + 1) % 100]) + 
        (values[i][jMinus1] + values[(i + 1) % 100][jMinus1] + values[iMinus1][jMinus1]) ) / 8.85 ;
    }
  }
  values = newValues;
}


void setup() {
  size(500, 500);

  // Uncomment next line for high DPI support, makes larger files
  // pixelDensity(displayDensity());

  randomSeed(0);
  colorMode(HSB, 100);
  initValues();
  rectMode(CENTER);

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(100);
}

void animation() {
  drawValues();
  updateValues();
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frame == 0) saveFrame("screenshot-1.png");
    if (frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
    if (frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");
  }

  if (frame++ >= maxFrameNumber) {
    if (isReadyForExport) {
      export.endMovie();
    }
    exit();
  }
}
