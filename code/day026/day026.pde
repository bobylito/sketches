/**
 * Name: Day 26 /] Neon
 */

import com.hamoid.*;

color pink = #fe019a;
color green = #00faac;
color yellow = #fffdaf;
color blue = #8bffff;

boolean isReadyForExport = true;
VideoExport export;
float frame = 0;
int maxFrameNumber = 314; // The number of frame to record

PGraphics stencil;
ArrayList<PGraphics> circles = new ArrayList<PGraphics>();
PVector[] centers = {
  new PVector(200, 200), 
  new PVector(300, 300), 
  new PVector(200, 300), 
  new PVector(300, 200), 
};

PShader blur;
PFont impact;

void setup() {
  size(500, 500, P2D);
  blur = loadShader("blur.glsl"); 
  impact = createFont("Impact", 32);

  // Uncomment next line for high DPI support, makes larger files
  // pixelDensity(displayDensity());

  colorMode(HSB, 100);

  circles.add(drawGlowingCircle(yellow));
  circles.add(drawGlowingCircle(pink));
  circles.add(drawGlowingCircle(green));
  circles.add(drawGlowingCircle(blue));

  stencil = drawStencil();

  imageMode(CENTER);

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
  
  // String[] fontList = PFont.list();
  // println(fontList);
}

void reset() {
  noStroke();
  noFill();
  background(0);
}

PGraphics drawStencil() {
  PGraphics pgText = createGraphics(width, height);
  rectMode(CORNER);
  pgText.beginDraw();
  pgText.textFont(impact);
  //pgText.fill(255);
  pgText.background(255);
  pgText.fill(0);
  pgText.textSize(180);
  pgText.textAlign(CENTER);
  pgText.text("NEON", 0, 160 , width, height);
  pgText.endDraw();
  // return pgText;
  
  PGraphics pgStencil = createGraphics(width, height);
   pgStencil.beginDraw();
   pgStencil.fill(0);
   pgStencil.rect(0, 0, width, height);
   pgStencil.mask(pgText);
   pgStencil.endDraw();
   return pgStencil;
   
}

PGraphics drawGlowingCircle(color c) {
  PGraphics pg = createGraphics(200, 200);
  pg.beginDraw();
  pg.noFill();
  pg.stroke(c);
  pg.strokeWeight(15);
  pg.circle(100, 100, 100);
  pg.endDraw();
  return pg;
}

void drawCircles() {
  int nbCircle = circles.size();
  for (int i = 0; i< nbCircle; i++) {
    PVector center = centers[i];
    PGraphics circle = circles.get(i);
    image(circle, center.x + 100.0 * cos((frameCount) / 10.0 + i * 5), center.y + 100.0 * sin(frameCount / 10.0 + i * 5));
  }
}

void animation() {
  drawCircles();
  filter(BLUR, 10);
  drawCircles();
  image(stencil, 250, 250);
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
