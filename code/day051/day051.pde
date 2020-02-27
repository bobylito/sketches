/**
 Name: day 51 @ laser bunker
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 360; // The number of frame to record

PVector[] ps;

ArrayList<PVector[]> segs = new ArrayList<PVector[]>();
int size = 100;

void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.setQuality(50, 0);
    export.startMovie();
  }

  randomSeed(1000);
  noiseSeed(666);

  ps = new PVector[size];
  
  for (int i = 0; i < size; i++) {
    // Init point
    float a = radians(i * 15);
    float d = 5 * i;
    ps[i] = new PVector(d * cos(a), d * sin(a));
  }

  // all the segments created by the combinations of all points with the others
  for (int i = 0; i < size - 1; i++) {
    PVector p1 = ps[i];
    for (int j = i + 1; j < size; j++) {
      PVector p2 = ps[j];
      if (dist(p1.x, p1.y, p2.x, p2.y) < 200) {
        PVector[] seg = {
          p1, 
          p2
        };
        segs.add(seg);
      }
    }
  }
}

int beat = 30;
void reset() {
  noStroke();
  boolean isBeat = frameCount % beat == 1;
  background(isBeat ? 255: 0);
}

int pickNb = 86;
void animation() {
  translate(width / 2, height / 2); // screen center is (0, 0)

  int step = frameCount / beat;
  float stepFrameNormalized = (frameCount - (step * beat)) / float(beat);
  float alpha = (1 - (stepFrameNormalized)) * 255;
  noiseSeed(step * 100);

  stroke(255, 255, 255, alpha);
  strokeWeight(1.3);
  noFill();
  int segmentsNb = segs.size();
  beginShape();
  for (int i = step * pickNb; i < (step + 1) * pickNb; i++) {
    int n = i % segmentsNb;
    PVector[] s = segs.get(n);
    vertex(s[0].x, s[0].y);
    vertex(s[1].x, s[1].y);
  }
  endShape();
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frameCount == 2) saveFrame("screenshot-1.png");
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
