/**
 Name: Day 46 -= decay
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 1000; // The number of frame to record

color[] palette = {
  #6e5773, 
  #d45079, 
  #ea9085, 
  #e9e1cc, 
};

class Particle {
  PVector position;
  PVector speed;
  float lifetime;

  Particle(PVector p) {
    position = p;
    speed = new PVector(cos(random(TWO_PI)) * 5, sin(random(TWO_PI)) * 5);
    lifetime = frameCount + 300;
  }

  void update(PVector wind) {
    speed = PVector.lerp(speed, wind, 0.1);
    position = PVector.add(position, speed);
  }

  boolean isDead() {
    return frameCount >= lifetime;
  }

  color getColor() {
    float n = (lifetime - frameCount) / 300;
    float alpha = 255; //  (1 - (n * n * n)) * 255;
    return lerpColor( color(110, 87, 115, alpha), color(212, 80, 121, alpha), n);
  }
}

ArrayList<Particle> ps = new ArrayList<Particle>();

float radius = 400;
void createParticles(int nb) {
  for (int i = 0; i < nb; i++) {
    float angle = random(TWO_PI);
    float d = random(radius);
    PVector pos = new PVector(d * cos(angle + radians(frameCount)), d * sin(angle + radians(frameCount)));
    ps.add(new Particle(pos));
  }
}

PVector getWind(PVector p, PVector wc) {
  float n = frameCount / maxFrameNumber;
  float scale = 0.003 + (n * n * 0.01);
  float angle = noise((p.x + wc.x) * scale, (p.y + wc.y) * scale) * TWO_PI * 10;
  PVector wind = new PVector(10 * cos(angle), 10 * sin(angle));
  return wind;
}

void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  // pixelDensity(displayDensity()); // HiDPI, comment if too slow or too big ;D

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.setQuality(50, 0);
    export.startMovie();
  }

  randomSeed(0);
  noiseSeed(0);

  //createParticles(30);

  background(255);
}

void reset() {
  noStroke();
  fill(255, 255, 255, 10);
  rect(0, 0, width, height);
}

void updateParticles() {
  ArrayList<Particle> toBeRemoved = new ArrayList<Particle>();
  PVector windCenter = new PVector(0, 0);// new PVector(sin((frameCount / maxFrameNumber) * TWO_PI) * 1000, 0);
  translate(width / 2, height / 2);
  for (Particle p : ps) {
    if (p.isDead()) toBeRemoved.add(p);
    else {
      stroke(p.getColor());
      beginShape();
      vertex(p.position.x, p.position.y);
      vertex(p.position.x, p.position.y);
      p.update(getWind(p.position, windCenter));
      vertex(p.position.x, p.position.y);
      vertex(p.position.x, p.position.y);
      endShape();
    }
  }
  ps.removeAll(toBeRemoved);
}


void animation() {
  updateParticles();
  if (frameCount < maxFrameNumber - 350) {
    createParticles(30);
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
