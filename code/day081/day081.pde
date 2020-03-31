/**
 * Name: Day 81 <|> framed
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 720; // The number of frame to record

void setup() {
  size(700, 700, P3D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  noiseSeed(2435);
  rectMode(CENTER);
}

void reset() {
  noStroke();
  pushMatrix();
  translate(width * 0.5, height * 0.5, -400);
  background(255);
  fill(#f3c623);
  rect(0, 0, 900, 900);

  fill(#10375c);
  rect(0, 0, 850, 850);
  popMatrix();
}

color[] p235643 = {
  #faf4ff, 
  //#f3c623, 
  //#844685, 
  #ffffff
};
color getFromPalette(color[] palette, float n) {
  int nbColors = palette.length;
  int startColorIndex = max(0, floor(n * nbColors));
  float amt = (n * nbColors) - startColorIndex; 

  color start = palette[startColorIndex % nbColors];
  color end = palette[(startColorIndex + 1) % nbColors];

  return lerpColor(start, end, amt);
}

PVector lissajouPoint(float i, float freqX, float freqY) {
  float angle = radians(i);
  float x = TWO_PI * sin(angle * 7 + PI * 0.5) * cos(angle * (freqX));
  float y = TWO_PI * sin(angle * 5) * cos(angle * (freqY));
  return new PVector(x, y);
}

void animation() {
  float n2 = frameCount / maxFrameNumber;

  noFill();

  float nRadius = 200;
  //if ((frameCount % 30) > 25) nRadius = 300;

  float angleY = TWO_PI * n2;
  //if ((frameCount % 40) > 10) angleY = TWO_PI * n2 + PI;

  translate(width * 0.5, height * 0.5);
  rotateY(angleY);
  rotateX(-PI * 0.7);

  ArrayList<PVector> points = new ArrayList<PVector>();
  stroke(p235643[0]);

  for (int j = 1; j < 10; j++) {
    strokeWeight(0.5 + j * 0.3);
    beginShape();
    for (int i = 0; i < 300; i++) {
      float f = 0.1 * frameCount + 0.1 * i + j * 0.1;
      float n = f % maxFrameNumber;

      PVector p1 = lissajouPoint(n, 10 - j, j + 5);
      float radius = nRadius;

      PVector pSphere = new PVector(radius * cos(p1.x) * cos(p1.y), radius * sin(p1.x) * cos(p1.y), radius * sin(p1.y));
      points.add(pSphere);
      curveVertex(pSphere.x, pSphere.y, pSphere.z);
    }
    endShape();
  }

  int nbPoints = points.size();
  for (int i = 0; i < nbPoints - 1; i++) {
    PVector p1 = points.get(i);
    for (int j = i + 1; j < nbPoints; j++) {
      PVector p2 = points.get(j);
      float d = p1.dist(p2);
      if (d < 30) {
        float amt = noise(p1.x * 0.01, p1.y * 0.01, p1.z * 0.01);
        color c = getFromPalette(p235643, amt);
        stroke(red(c), green(c), blue(c), 100);
        strokeWeight(0.8);
        line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
      }
    }
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
