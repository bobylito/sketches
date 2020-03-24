/**
 * Name: Day 74 -- 9950235
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 1000; // The number of frame to record

int framesPerStep = 100;
int size = 20;
int[][] directions;
int[][] nextDirections;

int[][] getDirections(int step) {
  noiseSeed(1000 * step);
  int[][] res = new int[size][size];
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      int v = round(noise(i * 0.2, j * 0.2) * 4);
      res[i][j] = v;
    }
  }
  return res;
}

int counter = 0;
int maxLife = 200;
class Particle {
  PVector position;
  PVector direction;
  float lifetime;
  color c;
  int id;

  Particle() {
    position = new PVector(0, 0);
    float angle = random(TWO_PI);
    direction = new PVector(3 * cos(angle), 3 * sin(angle));
    lifetime = frameCount + maxLife;
    c = #000000;
    id = counter++;
  }

  void update(PVector v) {
    direction.add(v);
    PVector newPos = PVector.add(position, direction);
    if (newPos.x > (width * 0.5) || newPos.x < -(width * 0.5) ) direction.set(-0.8 * direction.x, direction.y);
    else if (newPos.y > height * 0.5 || newPos.y < -(height * 0.5)) direction.set(direction.x, -0.8 * direction.y);
    else position = newPos;
  }

  boolean isDead() {
    return frameCount >= this.lifetime;
  }

  float remainingLife() {
    return (lifetime - frameCount) / maxLife;
  }
}

int radius = 350;
class PSystem {
  ArrayList<Particle> particles = new ArrayList<Particle>();

  PSystem(int nb) {
    for (int i = 0; i < nb; i++) {
      this.particles.add(new Particle());
    }
  }

  void generate(int nb) {
    for (int i = 0; i < nb; i++) {
      this.particles.add(new Particle());
    }
  }

  void update(int[][] directions, int[][] nextDirections, float t) {
    for (Particle p : particles) {
      int i = (constrain(int(p.position.x), 0, width - 100) / 30) ;
      int j = (constrain(int(p.position.y), 0, height - 100) / 30) ;
      float angle = lerp(directions[i][j], nextDirections[i][j], t) * 0.5 * PI;
      PVector v = new PVector(0.1 * cos(angle), 0.1 * sin(angle));
      p.update(v);
    }
  }

  void recycle() {
    ArrayList<Particle> toRemove = new ArrayList();
    for (Particle p : particles) {
      if (p.isDead()) {
        toRemove.add(p);
      }
    }
    particles.removeAll(toRemove);
  }
}

PSystem ps;


void setup() {
  size(700, 700, P3D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  ps = new PSystem(0);

  nextDirections = getDirections(-1);
  directions = nextDirections;
  rectMode(CENTER);
}

void reset() {
  noStroke();
  background(30);
}

// Taken from https://gist.github.com/gre/1650294
float easeOutQuint(float t) {
  return t<.5 ? 16*pow(t, 5) : 1 + 16 * pow(t-1, 5);
}

void drawLeaf(Particle p) {
  pushMatrix();
  translate(p.position.x - 30, p.position.y - 30, 100 -p.remainingLife() * 3000);
  float n = 10 * frameCount / maxFrameNumber ;
  rotateX((n * TWO_PI + 33 * p.id) % TWO_PI);
  rotateY((n * TWO_PI + 10 * p.id) % TWO_PI);

  fill(255, 255, 255, p.remainingLife() * 255);
  square(0, 0, 60);

  popMatrix();
}


void animation() {
  lights();
  directionalLight(128, 128, 128, 0, 0, 1);  // light from viewer
 
  // current step or "scene". Each does a different animation.
  int step = frameCount / framesPerStep;
  // current frame in the step, so that we can keep track
  float frameInCurrentStep = frameCount % framesPerStep;
  // the current frame normalized [0, framePerStep] => [0, 1]. Makes it easy to apply easings
  float n = frameInCurrentStep / framesPerStep;
  float t = easeOutQuint(n);

  if (frameInCurrentStep == 0) {
    directions = nextDirections;
    nextDirections = getDirections(step);
  }

  translate(width * 0.5, height * 0.5);
  for (Particle p : ps.particles) {
    drawLeaf(p);
  }

  ps.recycle();
  if (frameCount % 4 == 0 && frameCount < (maxFrameNumber - 200)) ps.generate(2);
  ps.update(directions, nextDirections, t);
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frameCount == 50) saveFrame("screenshot-1.png");
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
