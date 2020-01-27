/** //<>// //<>//
 Name: Day 22 # smoke
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
// float frame = 0;
int maxFrameNumber = 500; // The number of frame to record
// `width` and `height` are automagically set by size
// `framecount` can be used instead of frame

class Particle {
  PVector direction;
  PVector position;
  int lifetime;

  Particle() {
    position = new PVector(0, 0);
    float angle = random(360);
    float dist = random(5);
    direction = new PVector(dist * cos(radians(angle)), dist * sin(radians(angle)));
    lifetime = int(maxFrameNumber - 100 + random(80));
  }

  void update() {
    direction = PVector.mult(direction, .98);
    position = PVector.add(position, direction);
  }

  boolean isAlive() {
    return frameCount < lifetime;
  }

  /**
   Returns a normalized life value 0 - 100
   */
  int remainingLife() {
    return int(( 100 * max(lifetime - frameCount, 0) ) / maxFrameNumber);
  }
}

Particle[] particles = new Particle[1000]; 

void initParticles(Particle[] particles) {
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
}

void updateParticles(Particle[] particles) {
  for (int i = 0; i < particles.length; i++) {
    if (particles[i].isAlive()) {
      particles[i].update();
    }
  }
}

void drawParticles(Particle[] particles) {
  //blendMode(MULTIPLY);
  pushMatrix();
  translate(250, 250);
  for (int i = 0; i < particles.length; i++) {
    if (particles[i].isAlive()) {
      PVector pos = particles[i].position;
      int remaining = particles[i].remainingLife();
      fill(100, 100, 1, 10);
      circle(pos.x, pos.y, remaining);
    }
  }
  popMatrix();
}

void setup() {
  size(500, 500, P2D);
  smooth(16);

  // Uncomment next line for high DPI support, makes larger files
  // pixelDensity(displayDensity());

  colorMode(HSB, 100);

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  noiseSeed(0);
  initParticles(particles);
}

void reset() {
  noStroke();
  background(100);
}


void animation() {
  drawParticles(particles);
  updateParticles(particles);
  // filter(BLUR, 1);
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frameCount == 100) saveFrame("screenshot-1.png");
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
