/**
 * Name: Day 45 ..> notes
 */

import com.hamoid.*;

boolean isReadyForExport = true ;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  // pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  rectMode(CENTER);
}

void reset() {
  noStroke();
  background(255);
}

float[] data = new float[20];
void animation() {

  strokeWeight(3);
  translate(width / 2, height / 2);

  for (int i = 0; i < 20; i ++) {
    float currentFrame = ((frameCount - 30 * i) % maxFrameNumber);

    if (currentFrame < 0) {
      currentFrame = maxFrameNumber + currentFrame;
    }

    float n = (currentFrame) / maxFrameNumber;

    data[i] = n;
  }

  data = sort(data);

  for (int i = 0; i < 20; i ++) {
    float n = data[19 - i];
    float t = n * n * n;

    pushMatrix();
    
    rotate(n * PI * 2.5);
    
    fill(0, 0, 0, 20);
    noStroke();
    rect(0, 0, t * 1000 * 1.05 + 10, t * 1000  *1.05 + 10);
    
    rotate(PI * 0.01);

    stroke(0, 0, 0, 255);
    fill(255);
    rect(0, 0, t * 1000, t * 1000);

    popMatrix();
  }
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
