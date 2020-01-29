/**
 Name: <insert name here>
 */

import com.hamoid.*;

VideoExport export;
float frame = 0;
int maxFrameNumber = 360; // The number of frame to record
// width and height are automagically set by size

color lilac = #d8b9ff;

void setup() {
  size(500, 500, P3D);
  pixelDensity(displayDensity());
  noStroke();
  colorMode(HSB, 100);
  noiseSeed(0);
  ortho();
  lights();
  export = new VideoExport(this, "out.mp4");
  export.startMovie();
}

void drawSphere(float x, float y, float z, float s) {
  pushMatrix();
  translate(x, y, z);
  fill(100);
  sphere(s);
  popMatrix();
}

void draw() {
  noStroke();
  fill(0); // white
  rect(0, 0, width, height);


  //translate(0, 0, -);
  sphereDetail(150);
  //ambientLight(10, 10, 50);
  //pointLight(0, 20, 20, width/2 * sin(frame / 100), height/2 * cos(frame / 100), 400);
  //pointLight(30, 20, 20, width/2, height/2 * sin(frame / 100), 400 * cos(frame / 100));
  //pointLight(60, 20, 20, width/2 * cos(frame / 100), height/2, 400 * sin(frame / 100));
  lightSpecular(100, 0, 20);
  spotLight(100, 0, 15, width/2 + 100 *sin(radians(frame)), height / 2 + 100 * cos(radians(frame)), 400, 0, 0, -1, PI, 4);
  //spotLight(100, 0, 12, width * sin(radians(frame % 180)), height /2, 400, 0, 0, -1, PI/ 4, 2);
  //spotLight(100, 0, 12, width /2 , height /2, 400 * sin(radians(2 * frame % 180)), 0, 0, -1, PI/ 4, 2);

  shininess(.99);
  specular(30);



  drawSphere(250, 250, -10, 100);

  /*
  for (int i = 0; i < 19; i++) {
   for (int j = 0; j < 19; j++) {
   float k = noise(i, j);
   pushMatrix();
   translate(i * 25 + 25, j * 25 + 25, k * 250 - 125);
   sphere(5);
   popMatrix();
   }
   }
   */

  export.saveFrame();


  if (frame == 0) saveFrame("screenshot-1.png");
  if (frame == Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-2.png");
  if (frame == 2 * Math.floor(maxFrameNumber / 3)) saveFrame("screenshot-3.png");

  if (frame++ >= maxFrameNumber) {
    export.endMovie();
    exit();
  }
}
