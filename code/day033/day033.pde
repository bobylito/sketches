/**
 Name: Day 33 L lines
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
int maxFrameNumber = 720; // The number of frame to record

// Config
int nbPoints = 100;

PVector[] initCircle(PVector center, float radius) {
  PVector[] circle = new PVector[nbPoints];
  for (int i = 0; i < nbPoints - 1; i++) {
    circle[i] = new PVector(
      center.x + radius * cos(radians(i * 360 / (nbPoints - 1))), 
      center.y + radius * sin(radians(i * 360 / (nbPoints - 1)))
      );
  }
  return circle;
}

void setup() {
  size(500, 500, P2D);
  smooth(8);

  // Uncomment next line for high DPI support, makes larger files
  pixelDensity(displayDensity());

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(#ffc2c2);
}

PVector findClosest(PVector p, PVector[] ps) {
  PVector closest = ps[0];
  float d = dist(closest.x, closest.y, p.x, p.y);
  for (int i = 1; i < ps.length - 1; i++) {
    PVector current = ps[i];
    float currentD = current.dist(p);
    if (currentD < d) {
      d = currentD;
      closest = current;
    }
  }
  return closest;
}

void animation() {
  PVector innerCenter = new PVector(width / 2 + 20 * cos(radians(-frameCount * 1.5)), height / 2 + 20 * sin(radians(-frameCount * 1.5))); 
  PVector[] c1 = initCircle(innerCenter, 80);
  PVector[] c2 = initCircle(new PVector(width / 2 + 40 * cos(radians(frameCount)), height / 2 + 40 * sin(radians(frameCount))), 150);
  
  fill(#ff2e63);
  circle(innerCenter.x, innerCenter.y, 160);
  
  strokeCap(ROUND);
  strokeJoin(ROUND);
  stroke(#010a43);
  for (int i = 0; i < c1.length- 1; i++) {
    PVector current = c1[i];
    PVector closest1 = findClosest(current, c2);
    strokeWeight(8 + closest1.dist(current) * closest1.dist(current)  / 100);
    line(current.x, current.y, closest1.x, closest1.y);
  }
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
