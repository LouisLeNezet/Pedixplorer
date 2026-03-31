# Create the server logic for the ped_shiny application

Create the server logic for the ped_shiny application

## Usage

``` r
ped_server(
  input,
  output,
  session,
  precision = 6,
  ind_max_warning = 300,
  ind_max_error = 500
)
```

## Arguments

- input:

  The input object from a Shiny app.

- output:

  The output object from a Shiny app.

- session:

  The session object from a Shiny app.

- precision:

  Number of decimal for the position of the boxes in the plot.

- ind_max_warning:

  An integer to define the maximum number of individuals to plot before
  throwing a warning. If the number of individuals is greater than this
  value, the user will be asked to confirm the plot.

- ind_max_error:

  An integer to define the maximum number of individuals to plot before
  throwing an error. If the number of individuals is greater than this
  value, an error will be thrown and the plot will not be computed.

## Value

[`shiny::shinyServer()`](https://rdrr.io/pkg/shiny/man/shinyServer.html)

## Examples

``` r
if (interactive()) {
    ped_shiny()
}
```
