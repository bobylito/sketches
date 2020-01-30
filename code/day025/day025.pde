/**
 Name: Day 25 Oo Ripples
 */

import com.hamoid.*;

boolean isReadyForExport = true;
color beige = color(249, 248, 235);
color strokeColor = #4c3232;

VideoExport export;
float frame = 0;
int maxFrameNumber = 600; // The number of frame to record
// `width` and `height` are automagically set by size

void setup() {
  size(500, 500);

  // Uncomment next line for high DPI support, makes larger files
  // pixelDensity(displayDensity());

  colorMode(HSB, 100);
  randomSeed(0);

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(beige);
}

float LIFE = 120.0;
float MAX_SIZE = 200;
class Particle {
  PVector pos;
  float lastFrame;
  float firstFrame;
  
  Particle() {
    pos = new PVector(random( width), random(height));
    firstFrame = frameCount;
    lastFrame = frameCount + LIFE;
  }

  void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    strokeWeight(5);
    
    float normalizedValue = (LIFE - (lastFrame - frameCount)) / LIFE;
    float alpha = (1 - normalizedValue * normalizedValue * normalizedValue) * 100.0;
    
    fill(beige, alpha);
    stroke(strokeColor, alpha);
    circle(0, 0, normalizedValue * MAX_SIZE);
    
    if(normalizedValue >= 0.33) {
      circle(0, 0, (normalizedValue - 0.33) * MAX_SIZE);
    }
    
    if(normalizedValue >= 0.66) {
      circle(0, 0, (normalizedValue - 0.66) * MAX_SIZE);
    }
     //<>//
    popMatrix();
  }

  boolean isDead() {
    return frameCount > lastFrame;
  }
}

ArrayList<Particle> particles = new ArrayList<Particle>();

void update() {
  if (frameCount == (maxFrameNumber - LIFE)) randomSeed(0); 
  if (frameCount % 20 == 0) particles.add(new Particle());
  // Since we create a particle every 60 frames and they are added at the end, there can be only one removable and it's the first one.
  if (particles.size() > 0 && particles.get(0).isDead()) {
    particles.remove(0);
  }
}

void animation() {
  update();
  for (Particle particle : particles) {
    particle.draw();
  }
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    if(frameCount >= LIFE + 20) {
      export.saveFrame();
    }
    if (frame == LIFE) saveFrame("screenshot-1.png");
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
