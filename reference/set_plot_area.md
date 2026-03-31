# Set plotting area

Set plotting area

## Usage

``` r
set_plot_area(
  cex,
  id,
  maxlev,
  xrange,
  symbolsize,
  precision = 4,
  use_dummy_device = FALSE,
  ...
)
```

## Arguments

- cex:

  Character expansion of the text

- id:

  A character vector with the identifiers of each individuals

- maxlev:

  Maximum level

- xrange:

  Range of x values

- symbolsize:

  Size of the symbols

- precision:

  The number of significant digits to round the solution to.

- ...:

  Other arguments passed to
  [`par()`](https://rdrr.io/r/graphics/par.html)

## Value

List of user coordinates, old par, box width, box height, label height
and leg height
