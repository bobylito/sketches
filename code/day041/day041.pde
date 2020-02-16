/** //<>// //<>//
 Name: day 41 // Morphism
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;

int sceneLength = 120;
int nbScene = 6;
int maxFrameNumber = nbScene * sceneLength; // The number of frame to record

color[] brightPinkBlue = {
  color(190, 235, 233), //#beebe9, // light blue / green
  #fffdf9, // white
  #ffe3ed, // pink
  #8ac6d1  // darker blue / green
};
color[] palette = brightPinkBlue;

PVector[] getPolygon(int shapeNbPoints, int totalNbPoints) {
  PVector[] res = new PVector[totalNbPoints];
  float step = 1 / float(shapeNbPoints);
  float rotation = shapeNbPoints % 2 == 0 ? 0 : step * 0.25;

  for (int i = 0; i < shapeNbPoints; i++) {
    res[i] = new PVector(
      width * 0.33 * cos(i * step * TWO_PI + rotation * TWO_PI), 
      height * 0.33 * sin(i * step * TWO_PI + rotation * TWO_PI)
      );
  }

  for (int i = shapeNbPoints; i < totalNbPoints; i++) {
    int lastPoint = shapeNbPoints - 1;
    res[i] = new PVector(
      width * 0.33 * cos(lastPoint * step * TWO_PI+ rotation * TWO_PI), 
      height * 0.33 * sin(lastPoint * step * TWO_PI+ rotation * TWO_PI)
      );
  }

  return res;
}

PVector[][] polygons = new PVector[nbScene][8];

void setup() {
  size(500, 500, P2D);
  smooth(8);
  pixelDensity(displayDensity()); // HiDPI, comment if too slow

  // colorMode(HSB, 100); // uncomment if you plan to play with colors

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }

  polygons[0] = getPolygon(3, 8);
  polygons[1] = getPolygon(4, 8);
  polygons[2] = getPolygon(5, 8);
  polygons[3] = getPolygon(6, 8);
  polygons[4] = getPolygon(7, 8);
  polygons[5] = getPolygon(8, 8);
}

PVector[] lerpPoly(PVector[] a, PVector[] b, float amt) {
  PVector[] res = new PVector[a.length];
  for (int i = 0; i < res.length; i++) {
    res[i] = PVector.lerp(a[i], b[i], amt);
  }
  return res;
}

void animation() {
  int currentScene = (frameCount / sceneLength) % nbScene;
  int nextScene = (currentScene + 1) % nbScene;
  int currentSceneFrameCount = max(0, (frameCount % sceneLength) - sceneLength / 2);
  float currentSceneFrameCountNormed = float(currentSceneFrameCount) / float(sceneLength / 2);
  float amt = pow(currentSceneFrameCountNormed, 4);

  // reset
  noStroke();
  fill(190, 235, 233, 255 - 200 * currentSceneFrameCountNormed); // using palette[0] but there is a type mismatch *shrug*
  rect(0, 0, width, height);

  PVector[] currentPoly = polygons[currentScene];
  PVector[] nextPoly = polygons[nextScene];
  PVector[] poly = lerpPoly(currentPoly, nextPoly, amt);

  noFill();
  stroke(palette[2]);
  strokeWeight(5);

  translate(width * 0.5, height * 0.5);
  rotate(amt * PI);
  beginShape();
  vertex(poly[0].x, poly[0].y);
  for (int i = 0; i < poly.length - 1; i++) {
    vertex(poly[i].x, poly[i].y);
  }
  vertex(poly[poly.length - 1].x, poly[poly.length - 1].y);
  endShape(CLOSE);
}

void draw() {
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
