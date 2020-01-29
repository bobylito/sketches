def setup():
    size(600, 600)
    background(50)

def draw():
    draw_me_a_line()

def draw_me_a_line(colour=200):
    stroke(colour)
    line(random(width), random(height),
         random(width), random(height))
