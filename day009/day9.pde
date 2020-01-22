/**
 Name: <insert name here>
 */

import com.hamoid.*;

VideoExport export;
float frame = 0;
int maxFrameNumber = 820; // The number of frame to record
// width and height are automagically set by size
PImage buffer;

color[] colors = {#f0134d, #ff6f5e, #f5f0e3, #40bfc1, #ffcc00, #ff6666, #cc0066, #66cccc, #faf5e4, #2c786c, #004445};
color getColor(float x) {
  return colors[int(x * colors.length)];
}

void setup() {
  size(500, 500);
  pixelDensity(displayDensity());
  noStroke();
  colorMode(HSB, 100);
  buffer = createImage(width, height, HSB);
  background(#ffffff);
  buffer = get();
  noiseSeed(0);
  export = new VideoExport(this, "out.mp4");
  export.startMovie();
}

void drawSplit(boolean isVerticalSplit, float split, float frameStep, color bg) {
  background(bg);

  if (isVerticalSplit) {
    int s = int(width * displayDensity() * split);
    PImage part1 = buffer.get(0, 0, s, height * displayDensity());
    PImage part2 = buffer.get(s, 0, width * displayDensity(), height * displayDensity());

    image(part1, 0 - frameStep, 0);
    image(part2, width * split + frameStep, 0);
  } else {
    int s = int(height * displayDensity() * split);
    PImage part1 = buffer.get(0, 0, width * displayDensity(), s);
    PImage part2 = buffer.get(0, s, width * displayDensity(), height * displayDensity());

    image(part1, 0, 0 - frameStep);
    image(part2, 0, height * split + frameStep);
  }
}

void draw() {
  if (frame <= 720) {
    int step = int(frame) / 60;
    float frameStep = int(frame) % 60 * (int(frame) % 60) / 59;
    float split = round(noise(step * 13) * 10) / 10.0;
    boolean isVerticalSplit = 1 == int(step) % 2;
    color bg = getColor(noise(step * 7));

    drawSplit(isVerticalSplit, split, frameStep, bg);

    if (frameStep == 59) {
      buffer = get();
    }
  } else {
    float frameStep = (int(frame) - 720) * (int(frame) - 720);
    float split = 0.5;
    boolean isVerticalSplit = true;
    color bg = #ffffff;

    drawSplit(isVerticalSplit, split, frameStep, bg);
  }

  export.saveFrame();

  if (frame == 10) saveFrame("screenshot-1.png");
  if (frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
  if (frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");

  if (frame++ >= maxFrameNumber) {
    export.endMovie();
    exit();
  }
}
