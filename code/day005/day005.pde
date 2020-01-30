/**
 Name: Day 5
 */

import com.hamoid.*;

VideoExport export;
int frame = 0;
int maxFrameNumber = 720; // The number of frame to record
// width and height are automagically set by size

void setup() {
  size(500, 500);
  pixelDensity(displayDensity());
  // noStroke();
  colorMode(HSB, 100);
  noiseDetail(2);

  noStroke();

  export = new VideoExport(this, "out.mp4");
  export.startMovie();
}


color[] colors = {
  #edf7fa, 
  #5f6caf, 
  #ffb677, 
  #ff8364, 
};

color palette(float v) {
  return lerpColor(colors[0], colors[1], v);
  /*
  if (v < .33) return lerpColor(colors[0], colors[1], v / 3);
  else if (v < .66) return lerpColor(colors[1], colors[2], v / 3);
  else return lerpColor(colors[2], colors[3], v / 3);
  */
}

void drawDot(float x, float y, float z, float[] size) {
  pushMatrix();
  translate(x, y);
  ellipseMode(CORNER);
  fill(palette(z));
  ellipse(0, 0, size[0], size[1]);
  popMatrix(); //<>//
}

void draw() {
  // Background reset
  fill(100, 0, 100, 3); // white
  rect(0, 0, width, height);

  fill(0);
  int w = 5;
  int h = 5;
  

  for (int i = -1; i <=w; i++) {
    for (int j = -1; j <= h; j++) {
      float z = noise(i, j);
      float[] size = {width / w, height / h};
      drawDot(i * size[0] + cos(radians(frame)) * 100, j * size[1] + sin(radians(frame)) * 100, z, size);
    }
  }

  // We drop the first frames to get a better loopy effect
  if(frame >= 360) export.saveFrame(); 

  if (frame == 360) saveFrame("screenshot-1.png");
  if (frame == 3 * Math.floor(maxFrameNumber / 5)) saveFrame("screenshot-2.png");
  if (frame == 4 * Math.floor(maxFrameNumber / 5)) saveFrame("screenshot-3.png");

  if (frame++ >= maxFrameNumber) {
    // export.endMovie();
    exit();
  }
}
