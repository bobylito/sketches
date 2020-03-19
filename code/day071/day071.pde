/**
 * Name: day 71 == googly
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 300; // The number of frame to record

class Circle {
  PVector center;
  float radius;

  Circle(PVector center, float radius) {
    this.center = center;
    this.radius = radius;
  }

  boolean isIntersecting(Circle c) {
    return PVector.dist(c.center, this.center) < (c.radius + this.radius);
  }

  boolean isWithin(Circle c) {
    return PVector.dist(c.center, this.center) < (c.radius - this.radius * 1.5);
  }

  void setRadius(float radius) {
    this.radius = radius;
  }

  void translate(PVector p) {
    this.center.add(p);
  }

  void draw() {
    circle(this.center.x, this.center.y, radius);
  }
}

int rows = 8;
int cols = 8;
Circle[] circles = new Circle[(rows * cols)];
Circle[] pupils = new Circle[(rows * cols)];

int margin = 25;
float h = 650 / rows;
float w = 650 / cols;

float pupilRadius = h * 0.5;

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

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int idx = i + j * rows;
      
      // eye
      PVector c = new PVector(i * w + margin + w * 0.5 - width * 0.5, j * h + margin + h * 0.5 - height * 0.5);
      circles[idx] = new Circle(c, h);

      // pupil
      PVector pc = new PVector(c.x, c.y + pupilRadius * 0.4);
      pupils[idx] = new Circle(pc, pupilRadius);
    }
  }
}

void reset() {
  noStroke();
  background(200);
}

// Taken from https://gist.github.com/gre/1650294
float easeOutQuint(float t) {
  return t<.5 ? 16*pow(t, 5) : 1 + 16 * pow(t-1, 5);
}


float steps = 2;
int framesPerStep = floor(maxFrameNumber / steps);

void animation() {
  translate(width * 0.5, height * 0.5);
  // current step or "scene". Each does a different animation.
  int step = frameCount / framesPerStep;
  // current frame in the step, so that we can keep track
  float frameInCurrentStep = frameCount % framesPerStep;
  // the current frame normalized [0, framePerStep] => [0, 1]. Makes it easy to apply easings
  float n = frameInCurrentStep / framesPerStep;
  // time as easing(n)
  float t = easeOutQuint(n);

  if (step == 0) rotate(PI * t);
  if (step > 0) {
    rotate(PI);
  }

  for (int i = 0; i < circles.length; i++) {
    Circle c = circles[i];
    Circle p = pupils[i];
    
    if (step == 1) {
      PVector v = new PVector(0, -t * h * 0.5);
      PVector previousCenter = p.center.copy(); 
      p.translate(v);
      if(!p.isWithin(c)) {
        p.center = previousCenter;
        //p.center = new PVector(c.center.x, c.center.y - pupilRadius * 0.5);
      }
    }

    fill(255);
    c.draw();

    fill(0);
    p.draw();
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
