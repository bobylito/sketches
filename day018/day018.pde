/** //<>// //<>//
 Name: Day 18 <^> geometry
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
int maxFrameNumber = 460; // The number of frame to record
// `width` and `height` are automagically set by size

void setup() {
  size(500, 500);

  // Uncomment next line for high DPI support, makes larger files
  // pixelDensity(displayDensity());

  colorMode(HSB, 100);

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(100);
}

PVector[] getTriade(PVector[] points, int i) {
  PVector current = points[i * 3];
  PVector previous = i == 0 ? points[points.length - 1] : points[((3 * i) - 1)];
  PVector next = i == points.length - 1 ? points[0] : points[((3 * i) + 1)];

  PVector[] triade = { //<>//
    previous, 
    current, 
    next
  };
  
  return triade;
}

void drawPattern(int x, int y) {
  pushMatrix();
  translate(x, y);

  PVector[] points = new PVector[13]; 

  float radius = 2000 * (0.5 - frame / float(maxFrameNumber));
  //stroke(10, 100, 100, 60);
  beginShape();
  for (int i = 0; i< 13; i++) {
    PVector p = new PVector(sin(radians(30 * i)) * radius, cos(radians(30 * i)) * radius);
    //vertex(p.x, p.y);
    points[i] = p;
  }
  endShape();

  PVector[] points2 = new PVector[36];
  for (int i = 0; i< 12; i++) {
    PVector current = points[i];
    PVector next = points[(i + 1) % 13];
    //stroke(40, 100, 100, 60);
    //point(current.x, current.y);

    points2[i* 3] = current;
    points2[(i * 3) + 1] = PVector.lerp(current, next, 0.33);
    points2[(i * 3) + 2] = PVector.lerp(current, next, 0.66);
  }

  //printArray(points2);

  blendMode(DIFFERENCE);
  fill(100);

  for (int i = 0; i < 6; i++) {
    PVector[] triade = getTriade(points2, i);
    PVector[] opposite = getTriade(points2, i + 6);

    beginShape();
    vertex(triade[0].x, triade[0].y);
    vertex(triade[1].x, triade[1].y);
    vertex(triade[2].x, triade[2].y);
    
    vertex(opposite[0].x, opposite[0].y);
    vertex(opposite[1].x, opposite[1].y);
    vertex(opposite[2].x, opposite[2].y);
    
    vertex(triade[0].x, triade[0].y);
    endShape(CLOSE);
  }
  
  popMatrix();
}

void animation() {
  noFill();
 
  drawPattern(250, 250);
  drawPattern(250, -50);
  drawPattern(250, 550);

  drawPattern(-50, -50);
  drawPattern(-50, 250);
  drawPattern(-50, 550);
  
  drawPattern(550, -50);
  drawPattern(550, 250);
  drawPattern(550, 550);

  
}

void draw() {
  reset();
  animation();


  println(frame);

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
