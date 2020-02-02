/**
 Name: Day 28 x jack
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
int maxFrameNumber = 300; // The number of frame to record
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
  translate(x, x / 2.0);
  triangle(0, 0, 100, 173.2, 200, 0);
  popMatrix();
}

color[] palette = {
   #FFFFFF, #012169, #C8102E, 
};

void animation() {  
  pushMatrix();
  translate(width / 2, height / 2);
  scale(2);
  rotate(radians(30.2));
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
