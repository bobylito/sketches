/**
 * Name: Day 86 || higher
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

void setup() {
  size(700, 700, P2D);
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
  fill(10, 10, 10, 20);
  if(frameCount == 1) fill(0);
  square(0, 0, width);
}

PVector pointFromCircle(PVector center, float radius, float angle) {
  return new PVector(
    center.x + radius * cos(angle), 
    center.y + radius * sin(angle)
    );
}

ArrayList<PVector> pointsFromCircle(PVector center, float radius, int steps) {
  float angle = TWO_PI / float(steps);
  ArrayList<PVector> res = new ArrayList<PVector>();

  for (int i = 0; i < steps; i++) {
    res.add(pointFromCircle(center, radius, angle * i));
  }

  return res;
}

color strawberry = #f35588;
color aqua = #05dfd7;
color lemon = #fff591;
color green = #a3f7bf;
color[] palette = {
  strawberry, lemon, aqua, 
};

color getFromPalette(color[] palette, float n) {
  int nbColors = palette.length;
  int startColorIndex = max(0, floor(n * nbColors));
  float amt = (n * nbColors) - startColorIndex; 

  color start = palette[startColorIndex % nbColors];
  color end = palette[(startColorIndex + 1) % nbColors];

  return lerpColor(start, end, amt);
}

PVector center = new PVector(0, 0);
float radius0 = 300;

void animation() {
  // min is used to give 13 frames before we end the animation, to settle the blur :)
  float n = min(1, frameCount / (maxFrameNumber - 13));
  float t = cos(n * TWO_PI);

  // data
  ArrayList<PVector> points = new ArrayList<PVector>();
  for (int i = 0; i < 10; i++) {
    int direction = ((i % 2) * 2) - 1;
    PVector currentCenter = pointFromCircle(center, radius0 * t, (direction * t * i * TWO_PI) / 10.0);
    ArrayList<PVector> currentCircle = pointsFromCircle(currentCenter, 300, 20);
    points.addAll(currentCircle);
  }


  // Rendering
  translate(width * 0.5, height * 0.5);
  strokeWeight(0.7);
  stroke(0);
  int lineNumber = 0;
  for (int i = 0; i < points.size() - 1; i++) {
    for (int j = (i + 1); j < points.size(); j++) { 
      PVector p1 = points.get(i);
      PVector p2 = points.get(j);
      float d = p1.dist(p2);
      if (d < 100 && d > 10) {
        color c = getFromPalette(palette, noise((lineNumber++) ));
        stroke(c);
        line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
      }
    }
  }
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
