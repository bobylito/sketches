/**
 * Name: Day 98 -< the plot
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
  background(0);
}

void cube(float x, float y, float z, float size) {
  pushMatrix();
  translate(x, y, z);
  box(size);
  popMatrix();
}

float size = 15;
float noiseScale = 3.55;
void animation() {
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0) - 1500, width/2.0, height/2.0, 0, 0, -1, 0);

  float n = frameCount / maxFrameNumber;
  float t = sin(n * PI);
  float d = width / size;

  translate(width * 0.5, height * 0.5, height * 0.5);
  rotateY(n * TWO_PI + PI / 4);
  rotateX(PI / 5);
  translate(-width * 0.5, -height * 0.5, -height * 0.5);

  PVector sphereCenter = new PVector(width * 0.5, width * .5, width * .5);

  pointLight(255 * t, 255 * t, 255 * t, sphereCenter.x + 400 * t, sphereCenter.y, sphereCenter.z);

  stroke(#000000);
  randomSeed(1234);

  for (int i = 0; i< size; i++) {
    for (int j = 0; j < size; j++) {
      for (int k = 0; k < size; k++) {
        PVector c = new PVector(
          (i + 0.5) * d, 
          (j + 0.5) * d, 
          (k + 0.5) * d);
        float dis = c.dist(sphereCenter);
        float scale = dis < 420 ? 0 : 1;
        fill(lerpColor(#fe346e, #512b58, random(1)));
        cube(c.x, c.y, c.z, d *  scale);
      }
    }
  }
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frameCount == 100) saveFrame("screenshot-1.png");
    if (frameCount == Math.floor(maxFrameNumber / 2)) saveFrame("screenshot-2.png");
    if (frameCount == 3 * Math.floor(maxFrameNumber / 4)) saveFrame("screenshot-3.png");
  }

  if (frameCount >= maxFrameNumber) {
    if (isReadyForExport) {
      export.endMovie();
    }
    exit();
  }
}
