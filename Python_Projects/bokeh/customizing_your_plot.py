from bokeh.io import curdoc
from bokeh.plotting import figure, show

# prepare some data 
x =[1, 2, 3, 4, 5]
y = [4, 5, 5, 7, 2]

# apply theme to current document
curdoc().theme = "light_minimal"

# create a plot with a specific size
p = figure(
    title="Customized Axes example", 
    y_range = (0, 25),
    sizing_mode = "stretch_width",
    max_width =500, 
    height=350, 
    x_axis_label="x",
    y_axis_label="y",
    )

# change some things about x-axis and y-axis
p.xaxis.axis_label = 'Temp'
p.xaxis.axis_line_width = 3
p.xaxis.axis_line_color = 'red'

p.yaxis.axis_label = "Pressure"
p.yaxis.major_label_text_color = "orange"
p.yaxis.major_label_orientation = "vertical"

# change things on all axes
p.axis.minor_tick_in = -3
p.axis.minor_tick_out = 6

# change plot size 
# p.width = 450
# p.height = 150

# add a renderer
circle = p.circle(x, y, fill_color="red", size=15)

#show the results
show(p)