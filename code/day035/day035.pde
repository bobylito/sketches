/** //<>// //<>// //<>// //<>//
 Name: Day 35 -| metro
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
int maxFrameNumber = 420; // The number of frame to record
// `width` and `height` are automagically set by size

ArrayList<PVector> steps = new ArrayList<PVector>();

void setup() {
  size(500, 500);

  // Uncomment next line for high DPI support, makes larger files
  // pixelDensity(displayDensity());

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  steps.add(new PVector(-100, 0));
  steps.add(new PVector(-50, 0));
  steps.add(new PVector(0, 0));

  randomSeed(0);
}

void reset() {
  noStroke();
  background(#fae3d9);
}

PVector NORTH = new PVector(0, -50);
PVector SOUTH = new PVector(0, 50);
PVector WEST = new PVector(-50, 0);
PVector EAST = new PVector(50, 0);

PVector getNextStep(int direction, PVector current) {
  switch(direction) {
  case 0: 
    return PVector.add(current, NORTH);
  case 1: 
    return PVector.add(current, EAST);
  case 2: 
    return PVector.add(current, SOUTH);
  default: 
    return PVector.add(current, WEST);
  }
}

int lastDirection = -1;
void update() {
  int s = frameCount % 30;
  if (s == 0) {
    int direction = floor(random(4));
    if (lastDirection == (direction + 2) % 4) direction++;
    lastDirection = direction;
    PVector current = steps.get(steps.size() - 1);
    PVector next = getNextStep(direction, current);
    steps.add(next);
    //println(steps);
  }
}

PVector lerpLast(PVector p1, PVector p2, float amount) {
  return new PVector(lerp(p1.x, p2.x, amount), lerp(p1.y, p2.y, amount));
}

PVector cameraCenter = new PVector(0, 0);
float S = 10;
float cameraWidth = 2.0;
float cameraHeight = 2.0;
void drawLine() {
  float t = (frameCount % 30) / 30.0;
  float amount = t<.5 ? 4*t*t*t : (t-1)*(2*t-2)*(2*t-2)+1;

  int currentSteps = steps.size();
  if (currentSteps > 1) {
    PVector last = PVector.lerp(steps.get(currentSteps - 2), steps.get(currentSteps - 1), amount);
    translate(width / 2, height / 2);
    translate(-last.x * S, -last.y * S);
  }
  
  scale(S);

  stroke(#61c0bf);
  strokeWeight(3);

  noFill();
  beginShape();
  for (int i = 0; i <= currentSteps - 2; i++) {
    PVector p = steps.get(i);
    vertex(p.x, p.y);
  }

  if (currentSteps > 1) {
    PVector last = PVector.lerp(steps.get(currentSteps - 2), steps.get(currentSteps - 1), amount);
    vertex(last.x, last.y);
  }
  endShape();
  
  fill(#ffb6b9);
  for (int i = 0; i <= currentSteps - 1; i++) {
    PVector p = steps.get(i);
    circle(p.x, p.y, 10);
  }
}

void animation() {
  update();
  drawLine();
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frame == 0) saveFrame("screenshot-1.png");
    if (frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
    if (frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");
  }

  if (frame++ >= maxFrameNumber) {
    if (isReadyForExport) {
      export.endMovie();
    }
    exit();
  }
}
