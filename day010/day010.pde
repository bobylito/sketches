/**
 Name: Day 10 {} Rainbow
 */

import com.hamoid.*;

VideoExport export;
float frame = 0;
int maxFrameNumber = 300; // The number of frame to record
// width and height are automagically set by size

void setup() {
  size(500, 500);
  pixelDensity(displayDensity());
  colorMode(HSB, 100);
  strokeWeight(5);

  export = new VideoExport(this, "out.mp4");
  export.setFrameRate(60);
  export.startMovie();
}

color[] colors = {
  #9D07B5, // purple
  #0474D6, // blue
  #21D348, // green
  #FFB200, // yellow
  #F21A33 // red
};

float easeInQuart(float t) {
  return t*(2-t);
};

void drawRainbow(int x, int y, float completion) {
  pushMatrix();
  translate(x, y + 25);
  for (int i = 0; i < colors.length; i++) {
    float radius = 50 + i * 20;

    float angleEnd = lerp(PI, TWO_PI, easeInQuart(min(completion * 2, 1)));
    float angleStart = lerp(TWO_PI, PI, easeInQuart(max(completion * 2, 1)));

    stroke(colors[i]);
    arc(0, 0, radius, radius, angleStart, angleEnd);
  }
  popMatrix();
}

void draw() {
  noStroke();
  fill(1); // white
  rect(0, 0, width, height);

  noFill();

  drawRainbow(250, 250, (2 * frame - 50) / maxFrameNumber);

  drawRainbow(100, 100, (2 * frame - 100) / maxFrameNumber);
  drawRainbow(400, 400, (2 * frame - 150) / maxFrameNumber);

  drawRainbow(400, 100, (2 * frame - 200) / maxFrameNumber);
  drawRainbow(100, 400, (2 * frame - 250) / maxFrameNumber);

  export.saveFrame();

  if (frame == 80) saveFrame("screenshot-1.png");
  if (frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
  if (frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");

  if (frame++ >= maxFrameNumber) {
    export.endMovie();
    exit();
  }
}
