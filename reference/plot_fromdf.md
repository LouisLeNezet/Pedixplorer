# Create a plot from a data.frame

This function is used to create a plot from a data.frame.

If `ggplot_gen = TRUE`, the plot will be generated with ggplot2 and will
be returned invisibly.

## Usage

``` r
plot_fromdf(
  df,
  usr = NULL,
  title = NULL,
  ggplot_gen = FALSE,
  boxw = 1,
  boxh = 1,
  add_to_existing = FALSE,
  title_cex = 2
)
```

## Arguments

- df:

  A data.frame with the following columns:

  - `type`: The type of element to plot. Can be `text`, `segments`,
    `arc` or other polygons. For polygons, the name of the polygon must
    be in the form `poly_*_*` where poly is one of the type given by
    [`polygons()`](https://louislenezet.github.io/Pedixplorer/reference/polygons.md),
    the first `*` is the number of slice in the polygon and the second
    `*` is the position of the division of the polygon.

  - `x0`: The x coordinate of the center of the element.

  - `y0`: The y coordinate of the center of the element.

  - `x1`: The x coordinate of the end of the element. Only used for
    `segments` and `arc`.

  - `y1`: The y coordinate of the end of the element. Only used for
    `segments` and `arc`.

  - `fill`: The fill color of the element.

  - `border`: The border color of the element.

  - `density`: The density of the element.

  - `angle`: The angle of the element.

  - `label`: The label of the element. Only used for `text`.

  - `cex`: The size of the element.

  - `adjx`: The x adjustment of the element. Only used for `text`.

  - `adjy`: The y adjustment of the element. Only used for `text`.

- usr:

  The user coordinates of the plot.

- title:

  The title of the plot.

- ggplot_gen:

  If TRUE add the segments to the ggplot object

- boxw:

  Width of the polygons elements

- boxh:

  Height of the polygons elements

- add_to_existing:

  If `TRUE`, the plot will be added to the current plot.

- title_cex:

  The size of the title.

## Value

an invisible ggplot object and a plot on the current plotting device

## Examples

``` r
data(sampleped)
ped1 <- Pedigree(sampleped[sampleped$famid == 1,])
lst <- ped_to_plotdf(ped1)
#> Individuals:  1_113 won't be plotted
if (interactive()) {
    plot_fromdf(lst$df, lst$par_usr$usr,
        boxw = lst$par_usr$boxw, boxh = lst$par_usr$boxh
    )
}
```
