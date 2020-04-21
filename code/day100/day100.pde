/**
 * Name: Day 100 :: flower
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

  ellipseMode(CENTER);
}

void reset() {
  noStroke();
  background(255);
}

class Feather {
  PVector c;
  float r;

  Feather(PVector c, float r) {
    this.c = c;
    this.r = r;
  }
}

ArrayList<Feather> renderCircle(int d, PVector p, float r, float a, float n) {
  if (d < 0) return new ArrayList<Feather>();
  PVector newP = new PVector(p.x + r * cos(a * sin(n * TWO_PI)), p.y + r * sin(a *  sin(n * TWO_PI)));
  ArrayList res = renderCircle(d - 1, newP, r * 1.1, a + PI * 0.01, pow(n, 1.1));
  res.add(new Feather(newP, 2 * r));
  return res;
  /*
  stroke(0);
   noFill();
   //circle(p.x, p.y, 2 * r);
   
   
   //line(p.x, p.y, newP.x, newP.y);
   
   fill(0);
   noStroke();
   //circle(newP.x, newP.y, 5);
   */
}

float easeInOutQuad(float t) {
  return t<.5 ?
    2*t*t :
    -1+(4-2*t)*t;
}

PVector center = new PVector(0, 0);
void animation() {
  float n = frameCount / maxFrameNumber;
  float nEased = easeInOutQuad(n);

  pushMatrix();  
  translate(width * .5, height * .5);
  stroke(0);
  for (int i = 0; i < 20; i++) {
    float x = -width * .15 + i * 10;
    strokeWeight(3);
    line(x, -height, x, height);
  }
  popMatrix();
  translate(width * .5, height * .75);
  noStroke();

  ArrayList<Feather> feathers = new ArrayList<Feather>();
  for (int i = 0; i < 15; i++) {
    feathers.addAll(renderCircle(20, new PVector(0, 0), 5, PI * 0.1, nEased));
  }

  feathers.sort(new java.util.Comparator<Feather>() {
    public int compare(Feather a, Feather b) {
      float da = center.dist(a.c);
      float db = center.dist(b.c);

      if (db > da) return 1;
      if (da > db) return -1;
      return 0;
    }
  }
  );

  for (int i = 0; i < feathers.size(); i++) {
    Feather f = feathers.get(i);
    pushMatrix();
    int currentLine = i / 15;
    float angle = (i % 15) * PI * 0.033 + PI * 1.25;
    rotate(angle);
    //stroke(0);
    fill(lerpColor(#e4007c, #ffbd39, currentLine / 20.0));
    circle(f.c.x, f.c.y, f.r);
    popMatrix();
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
