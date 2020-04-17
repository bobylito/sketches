/**
 * Name: Day 97 [+] machine
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

class Disc {
  PVector center;
  float radius;

  Disc(PVector c, float r) {
    this.center = c;
    this.radius = r;
  }
}

float getMaxRadius(PVector center, ArrayList<Disc> discs) {
  float maxR = 1000;

  for (Disc e : discs) {
    float r0 = center.dist(e.center) - e.radius;
    if (r0 > 0 && r0 < maxR) maxR = r0;
  }

  return maxR;
}

boolean isWithin(PVector center, ArrayList<Disc> discs) {
  for (Disc e : discs) {
    if (e.center.dist(center) < e.radius) return true;
  }
  return false;
}

PVector getRandomCenter() {
  float angle = random(TWO_PI);
  float d = random(200) + 10;
  return new PVector(d * cos(angle), d * sin(angle));
}

ArrayList<Disc> discs = new ArrayList<Disc>();
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

  for (int i = 0; i < 50; i++) {
    PVector c = getRandomCenter();

    if (i == 0) {
      discs.add(new Disc(c, 50));
    } else if (!isWithin(c, discs)) {
      float r = min(80, getMaxRadius(c, discs));
      if (r > 1) discs.add(new Disc(c, r));
    }
  }

  discs.sort(new java.util.Comparator<Disc>() {
    public int compare(Disc a, Disc b) {
      if (a.radius > b.radius) return -1;
      else if (b.radius > a.radius) return 1;
      return 0;
    }
  }
  );
}

void reset() {
  noStroke();
  background(0);
}

void drawDisc(Disc e, float a) {
  pushMatrix();
  translate(e.center.x, e.center.y);

  noFill();
  stroke(lerpColor(#43d8c9, #95389e, e.radius / 80.0));  
  circle(0, 0, e.radius);

  translate(e.radius * cos(a), e.radius * sin(a));
  noStroke();
  fill(255);
  circle(0, 0, 1.5);

  popMatrix();
}

float easing(float t) {
  return t<.5 ? 2*t*t : -1+(4-2*t)*t;
}

void animation() {
  float n = frameCount / maxFrameNumber;
  float t = n;
  translate(width * 0.5, height * 0.5);
  //rotate(-t * PI);

  strokeWeight(4);
  for (int i = 0; i< discs.size(); i++) {
    Disc e = discs.get(i);
    float a = t * TWO_PI + i;
    drawDisc(e, a);
  }

  noFill();
  stroke(255);  
  strokeWeight(0.6);
  beginShape();
  for (int i = 0; i< discs.size(); i++) {
    Disc e = discs.get(i);
    float a = t * TWO_PI + i;
    vertex(e.center.x + e.radius * cos(a), e.center.y + e.radius * sin(a));
  }
  endShape(CLOSE);
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
