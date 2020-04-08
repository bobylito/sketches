/**
 * Name: Day 88 .. oscilation
 */

import com.hamoid.*;
import java.util.Comparator;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 900; // The number of frame to record

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
}

void reset() {
  noStroke();
  background(paleBlue);
}

color paleBlue = #b2ebf2;
void animation() {
  randomSeed(0);
  float angleStep = TWO_PI * 0.6;
  float n = frameCount / maxFrameNumber;
  ArrayList<PVector> points = new ArrayList<PVector>();

  for (int i = 0; i < 10; i++) {
    float r = width * 0.1 * i * cos((PI * 0.4 + PI * 0.01 * sin(n * TWO_PI)) * i); // (/(100 * 2));
    float a = angleStep * i + cos(i * 0.2 * sin(n * TWO_PI));
    PVector p = new PVector(r * cos(a), r * sin(a));
    points.add(p);
  }

  translate(width * 0.5, height * 0.5);

  ArrayList<PVector> circles = new ArrayList<PVector>();
  for (int i = 0; i < points.size() - 1; i++) {
    for (int j = i + 1; j < points.size(); j++) {
      PVector a = points.get(i);
      PVector b = points.get(j);

      PVector c = new PVector(a.x, a.y, a.dist(b));
      circles.add(c);
    }
  }

  circles.sort(new Comparator<PVector>() {
    public int compare(PVector a, PVector b) {
      return b.z - a.z < 0 ? -1 : 1;
    }
  }
  );

  fill(#ffffff);
  println(circles.size());
  for (int i = 0; i < circles.size(); i++) {
    PVector c = circles.get(i);
    fill(lerpColor(paleBlue, #ffffff, sin(PI * ((i + frameCount * 0.2) % circles.size()) / float(circles.size()))));
    circle(c.x, c.y, c.z);
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
