

from bokeh.plotting import figure, show


# prepare some data
x = [2, 4, 6, 8, 10]
y = [12, 14, 16, 18, 20]
y1 = [2, 3, 4, 5, 6]
y2 = [6, 7, 1, 3, 9]
y3 = [20, 4, 63, 1, 2]

# create a new plot with a title and axis labels
p = figure(title="Multiple Line Example", x_axis_label = 'x', y_axis_label= 'y')

# add multiple renders
p.line(x,y, legend_label = 'Temp.', color="blue", line_width=2)
p.line(x,y1, legend_label = 'Rate', color= "orange", line_width=2)
p.vbar(x,top=y2, legend_label = 'Objects', color = "yellow", width=0.5, bottom=0)

# add circle renderer with additional arguments
circle = p.circle(
    x,
    y3, 
    legend_label = 'Stuff',
    fill_color = "green", 
    fill_alpha = 0.6,
    line_color = "black",
    size = 69,

)

# change headline location to the left 
p.title_location = 'left'

# change headline text and style it
p.title.text = "Changes the headline here"
p.title.text_font_size = '25px'
p.title.align = "right"
p.title.background_fill_color = "darkgrey"
p.title.text_color = "white"

# change the color of previously created object's glyph
glyph = circle.glyph 
glyph.fill_color = 'blue'

# display legend in top left corner (default is top right corner) and legend title
p.legend.location = 'top_left'
p.legend.title = "Observations"

# Change appearance of legend text
p.legend.label_text_font = 'times'
p.legend.label_text_font_style = "italic"
p.legend.label_text_color = 'navy'

# change border and background of legend
p.legend.border_line_width = 3
p.legend.border_line_color = 'navy'
p.legend.border_line_alpha = 0.8
p.legend.background_fill_color = 'navy'
p.legend.background_fill_alpha = 0.2

# show the results
show(p)