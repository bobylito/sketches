/**
 Name: Day 6
 */

import com.hamoid.*;

VideoExport export;
int frame = 0;
int maxFrameNumber = 360; // The number of frame to record
// width and height are automagically set by size

void setup() {
  size(500, 500);
  pixelDensity(displayDensity());
  // noStroke();
  colorMode(HSB, 100);
  noiseDetail(100, 0.00001);


  export = new VideoExport(this, "out.mp4");
  export.startMovie();
}


color[] colors = {
  #be9fe1, 
  #c9b6e4, 
  #e1ccec, 
  #f1f1f6, 
};

color palette(float v) {
  if (v < .25) return lerpColor(colors[0], colors[1], v * colors.length);
  else if (v < .50) return lerpColor(colors[1], colors[2], (v - 0.25) * colors.length);
  else if (v < .75) return lerpColor(colors[2], colors[3], (v -0.5) * colors.length);
  else return lerpColor(colors[3], colors[0], (v - 0.75) * colors.length);
}

int maxX = 51;
void drawLine(float y, int frame) {
  int step = 0;
  int amplitude = -floor( sin(radians(frame)) * 50);

  pushMatrix();
  translate(0, y * 10);

  noFill();
  stroke(palette(((y + frame) % 90) / 90));

  beginShape();
  curveVertex(-10, 0);
  curveVertex(-10, 0);
  curveVertex(50, 0);


  for (int x = 7; x < maxX - 7; x++) {
    curveVertex(x * 10, noise(x + step, y) * amplitude);
  }

  curveVertex((maxX - 6) * 10, 0);
  curveVertex((maxX + 1) * 10, 0);
  curveVertex((maxX + 1) * 10, 0);

  endShape();

  popMatrix();
}

void draw() {
  // Background reset
  fill(0, 0, 0, 100); // white
  rect(0, 0, width, height);

  int w = 50;

  for (int l = 0; l <=w; l++) {
    drawLine(l, frame);
  }

  export.saveFrame();

  if (frame++ >= maxFrameNumber) {
    export.endMovie();
    exit();
  }
}
