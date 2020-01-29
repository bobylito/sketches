/**
 Name: day 21 () follow
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
int maxFrameNumber = 2160; // The number of frame to record
// `width` and `height` are automagically set by size

void setup() {
  size(500, 500);
  smooth(8);

  // Uncomment next line for high DPI support, makes larger files
  // pixelDensity(displayDensity());

  colorMode(HSB, 100);
  
  background(0);

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  fill(0, 0, 0, 4);
  rect(0, 0, width, height);
}

PVector getA(float frame) {
  return new PVector(100 - 150 * cos(radians(frame / 3)), 100 - 150 * sin(radians(frame /3)));
}

PVector getB(float frame) {
  return new PVector(300 + 50 * cos(radians(frame/2)), 100 + 100 * sin(radians(frame / 2)));
}

PVector getC(PVector a, PVector b) {
  float dist = a.dist(b);
  return new PVector(a.x + dist* cos(radians(45)), a.y + dist * sin(radians(45)));
}

PVector getPoint(float frame) {
  PVector a = getA(frame);
  PVector b = getB(frame);
  PVector c = getC(a, b);
  return c;
}

PVector previous[] = new PVector[10];
PVector current[] = new PVector[10];

void animation() {
  for(int i = 0; i < current.length; i++) {
    current[i] = getPoint(frame - i * 60);
  }
  
  if (frame > 1) {
    stroke(100);
    for(int i = 0; i < current.length; i++) {
      line(previous[i].x, previous[i].y, current[i].x, current[i].y);
    }
  }

  arrayCopy(current, previous);

  /* debug 
   stroke(30, 100, 100, 70);
   line(a.x, a.y, b.x, b.y);
   stroke(80, 100, 100, 70);
   line(a.x, a.y, c.x, c.y);
   line(b.x, b.y, c.x, c.y);
   */
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
