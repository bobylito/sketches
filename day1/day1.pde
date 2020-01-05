import com.hamoid.*;

VideoExport export;
int frame = 0;

void setup() {
  size(500, 500);
  noStroke();
  colorMode(HSB,100);
  
  export = new VideoExport(this, "day1.mp4");
  export.startMovie();
}

void draw() {  
  fill(frame % 100, 30, 100);
  rect(0,0,500,500);
  fill((0 + frame) % 100, 70, 100);
  ellipseMode(CENTER);
  ellipse(250,250, 150, 150);
  
  export.saveFrame();
  
  if(frame++ >= 100) {
    export.endMovie();
    exit();
  }
}
