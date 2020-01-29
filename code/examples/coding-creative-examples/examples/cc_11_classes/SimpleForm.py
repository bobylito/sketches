class Form:
    def __init__(self, x, y, r):        # Constructor
        self.x = x; self.y = y          # Set x and y position
        self.rad = r                    # Set radius
        self.x_speed = random(-10, 10)  # Set random x speed
        self.y_speed = random(-10, 10)  # Set random y speed

    def update_me(self):
        self.x = (self.x + self.x_speed) % width  # Moves x and wrap
        self.y = (self.y + self.y_speed) % height # Moves y and wrap

    def draw_me(self):  
        stroke(200)
        point(self.x, self.y)           # Draw a dot
        noStroke(); fill(200,50)
        circle(self.x, self.y, self.rad) # Draw a circle

    def line_to(self, other):  
        stroke(200)
        line(self.x, self.y, other.x, other.y)
