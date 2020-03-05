/**
 Name: Day 58 -_ prison escape
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 189; // The number of frame to record

PVector displaySize;
PVector ballPosition;
PVector ballDirection;
int ballSize = 30;
float racketPosition;
PVector racketSize = new PVector(90, ballSize);

void setup() {
  size(500, 500, P2D);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  // The size of the screen is initialized with size()
  // That's why we need to instanciate the values that depend on the screen here.
  displaySize = new PVector(width, height - racketSize.y);
  ballPosition = new PVector(displaySize.x * 0.5, displaySize.y - ballSize);
  ballDirection = new PVector(1, displaySize.y / displaySize.x);
  racketPosition = width * 0.5;
}

void reset() {
  noStroke();
  background(0);
}

void drawBall() {
  fill(255);
  pushMatrix();
  rectMode(CORNER);
  translate(ballPosition.x, ballPosition.y);
  rect(0, 0, ballSize, ballSize);
  popMatrix();
}

void drawRacket() {
  fill(255);
  pushMatrix();
  rectMode(CENTER);
  translate(racketPosition + ballSize * 0.5, displaySize.y + racketSize.y * 0.5);
  rect(0, 0, racketSize.x, racketSize.y);
  popMatrix();
}

void updateBallPosition() {
  PVector nextPos = PVector.add(ballPosition, ballDirection);
  if (nextPos.x > (displaySize.x - ballSize) || nextPos.x < 0) ballDirection.set(ballDirection.x * -1, ballDirection.y); 
  else if (nextPos.y > (displaySize.y - ballSize) || nextPos.y < 0) ballDirection.set(ballDirection.x, ballDirection.y * -1); 
  else ballPosition = nextPos;
}

PVector[] bricks = {
  new PVector(7, 2),
  new PVector(4, 3), 
  new PVector(3, 4), 
  new PVector(0, 2),
  new PVector(3, 3), 
  new PVector(5, 4), 
};
PVector brickSize = new PVector(50, ballSize);
color[] brickColors = {
  color(151, 0, 0), 
  color(193, 129, 0 ),
  color(2, 148, 35)
};
void drawBricks() {
  for (int i = 0; i < bricks.length; i++) {
    PVector brick = bricks[i];
    fill(brickColors[i % brickColors.length]);
    pushMatrix();
    rectMode(CORNER);
    translate(10 + brick.x * (brickSize.x + 5), 10 + brick.y * (brickSize.y + 5));
    rect(0, 0, brickSize.x, brickSize.y);
    popMatrix();
  }
}

// Taken from https://gist.github.com/gre/1650294
float easeInOut(float t) {
  return t<.5 ? 4*pow(t, 3) : 1 + 4 * pow(t-1, 3);
}

void animation() {
  drawBall();
  drawRacket();
  drawBricks();
  
  float n = frameCount / maxFrameNumber;
  float t = easeInOut(n);

  racketPosition = width * 0.5 + sin(t * TWO_PI) * width * 0.3;

  for (int i = 0; i < 5; i++) {
    updateBallPosition();
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
