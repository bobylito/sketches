/**
 Name: day 49 $$ knowledge is...
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 360; // The number of frame to record

void setup() {
  size(500, 500, P3D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(255);
}


float I = 50;
float J = 50;
void animation() {
  camera(
    // eye
    width / 2.0, // * cos(radians(frameCount)),
    height / 1.6, 
    (height/4.0) / tan(PI / 3) + 300, 
    // center
    width/2.0, 
    height/2.0, 
    0, 
    // up
    0, 
    1, 
    0);

  stroke(0);
  strokeWeight(1);
  
  rotateX(PI / 2);
  for (int i = 0; i < I; i++) {
    for (int j = 0; j < J; j++) { 
      pushMatrix();
      translate(
        10 * i, 
        0, 
        -500 + 10 * j
        );
      float d = dist(i, j, I / 2, J / 2);
      float n = d / 35;
      fill(lerpColor(#f1f3f4, #ffe3ed, n * n * n));
      float h = cos((d / 35) * TWO_PI + radians(frameCount));
      
      box(10, 40 * h * h * h * h * h, 10);
      popMatrix();
    }
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
