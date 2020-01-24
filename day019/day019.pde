/**
 Name: Day 19 ]] Pandemic
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
int maxFrameNumber = 510; // The number of frame to record
// `width` and `height` are automagically set by size


PVector[] particles = new PVector[750];

void initParticles() {
  for (int i= 0; i < particles.length; i++) {
    float life = random(400, 500);
    particles[i] = new PVector(0, 0, life);
  }
}

void updateParticles() {
  for (int i= 0; i < particles.length; i++) {
    if (particles[i] != null) {
      particles[i].add(3 - random(6), 3 - random(6), - 1);
      if (particles[i].z <= 0) particles[i] = null;
    }
  }
}

void drawParticles() {
  /*
  // For some 3D tests
  noStroke();
  lights();
  shininess(20);
  ambientLight(20, 70, 0);
  specular(255,255,255);
  */
  stroke(90);
  strokeWeight(5);

  pushMatrix();
  translate(250, 250);

  for (int i= 0; i < particles.length; i++) {
    PVector current = particles[i];
    if (current != null) {
      fill(0);
      circle(current.x, current.y, 20);
      /*
      // 3D tests
      pushMatrix();
      translate(current.x, current.y , current.z/100);
      sphere(10);
      popMatrix();
      */
    }
  }

  popMatrix();
}

void setup() {
  size(500, 500);

  // Uncomment next line for high DPI support, makes larger files
  // pixelDensity(displayDensity());

  colorMode(HSB, 100);
  randomSeed(0);
  smooth(8);


  initParticles();

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}


void reset() {
  noStroke();
  background(10);
}

void animation() {
  updateParticles();
  drawParticles();
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
