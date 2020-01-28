/**
 Name: Day 23 _ cubes
 */

import com.hamoid.*;

boolean isReadyForExport = true;

VideoExport export;
float frame = 0;
int maxFrameNumber = 360; // The number of frame to record
// `width` and `height` are automagically set by size

void setup() {
  size(500, 500, P3D);

  // Uncomment next line for high DPI support, makes larger files
  pixelDensity(displayDensity());

  if (isReadyForExport) {
    export = new VideoExport(this, "out.mp4");
    export.setFrameRate(60);
    export.startMovie();
  }
}

void reset() {
  noStroke();
  background(0);
}

void animation() {
  lights();
  // spotLight(0, 0, 100, 0, 0, -400, -1, 0, -1, PI/16.0, 32);
  directionalLight(255, 204, 0, -1, 0, 0 );
  directionalLight(255, 102, 102, 1, 0, 0 );
  directionalLight(204, 0, 102, 0, -1, 0 );
  directionalLight(102, 204, 204, 0, 1, 0 );


  // rotateX(PI * frameCount / 1000);
  // rotateX(-PI * 0.2);
  float start = -PI * 0.5;
  float dist = -0.1 + sin(start + radians(frameCount)) / 10;
  for (int i = 0; i < 3; i++) {
    float translateX = map(i, 0, 2, width * (0.2 - dist), width * (0.8 + dist));

    for (int j = 0; j< 3; j++) {
      float translateY =  map(j, 0, 2, height * (0.2 - dist), height * (0.8 + dist));

      pushMatrix();

      translate(translateX, translateY); 
      //rotateY(PI * 0.4);
      box(width * 0.2);

      popMatrix();
    }
  }
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
