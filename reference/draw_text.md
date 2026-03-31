# Draw texts

Draw texts

## Usage

``` r
draw_text(
  x,
  y,
  label,
  ggplot_gen = FALSE,
  cex = par("cex"),
  col = par("col"),
  adjx = 0.5,
  adjy = 0.5,
  tips = NULL
)
```

## Arguments

- x:

  x coordinates

- y:

  y coordinates

- label:

  Text to be displayed

- ggplot_gen:

  If TRUE add the segments to the ggplot object

- cex:

  Character expansion of the text

- col:

  Text color

- adjx:

  x adjustment

- adjy:

  y adjustment

- tips:

  Text to be displayed when hovering over the text

## Value

Plot the text to the current device or add it to a ggplot object
