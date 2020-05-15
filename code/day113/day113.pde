/**
 * Name: Day 113 ))) casting
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

PShader shader;
void setup() {
  size(700, 700, P3D);

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
  shader.set("u_resolution", float(width), float(height));
  background(255);
  shader(shader);

  noStroke();
  translate(width * 0.5, height * 0.5, -width * 0.3);
  rotateY(PI - nFrame * PI * 0.5);
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
