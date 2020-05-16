/**
 * Name: Day 114 OOO glass
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 300; // The number of frame to record

PShader shader;
void setup() {
  size(700, 700, P3D);
  // smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  shader = loadShader("out.frag", "shader.vert");

  if(isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void draw() {
  float nFrame = frameCount / maxFrameNumber;
  shader.set("u_nFrame", nFrame);
  shader.set("u_resolution", float(width) * displayDensity(), float(height) * displayDensity());
  background(255);
  noStroke();
  shader(shader);
  //translate(width * 0.75, height * 0.75, -100);
  //rotateX(nFrame * PI);
  // translate(width * -0.25, height * -0);
  // box(width * 0.5);
  rect(0, 0, width, height);
  translate(width * .5, height * .5);
  sphere(width * 0.3);

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
