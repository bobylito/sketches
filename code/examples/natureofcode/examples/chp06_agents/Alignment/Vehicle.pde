// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Vehicle class

class Vehicle {

  // All the usual stuff
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

    // Constructor initialize all values
  Vehicle(float x, float y) {
    position = new PVector(x, y);
    r = 12;
    maxspeed = 3;
    maxforce = 0.2;
    acceleration = new PVector(0, 0);
    velocity = PVector.random2D();
    velocity.mult(random(1,4));
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  void align (ArrayList<Vehicle> boids) {
    float neighbordist = 30;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Vehicle other : vehicles) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    } 
  }


  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display() {
    fill(175);
    stroke(0);
    pushMatrix();
    translate(position.x, position.y);
    ellipse(0, 0, r, r);
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }
}





