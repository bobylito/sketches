/**
 * Name: Day 70 <\> tossing
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

float maxFrameNumber = 600; // The number of frame to record

color[] p235 = {
  #ffa41b, 
  #ff5151, 
  #9818d6
};
color getFromPalette(color[] palette, float n) {
  int nbColors = palette.length;
  int startColorIndex = max(0, floor(n * nbColors));
  float amt = (n * nbColors) - startColorIndex; 

  color start = palette[startColorIndex % nbColors];
  color end = palette[(startColorIndex + 1) % nbColors];

  return lerpColor(start, end, amt);
}

class Particle {
  PVector position;
  PVector speed;
  float lifetime;
  color c;

  Particle() {
    position = new PVector(random(width) - width * 0.5, random(height) - height * 0.5);
    speed = new PVector((1 - random(2)) * 10, (1 - random(2))  *10);
    lifetime = maxFrameNumber;
    c = #000000;
  }

  void update() {
    position = PVector.add(position, speed);
  }

  boolean isDead() {
    return frameCount >= lifetime;
  }

  void bounce() {
    if (position.x < -width * 0.5 || position.x > width * 0.5) {
      speed.set(speed.x * -1, speed.y);
    }

    if (position.y < -height * 0.5 || position.y > height * 0.5) {
      speed.set(speed.x, speed.y * -1);
    }
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

  void update() {
    for (Particle p : particles) {
      p.update();
    }
  }

  void recycle() {
    for (Particle p : particles) {
      if (
        p.position.x < -width * 0.5||
        p.position.x > width * 0.5 ||
        p.position.y < -height * 0.5 ||
        p.position.y > height * 0.5
        ) {
        p.bounce();
      }
    }
  }
}

PSystem ps;

void setup() {
  size(700, 700, P2D);
  smooth(8);
  // pixelDensity(displayDensity()); // HiDPI, comment if too slow

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
  randomSeed(1002);
  ps = new PSystem(3000);
}

color bg = #ededed;
void reset() {
  noStroke();
  background(bg);
}

float maxD = 100;

void animation() {
  pushMatrix();
  translate(width * .5, height * .5);
  strokeWeight(10);
  for (int i = 1; i < ps.particles.size(); i++) {
    Particle p0 = ps.particles.get(i - 1);
    Particle p1 = ps.particles.get(i);
    float alpha = (maxD - min(maxD, dist(p0.position.x, p0.position.y, p1.position.x, p1.position.y))) / maxD;
    color c = getFromPalette(p235, i / float(ps.particles.size()));
    stroke(red(c), green(c), blue(c), alpha * 255);
    line(p0.position.x, p0.position.y, p1.position.x, p1.position.y);
  }
  popMatrix();

  ps.recycle();
  ps.update();

  noStroke();
  fill(red(bg), green(bg), blue(bg), 225);
  float nbBars = 101;
  for (int i = 0; i < nbBars; i++) {
    if (i % 2 == 1) {
      rect(0, 0, width / nbBars, height);
    }
    translate(width / nbBars, 0);
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
