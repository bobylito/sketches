/**
Name: day 54 /> mystery map
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 900; // The number of frame to record

void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if(isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
  
  rectMode(CENTER);
  noiseSeed(100);
  noiseDetail(10);
}

void reset() {
  noStroke();
  background(255);
}

// float[][] dots = new float[30][30];
float margin = 150;
int rows = 16;
int cols = 16;
int maxSteps = 3;
int framesPerStep = floor(maxFrameNumber / maxSteps);
void animation() {
  fill(0);
  
  float wSize = (width - margin * 2) / cols;
  float hSize = (height - margin * 2) / rows;
  
  int step = frameCount / framesPerStep;
  noiseSeed(100 * step);
  int currentStepFrame = frameCount % framesPerStep;
  float normalizedFrame = float(currentStepFrame) / float(framesPerStep);
  
  for(int i = 0; i < cols; i++) {
    for(int j = 0; j < rows; j++) {
      PVector center = new PVector(
        margin + i * wSize + wSize * 0.5,
        margin + j * hSize + hSize * 0.5
      );
      float n = noise(center.x * 0.01, center.y * 0.01);
      float radius = n * n * sin(PI * normalizedFrame);
      fill(lerpColor(#171313, #ea21a2, radius));
      rect(center.x, center.y, wSize * .7, hSize * .7, radius * hSize);
    }  
  }
  
}

void draw() {
  reset();
  animation();

  if(isReadyForExport) {
    export.saveFrame();
    if(frameCount == 1) saveFrame("screenshot-1.png");
    if(frameCount == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
    if(frameCount == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");
  }

  if (frameCount >= maxFrameNumber) {
    if(isReadyForExport) {
      export.endMovie();
    }
    exit();
  }
}
