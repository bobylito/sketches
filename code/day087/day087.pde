/**
 * Name: day 87 )) burning
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

ArrayList<PVector> lines;

PVector pointFromCircle(PVector center, float radius, float angle) {
  return new PVector(
    center.x + radius * cos(angle), 
    center.y + radius * sin(angle)
    );
}

PVector center = new PVector(0, 0);
ArrayList<PVector> initLines(float radius, int steps) {
  float angle = TWO_PI / float(steps);
  ArrayList<PVector> res = new ArrayList<PVector>();

  for (int i = 0; i < steps; i++) {
    res.add(pointFromCircle(center, radius, angle * i));
    res.add(pointFromCircle(center, radius, angle * i));
  }

  return res;
}

void setup() {
  size(700, 700, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if(isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
  
  lines = initLines(300, 200);
  noiseSeed(234);
}

void reset() {
  noStroke();
  background(0);
}

float speed = 10;
void animation() {
  float n = frameCount / maxFrameNumber;
  float t = cos(n * TWO_PI);
  randomSeed(23599);
  translate(width * 0.5, height * 0.5);
  fill(#ee5029);
  //circle(0,0, 500);
  
  for(int i = 0; i < lines.size()  -1; i++) {
    for(int j = i+1; j < lines.size(); j++){
      float r = random(1);
      PVector p1 = lines.get(i);
      PVector p2 = lines.get(j);
      if(r > 0.5) stroke(0,0,0,120);
      else if(r > 0.35) stroke(#ee5029);
      else stroke(#ffac41);
      
      if(r > 0.3) {
        strokeWeight(r);

        PVector p1prime = PVector.lerp(p1, p2, noise((n * 100+ i) * 0.1));
        PVector p2prime = PVector.lerp(p1, p2, noise((n * 100+  j) * 0.1));
        line(p1prime.x, p1prime.y, p2prime.x, p2prime.y);
      }
    }
  }
}

void draw() {
  reset();
  animation();

  if(isReadyForExport) {
    export.saveFrame();
    if(frameCount == 1) saveFrame("screenshot-1.png");
    if(frameCount == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
    if(frameCount == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");
  }

  if (frameCount >= maxFrameNumber) {
    if(isReadyForExport) {
      export.endMovie();
    }
    exit();
  }
}
