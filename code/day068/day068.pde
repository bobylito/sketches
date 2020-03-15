/**
 * Name: Day 68 x desert storm
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 1000; // The number of frame to record

color[] cs = {
  #eadea6, 
  #f6cd90, 
  #deb881
};
class Particle {
  PVector position;
  PVector speed;
  float lifetime;
  color c;

  Particle(PVector p) {
    position = p;
    speed = new PVector(0, 0);
    lifetime = maxFrameNumber;

    int cv = floor(random(cs.length));
    c = cs[cv];
  }

  void update(PVector wind) {
    speed = PVector.lerp(speed, wind, 0.005);
    position = PVector.add(position, speed);
  }

  boolean isDead() {
    return frameCount >= lifetime;
  }
}

int radius = 350;
class PSystem {
  ArrayList<Particle> particles = new ArrayList<Particle>();

  PSystem(int nb) {
    for (int i = 0; i < nb; i++) {
      float angle = random(TWO_PI);
      float d = random(radius);
      PVector pos = new PVector(d * cos(angle), d * sin(angle));
      this.particles.add(new Particle(pos));
    }
  }

  void update() {
    for (Particle p : particles) {
      p.update(p.position.mult(-1));
    }
  }

  void recycle() {
    float r = 0.8;
    for (Particle p : particles) {
      if (
        p.position.x < -width * r ||
        p.position.x > width * r ||
        p.position.y < -height * r ||
        p.position.y > height * r
        ) {
        float angle = random(TWO_PI);
        float d = random(radius);
        p.position = new PVector(d * cos(angle), d * sin(angle));
      }
    }
  }
}

PSystem ps; 
void setup() {
  size(700, 700, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  randomSeed(0);
  ps = new PSystem(1000);

  background(#efe9cc);
}

void reset() {
  noStroke();
}

void animation() {
  translate(width * .5, height * .5);
  rotate(PI * 0.5 * frameCount / maxFrameNumber);
  for (Particle p : ps.particles) {
    fill(p.c);
    circle(p.position.x, p.position.y, 1);
  }
  ps.recycle();
  ps.update();
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
