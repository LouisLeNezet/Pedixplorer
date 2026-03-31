# Draw segments

Draw segments

## Usage

``` r
draw_segment(
  x0,
  y0,
  x1,
  y1,
  ggplot_gen = FALSE,
  col = par("fg"),
  lwd = par("lwd"),
  lty = par("lty")
)
```

## Arguments

- x0:

  x coordinate of the first point

- y0:

  y coordinate of the first point

- x1:

  x coordinate of the second point

- y1:

  y coordinate of the second point

- ggplot_gen:

  If TRUE add the segments to the ggplot object

- col:

  Line color

- lwd:

  Line width

- lty:

  Line type

## Value

Plot the segments to the current device or add it to a ggplot object
