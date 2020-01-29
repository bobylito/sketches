/**
 Name: Day 24 @ micro bang
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
int maxFrameNumber = 720; // The number of frame to record
// `width` and `height` are automagically set by size

void setup() {
  size(500, 500, P3D);

  // Uncomment next line for high DPI support, makes larger files
  // pixelDensity(displayDensity());

  colorMode(HSB, 100);

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(0);
}

float getRadius() {
  if(frameCount < 160) return ( 2 * (2-(frameCount / 160.0))  * (frameCount / 160.0) ) * 80.0;
  if(frameCount > 560) {
    float n = ((frameCount - 560) / 160.0);
    return 160 + n * n * 300 ;
  }
  return 160;
}

float getAlpha() {
  if(frameCount < 110) return frameCount - 10;
  if(frameCount > 560) return 100 - frameCount + 560;
  return 100;
}

void animation() {
  // lights();
  // pointLight(20, 100, 100, width / 2, height / 2, 0);
  // ambientLight(80, 10, 50, width / 2, height / 2, 0);
  noiseSeed(0);
  float radius = getRadius();
  fill(100, 0, 100, getAlpha());
  translate(width / 2, height / 2);
  for (int a1 = 0; a1<360; a1+=10) {
    for ( int a2 = 0; a2 < 360; a2 += (10 + a1 / 5) ) {
      float m = noise((a2 + 360 * a1) * 10) * 7;
      float n = noise(a2 + 360 * a1) * 2;
      float nRadius = n * 30 + radius;
      pushMatrix();
      rotateX(radians(frameCount / m));
      // rotateZ(radians(frameCount));
      rotateY(radians(frameCount / (n * 2)));
      translate(nRadius * cos(radians(a1)) * cos(radians(a2)) , nRadius * sin(radians(a1)) * cos(radians(a2)), nRadius * sin(radians(a2)));
      sphere(3);
      popMatrix();
    }
  }
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frame == 60) saveFrame("screenshot-1.png");
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
