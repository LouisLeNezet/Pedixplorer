# Plot legend

Small internal function to be used for plotting a Pedigree object legend

## Usage

``` r
plot_legend(
  obj,
  cex = 1,
  boxw = 0.1,
  boxh = 0.1,
  adjx = 0,
  adjy = 0,
  leg_loc = c(0, 1, 0, 1),
  add_to_existing = FALSE,
  usr = NULL,
  lwd = 1,
  precision = 4,
  ggplot_gen = FALSE
)
```

## Arguments

- obj:

  A Pedigree object

- cex:

  Character expansion of the text

- boxw:

  Width of the polygons elements

- boxh:

  Height of the polygons elements

- adjx:

  default=0. Controls the horizontal text adjustment of the labels in
  the legend.

- adjy:

  default=0. Controls the vertical text adjustment of the labels in the
  legend.

- lwd:

  default=1. Controls the bordering line width of the elements in the
  legend.

- precision:

  The number of significatif numbers to round the numbers to.

## Value

an invisible list containing

- df : the data.frame used to plot the Pedigree

- par_usr : the user coordinates used to plot the Pedigree

## Side Effects

Creates plot on current plotting device.
