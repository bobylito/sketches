from SimpleForm import Form

def setup():
    size(600, 600)
    background(50)
    global f1, f2     # Make f1 and f2 visible
    f1 = Form(random(width), random(height), 10)
    f2 = Form(random(width), random(height), 10)

def draw():
    f1.update_me()    # Update f1 position
    f2.update_me()    # Update f2 position
    f1.draw_me()      # Draw f1
    f2.draw_me()      # Draw f2
    f1.line_to(f2)    # Draw line from f1 to f2
