/**
 * Name: Day 57 ++ retro
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

int maxFrameNumber = 200; // The number of frame to record

/**
 * Class that helps with organizing the scenes
 * 
 */
class Stage {
  int framesPerScene;

  Stage(int maxFrameNumber, int steps) {
    this.framesPerScene = floor(maxFrameNumber / steps);
  }

  int getFrameCount() {
    return frameCount % this.framesPerScene;
  }

  float getNormalizedFrame() {
    return float(this.getFrameCount()) / float(this.framesPerScene);
  }

  int getScene() {
    return frameCount / this.framesPerScene;
  }
}

Stage s;
void setup() {
  size(1000, 1000, P2D);

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  s = new Stage(maxFrameNumber, 5);

  rectMode(CENTER);
}

// Taken from https://gist.github.com/gre/1650294
float easeInOutQuint(float t) {
  return t<.5 ? 16*pow(t, 5) : 1 + 16 * pow(t-1, 5);
}

color fg = #FFEE00;
color bg = #000000;
color pill = #FFEfbb;
color border = color(0, 48, 234);

void reset() {
  noStroke();
  background(bg);
}

int gumsPerLine = 10;
void animation() {
  float spaceBetweenGums = width / gumsPerLine;

  int scene = s.getScene();
  float n = s.getNormalizedFrame();
  float t = easeInOutQuint(n);

  translate(width / 2, height / 2);

  fill(fg);

  arc(0, 0, 300, 300, sin(n * PI) * PI / 5, TWO_PI - (sin(n * PI) * PI) / 5, PIE);

  fill(pill);
  for (int i = 2; i < gumsPerLine + 1; i ++) {
    circle(i * spaceBetweenGums - n * spaceBetweenGums, 0, 30);
  }

  fill(border);
  rect(0, -200, width, 5);
  rect(0, -190, width, 5);
  rect(0, 190, width, 5);
  rect(0, 200, width, 5);
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
