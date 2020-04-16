/**
 * Name: Day 96 -- them
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

class Eye{
  PVector center;
  float radius;

  Eye(PVector c, float r) {
    this.center = c;
    this.radius = r;
  }
}

float getMaxRadius(PVector center, ArrayList<Eye> eyes) {
  float maxR = 1000;

  for (Eye e : eyes) {
    float r0 = center.dist(e.center) - e.radius;
    if (r0 > 0 && r0 < maxR) maxR = r0;
  }

  return maxR;
}

boolean isWithin(PVector center, ArrayList<Eye> eyes) {
  for (Eye e : eyes) {
    if (e.center.dist(center) < e.radius) return true;
  }
  return false;
}

PVector getCenterAwayFrom(ArrayList<Eye> eyes) {
  PVector res;
  do {
    res = new PVector(random(700), random(700));
  } while (!isWithin(res, eyes));
  return res;
}

PVector getRandomCenter() {
  float angle = random(TWO_PI);
  float d = random(300) + 10;
  return new PVector(d * cos(angle), d * sin(angle));
  // Since there is a rotation of the plane, distributing over a rectangle is less graceful
  // return new PVector(random(600) - 300, random(600) - 300);
}

ArrayList<Eye> eyes = new ArrayList<Eye>();
void setup() {
  size(700, 700, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  ellipseMode(RADIUS);
  randomSeed(100);

  for (int i = 0; i < 1000; i++) {
    PVector c = getRandomCenter();

    if (i == 0) {
      eyes.add(new Eye(c, 50));
    } else if (!isWithin(c, eyes)) {
      float r = min(50, getMaxRadius(c, eyes));
      if(r > 5) eyes.add(new Eye(c, r));
    }
  }
}

void reset() {
  noStroke();
  background(0);
}

void drawEye(Eye e, float a) {
  pushMatrix();
  translate(e.center.x, e.center.y);

  fill(255);
  circle(0, 0, e.radius);

  fill(0);
  circle(e.radius * 0.5 * cos(a), e.radius * 0.5 * sin(a), e.radius * 0.45);
  popMatrix();
}

float easing(float t) {
  return t<.5 ? 2*t*t : -1+(4-2*t)*t;
}

void animation() {
  float n = frameCount / maxFrameNumber;
  float t = sin(sin(easing(n) * TWO_PI) * PI * 0.1 + PI * 0.4);
  translate(width * 0.5, height * 0.5);
  rotate(-t * PI);
  for (Eye e : eyes) {
    drawEye(e, t * PI + PI * 0.5);
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
