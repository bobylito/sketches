size(600, 600)
background(50)

def draw_me_a_line(colour=200):
    stroke(colour)
    line(random(width), random(height),
         random(width), random(height))

for i in range(5):
    draw_me_a_line()
