/**
 * Name: Day 91 -o searching
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

void setup() {
  size(700, 700, P3D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  noiseSeed(0);
}

void reset() {
  noStroke();
  background(#39065a);
}

void cube(float x, float y, float z, float size) {
  pushMatrix();
  translate(x, y, z);
  box(size);
  popMatrix();
}

float size = 7;
float noiseScale = 3.55;
void animation() {
  // ortho();
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0) - 1500, width/2.0, height/2.0, 0, 0, 1, 0);

  // lights();
  stroke(#39065a);
  // noFill();

  float n = frameCount / maxFrameNumber;
  float t = cos( sin(n * PI) * PI * .25 + PI);
  float d = width / size;

  translate(width * 0.5, height * 0.5, height * 0.5);
  rotateY(n * TWO_PI);
  rotateX(t * TWO_PI * 1);
  translate(-width * 0.5, -height * 0.5, -height * 0.5);

  for (int i = 0; i< size; i++) {
    for (int j = 0; j < size; j++) {
      for (int k = 0; k < size; k++) {
        float v = noise(i * noiseScale * t, j * noiseScale * t, k * noiseScale * t);
        fill(lerpColor(#6a0572, #ea0599, v));
        //strokeWeight(v);
        cube(
          i * d + d * 0.5, 
          j * d + d * 0.5, 
          k * d + d * 0.5, 
          d * v);
      }
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
