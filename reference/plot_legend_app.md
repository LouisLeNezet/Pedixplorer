# Shiny module to generate pedigree graph legend.

This module allows to plot the legend of a pedigree object. The function
is composed of two parts: the UI and the server. The UI is called with
the function `plot_legend_ui()` and the server with the function
`plot_legend_server()`.

## Usage

``` r
plot_legend_ui(id, height = "400px")

plot_legend_server(
  id,
  pedi,
  leg_loc = c(0, 1, 0, 1),
  lwd = par("lwd"),
  boxw = 0.1,
  boxh = 0.1,
  adjx = 0,
  adjy = 0
)

plot_legend_demo(height = "400px", leg_loc = c(0.2, 0.8, 0.2, 0.6))
```

## Arguments

- id:

  A string.

- pedi:

  A reactive pedigree object.

- lwd:

  default=1. Controls the bordering line width of the elements in the
  legend.

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

## Value

A static UI with the legend.

## Examples

``` r
if (interactive()) {
    plot_legend_demo()
}
```
