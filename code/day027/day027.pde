/**
 Name: Day 27 <3 minty
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
int maxFrameNumber = 400; // The number of frame to record
// `width` and `height` are automagically set by size

void setup() {
  size(500, 500, P2D);
  smooth(8);

  // Uncomment next line for high DPI support, makes larger files
  pixelDensity(displayDensity());

  colorMode(HSB, 100);

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(100);
}

void drawTriangle(int x, color c) {
  pushMatrix();
  fill(c);
  noStroke();
  translate(x, x/2);
  triangle(0, 0, 100, 173.2, 200, 0);
  popMatrix();
}

color beige = #f8b195;
color pink = #f67280;
color purple = #c06c84;
color mauve = #6c567b;

color[] palette = {
   #1fab89, #62d2a2, #9df3c4, #d7fbe8
};

void animation() {  
  pushMatrix();
  translate(width / 2, height / 2);
  scale(2);
  
  background(palette[(frameCount / 50) % palette.length]);
  
  for (int i = 0; i < 6; i++) {
    drawTriangle(-frameCount % 50 + 50, palette[(1 + frameCount / 50) % palette.length]);
    rotate(radians(60));
  }
  
  for (int i = 0; i < 6; i++) {
    drawTriangle(-frameCount % 50 + 100 , palette[(2 + frameCount / 50) % palette.length]);
    rotate(radians(60));
  }
  
  for (int i = 0; i < 6; i++) {
    drawTriangle(-frameCount % 50 + 150 , palette[(3  +frameCount / 50) % palette.length]);
    rotate(radians(60));
  }
  
  popMatrix();
}


void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frame == 0) saveFrame("screenshot-1.png");
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
