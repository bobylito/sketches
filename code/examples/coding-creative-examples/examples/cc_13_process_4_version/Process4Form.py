class Form:
    def __init__(self, x, y, r):
        self.pos = PVector(x, y)
        self.rad = r
        self.vel = PVector(random(-1,1), random(-1,1))
        self.vel.normalize()
        self.vel.mult(0.5)

    def update_me(self):
        self.pos.add(self.vel)
        self.check_bounds()

    def draw_me(self):
        stroke(200,10)
        point(self.pos.x, self.pos.y)
        noStroke(); fill(100,10)
        ellipse(self.pos.x, self.pos.y, self.rad, self.rad)

    def line_to(self, form):
        if self.is_touching(form):
            distance = self.how_far(form)
            stroke(map(distance, 0, self.rad + form.rad, 0, 255), 50)
            line(self.pos.x, self.pos.y, form.pos.x, form.pos.y)
        
    def check_bounds(self):
        circle_radius = min(width, height) * 0.45;
        if dist(self.pos.x, self.pos.y, width/2, height/2) > circle_radius:
            self.vel.x *= -1
            self.vel.y *= -1

    def is_touching(self, form):
        return self.how_far(form) < (self.rad + form.rad)

    def how_far(self, form):
        return dist(self.pos.x, self.pos.y, form.pos.x, form.pos.y)
