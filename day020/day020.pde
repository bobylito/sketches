/**
 Name: Day 20 [[ swarm
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
int maxFrameNumber = 550; // The number of frame to record
// `width` and `height` are automagically set by size

PVector[] previousParticles = new PVector[1000];
PVector[] particles = new PVector[1000];

void initParticles() {
  for (int i= 0; i < particles.length; i++) {
    float life = random(400, 500);
    particles[i] = new PVector(0, 0, life);
  }
  arrayCopy(particles, previousParticles);
}

void updateParticles() {
  arrayCopy(particles, previousParticles);
  for (int i= 0; i < particles.length; i++) {
    if (particles[i] != null) {
      particles[i] = new PVector(3 - random(6), 3 - random(6), - 1).add(particles[i]);
      if (particles[i].z <= 0) particles[i] = null;
    }
  }
}

void drawParticles() {
  strokeWeight(1);
  pushMatrix();
  translate(250, 250);

  for (int i= 0; i < particles.length; i++) {
    PVector previous = previousParticles[i];
    PVector current = particles[i];
    if (current != null) {
      stroke(100);
      line(previous.x, previous.y, current.x, current.y);
    }
  }
  popMatrix();
}

void setup() {
  size(500, 500);

  colorMode(HSB, 100);
  randomSeed(0);
  smooth(8);
  background(0, 0, 0);


  initParticles();

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}


void reset() {
  noStroke();
  fill(0, 0, 0, 10);
  rect(0, 0, width, height);
}

void animation() {
  drawParticles();
  updateParticles();
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
