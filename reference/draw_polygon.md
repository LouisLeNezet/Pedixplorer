# Draw a polygon

Draw a polygon

## Usage

``` r
draw_polygon(
  x,
  y,
  ggplot_gen = FALSE,
  fill = "grey",
  border = "black",
  density = NULL,
  angle = 45,
  lwd = par("lwd"),
  tips = NULL
)
```

## Arguments

- x:

  x coordinates

- y:

  y coordinates

- ggplot_gen:

  If TRUE add the segments to the ggplot object

- fill:

  Fill color

- border:

  Border color

- density:

  Density of shading

- angle:

  Angle of shading

- lwd:

  Line width

- tips:

  Text to be displayed when hovering over the polygon

## Value

Plot the polygon to the current device or add it to a ggplot object
