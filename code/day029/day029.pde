/**
 Name: Day 29 r| slinky
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
int maxFrameNumber = 720; // The number of frame to record

void setup() {
  size(500, 500);
  smooth(8);
  pixelDensity(displayDensity());

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  fill(0);
  rect(0, 0, width, height);
}

color[] rainbow = {
  #F60000, 
  #FF8C00, 
  #FFEE00, 
  #4DE94C, 
  #3783FF, 
  #4815AA,
};


color getColor(float frame) {
  int step = (int(frame) / 10) ;
  color c1 = rainbow[step % rainbow.length];
  color c2 = rainbow[(step + 1) % rainbow.length];
  float ratio = (frame % 10) / 10;
  color c = lerpColor(c1, c2, ratio);
  return c;
}

class SpringCircle {
  PVector pos;
  color c;
  SpringCircle(float frame) {
    pos = new PVector(200.0 * sin(frame / 20.0) * sin(frame / 10.0), 150.0 * cos(frame / 15.0)* cos(frame / 5.0));
    c = getColor(frame);
  }

  void render() {
    stroke(c);
    strokeWeight(3);
    noFill();
    pushMatrix();
    translate(pos.x, pos.y);
    circle(250, 250, 100);
    popMatrix();
  }
};

int getSpringsToDisplay(int frame) {
  if(frame <= 20) return frame;
  if(frame >= 700) return 720 - frame;
  return 20;
}

void animation() {
  int springsToDisplay = getSpringsToDisplay(frameCount);
  
  for (float i = 0.0; i < springsToDisplay; i++) {
    SpringCircle s = new SpringCircle((frameCount + i) / 2);
    s.render();
  }
}

void draw() {
  reset();
  animation();

  if (isReadyForExport) {
    export.saveFrame();
    if (frame == 10) saveFrame("screenshot-1.png");
    if (frame == Math.floor(maxFrameNumber / 2)) saveFrame("screenshot-2.png");
    if (frame == 2 * Math.floor(maxFrameNumber / 9)) saveFrame("screenshot-3.png");
  }

  if (frame++ >= maxFrameNumber) {
    if (isReadyForExport) {
      export.endMovie();
    }

    exit();
  }
}
