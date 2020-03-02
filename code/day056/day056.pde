/**
 Name: day 56 == than perfect
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 300; // The number of frame to record

void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

// Taken from https://gist.github.com/gre/1650294
float easeOutQuint(float t) {
  return t<.5 ? 16*pow(t, 5) : 1 + 16 * pow(t-1, 5);
}

// Constants
color bg = #08d9d6;
color fg = #252a34;

float steps = 6;
int framesPerStep = floor(maxFrameNumber / steps);

// Variables of the scene
float rotation = 0;
float barWidth = 10;
color circleColor = bg;
PVector circlePosition = new PVector(0, 0);
float radius = 190;
float barLength = 0;

void reset() {
  noStroke();
  background(bg);
}

void animation() {
  // current step or "scene". Each does a different animation.
  int step = frameCount / framesPerStep;
  // current frame in the step, so that we can keep track
  float frameInCurrentStep = frameCount % framesPerStep;
  // the current frame normalized [0, framePerStep] => [0, 1]. Makes it easy to apply easings
  float n = frameInCurrentStep / framesPerStep;
  // time as easing(n)
  float t = easeOutQuint(n);

  // Scenes definitions
  if (step == 0) {
    rotation = t * PI * 0.75;
  }
  if (step == 1) {
    barWidth = 10 + t * 300;
  }
  if (step == 2) {
    rotation = PI * 0.75 - t * 0.25 * PI;
  }
  if (step == 3) {
    circleColor = fg;
    circlePosition.set(
      lerp(-2 * width, 0, t), 
      0
      );
  }
  if (step == 4) {
    barWidth = 310 + sin(t * PI * 1.5) * 700;
  }
  if (step == 5) {
    circleColor = bg;
    rotation = 0;
    barWidth = 0;
    radius = 190 * t;
    barLength = 2 * width * max(0, (t - 0.3) / 0.7);
  }

  float halfBar = barWidth * 0.5;

  // Rendering
  // Interestingly, everything is already in place from the start
  // We just update all the parameters with the scene definitions above

  // The center of the screen is (0, 0)
  translate(width * 0.5, height * 0.5);

  fill(fg);

  rotate(rotation);

  rectMode(CORNER);
  rect(-width, -halfBar, 2* width, -2 * height);
  rect(-width, halfBar, 2 * width, 2 * height);

  fill(circleColor);
  circle(circlePosition.x, circlePosition.y, radius);

  rectMode(CENTER);
  rect(0, 0, barLength, 10);
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
