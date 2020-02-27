/**
 Name: day 52 @ dragon
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 585; // The number of frame to record

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

  for (int i = 0; i < size - 1; i++) {
    PVector p1 = ps[i];
    PVector[] closest = new PVector[5];
    float[] ds = {
      10000, 
      10000, 
      10000, 
      10000, 
      10000, 
    };

    for (int j = i + 1; j < size; j++) {
      PVector p2 = ps[j];
      float d = dist(p1.x, p1.y, p2.x, p2.y);

      for (int it = 0; it < ds.length; it++) {
        if ( d < ds[it] ) {
          closest[it] = p2;
          ds[it] = d;
          break;
        }
      }
    }

    for (int it = 0; it < ds.length; it++) {
      if (closest[it] != null) {
        PVector[] seg = {
          p1, 
          closest[it]
        };
        segs.add(seg);
      }
    }
  }
}

void reset() {
  noStroke();
  background(0);
}

int pickNb = 100;
void animation() {
  translate(width / 2, height / 2); // screen center is (0, 0)

  strokeWeight(1);
  
  noFill();

  int segmentsNb = segs.size();

  //println(segmentsNb);
  for (int i = 0; i < pickNb; i++) {
    int n = (i + frameCount - 100);
    if (n >= 0 && n < segmentsNb ) {
      float norm = (float(i) / float(pickNb));
      stroke(lerpColor(#c0ffb3, #2c7873, norm));

      PVector[] s = segs.get(n);

      line(s[0].x, s[0].y, s[1].x, s[1].y);
    }
  }
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frameCount == 20) saveFrame("screenshot-1.png");
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
