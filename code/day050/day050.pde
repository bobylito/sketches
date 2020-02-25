/**
 Name: day 50 (( ...force
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 800; // The number of frame to record

PVector[] ps;
PVector[] psV;

ArrayList<PVector[]> segs = new ArrayList<PVector[]>();
int size = 100;

void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  //pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.setQuality(50, 0);
    export.startMovie();
  }

  randomSeed(1000);
  noiseSeed(666);

  ps = new PVector[size];
  psV = new PVector[size];
  for (int i = 0; i < size; i++) {
    // Init point
    ps[i] = new PVector(random(width) - width / 2, random(height) - height / 2);
    // Init speed
    psV[i] = new PVector(0, 0);
  }

  // all the segments created by the combinations of all points with the others
  for (int i = 0; i < size - 1; i++) {
    for (int j = i + 1; j < size; j++) {
      PVector[] seg = {
        ps[i], 
        ps[j]
      };
      segs.add(seg);
    }
  }
}


void reset() {
  noStroke();
  background(255);
}

void animation() {
  translate(width / 2, height / 2); // screen center is (0, 0)

  float alpha = 255 * (1.0 - (frameCount / maxFrameNumber));

  for (PVector[] s : segs) {
    float d = dist(s[0].x, s[0].y, s[1].x, s[1].y);

    if (d < 200) {
      float n = d / 200;

      stroke(0, 0, 0, alpha);
      strokeWeight((1 - n) * 3);
      line(s[0].x, s[0].y, s[1].x, s[1].y);
    }
  }


  for (int i = 0; i < size; i++) {
    PVector p = ps[i];
    PVector pV = psV[i];

    // angle taken from the noise function mapped over PI / 2
    float a = noise(p.x * 0.001, p.y * 0.001) * PI * 0.5;
    if (frameCount < 100) { // only update the speed during the first 100 steps
      pV.add(-p.x * 0.01 * cos(a), -p.y  * 0.01 * sin(a));
    }
    // move the point
    p.add(pV.x * 0.01, pV.y * 0.01);

    // display speed vector
    strokeWeight(0.5);
    stroke(255, 0, 0, alpha);
    line(p.x, p.y, p.x + pV.x, p.y + pV.y);

    // display point
    stroke(0, 0, 0, alpha);
    strokeWeight(5);
    point(p.x, p.y);
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
