/**
 Name: day 53 () attachment
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 300; // The number of frame to record

// https://colorhunt.co/palette/149616
color[] p1 = {
  #090088,
  #930077,
  #e4007c,
  #ffbd39
};

color getFromPalette(color[] palette, float n) {
  int nbColors = palette.length;
  int startColorIndex = floor(n * nbColors);
  float amt = (n * nbColors) - startColorIndex; 
  
  color start = palette[startColorIndex % nbColors];
  color end = palette[(startColorIndex + 1) % nbColors];
  
  return lerpColor(start, end, amt);
}

float radius = 300;
int nbPoints = 100;
PVector[] tippingPoints = new PVector[nbPoints];
PVector[] tippingPointsSpeed = new PVector[nbPoints];

void initTippingPoints() {
  float angle = TWO_PI / nbPoints;

  for (int i = 0; i < nbPoints; i++) {
    float currentA = i * angle;
    PVector tp = new PVector(radius * cos(currentA), radius * sin(currentA));
    tippingPoints[i] = tp;
    tippingPointsSpeed[i] = new PVector(0, 0);
  }
}

void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  initTippingPoints();
}

void reset() {
  noStroke();
  background(255);
}


void animation() {
  noFill();
  stroke(0);
  strokeWeight(3);
  translate(width * 0.5, height * 0.5);

  float n = frameCount / maxFrameNumber * 2;
  float globalMove = cos(n * TWO_PI) * PI * 0.1;
  float angle = TWO_PI / nbPoints;

  for (int i = 0; i < nbPoints; i++) {
    stroke(0);

    float currentA = i * angle + globalMove;
    PVector base = new PVector(50 * cos(currentA), 50 * sin(currentA));
    PVector straightHead = new PVector(radius * cos(currentA), radius * sin(currentA));
    //point(base.x, base.y);
    //point(straightHead.x, straightHead.y);
    float d = PVector.dist(straightHead, tippingPoints[i]);
    
    PVector direction = new PVector(straightHead.x - tippingPoints[i].x, straightHead.y - tippingPoints[i].y);
    tippingPointsSpeed[i].add(direction.x * log(d) * 0.0001, direction.y * log(d) * 0.0001);
    tippingPoints[i].add(tippingPointsSpeed[i]);

    stroke(getFromPalette(p1, float(i) / float(nbPoints)));
    point(tippingPoints[i].x, tippingPoints[i].y);
    
    bezier(base.x, base.y, straightHead.x, straightHead.y, tippingPoints[i].x, tippingPoints[i].y, tippingPoints[i].x, tippingPoints[i].y);
  }
  //if(frameCount == 2)  exit();
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
