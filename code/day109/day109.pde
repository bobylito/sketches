/**
 * Name: Day 109 ::: 1-bit camo
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 300; // The number of frame to record

PShader shader;
void setup() {
  size(700, 700, P2D);
  // smooth(8);
  // pixelDensity(displayDensity()); // HiDPI, comment if too slow

  shader = loadShader("out.frag");

  if(isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void draw() {
  shader.set("u_nFrame", frameCount / maxFrameNumber);
  shader.set("u_resolution", float(width), float(height));
  shader(shader);
  rect(0,0,width,height);

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
