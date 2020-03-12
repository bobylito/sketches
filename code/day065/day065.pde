/**
 Name: Day 65 ≠ soothing
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

void setup() {
  size(700, 700, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  noiseSeed(20);
}

float scale = 70;
color bg = #f6f6f6;
color fg = #222831;

void reset() {
  noStroke();
  background(bg);
}

void drawBar(int x, float n) {
  noFill();
  pushMatrix();
  translate(x, 0);
  float h = n ;
  stroke(fg);
  line(0, 0, 0, h);
  line(0, 0, 0, -h);
  popMatrix();
}

void animation() {
  translate(0, height * 0.5);
  
  for (int i = 0; i < width; i++) {
    if (i % 12 == 0) {
      float v =  cos(TWO_PI * ((frameCount + i) % maxFrameNumber) / maxFrameNumber) * 2.0 * noise(i * 0.01) - 1.0;
      drawBar(i, v * scale);
    }
    
    if (i % 12 == 3) {
      float v =  cos(TWO_PI * ((frameCount + i * 11) % maxFrameNumber) / maxFrameNumber) * 2.0 * noise(i * 0.01) - 1.0;
      drawBar(i, v * scale);
    }
    
    if (i % 12 == 6) {
      float v =  cos(TWO_PI * ((frameCount + i * 4) % maxFrameNumber) / maxFrameNumber) * 2.0 * noise(i * 0.01) - 1.0;
      drawBar(i, v * scale);
    }
    
    if (i % 12 == 9) {
      float v =  cos(TWO_PI * ((frameCount + i * 7) % maxFrameNumber) / maxFrameNumber) * 2.0 * noise(i * 0.01) - 1.0;
      drawBar(i, v * scale);
    }
  }
  
  rectMode(CENTER);
  fill(bg);
  noStroke();
  
  rect(width * 0.5, 0, width, 2);
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
