size(600, 600)
background(50)

stroke(200)
for i in range(5):
    line(random(width), random(height),
         random(width), random(height))
