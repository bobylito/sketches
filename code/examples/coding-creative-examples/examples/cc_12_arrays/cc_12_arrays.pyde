from SimpleForm import Form

def setup():
    size(600, 600)
    background(50)
    global forms
    forms = []
    for i in range(10):
        starting_x = width/4 * random(1, 3)
        starting_y = height/4 * random(1, 3)
        forms.append(Form(starting_x, starting_y, 10))

def draw():
    background(50)               # Clear the screen each time
    for i in range(len(forms)):  
        forms[i].update_me()    # Update the position of each
    for a in range(len(forms)):
        for b in range(len(forms)):
            if a > b:          # Prevents lines drawing twice
                forms[a].line_to(forms[b])
