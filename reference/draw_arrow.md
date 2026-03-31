# Draw arrows

Draw arrows

## Usage

``` r
draw_arrow(
  x0,
  y0,
  x1,
  y1,
  ggplot_gen = FALSE,
  lwd = par("lwd"),
  lty = par("lty"),
  col = par("col")
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

- lwd:

  Line width

- lty:

  Line type

- col:

  Line color

## Value

Plot the arrows to the current device or add it to a ggplot object
