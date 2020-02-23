/**
Name: <insert name here>
 */

import com.hamoid.*;
  
boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 400; // The number of frame to record

void setup() {
  size(1000, 1000, P3D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if(isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(255);
}

void animation() {
  float n = frameCount / maxFrameNumber;
  stroke(0);
  strokeWeight(2);
  
  ortho(-width/2, width/2, -height/2, height/2); // Same as ortho()
  translate(height / 2, width / 2, 0);
  rotateY(PI / 4);
  rotateX(PI / 20);
  
  for(int i = 0; i < 20; i++) {
    pushMatrix();
    float h = sin((i / 19.0) * PI * 4 + n * TWO_PI);
    fill(lerpColor(#ffbd69 ,#fe346e , 1- (h + 1) / 2));

    translate(50 * i - 450, h* 100, 0);
    box(50, 300, 300);
    popMatrix();
  }
}

void draw() {
  //lights();
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
