# Run Pedixplorer Shiny application

This function creates a shiny application to manage and visualize
pedigree data using the
[`ped_ui()`](https://louislenezet.github.io/Pedixplorer/reference/ped_ui.md)
and
[`ped_server()`](https://louislenezet.github.io/Pedixplorer/reference/ped_server.md)
functions.

## Usage

``` r
ped_shiny(
  port = getOption("shiny.port"),
  host = getOption("shiny.host", "127.0.0.1"),
  precision = 6,
  ind_max_warning = 300,
  ind_max_error = 500
)
```

## Arguments

- port:

  (optional) Specify port the application should list to.

- host:

  (optional) The IPv4 address that the application should listen on.

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

Running Shiny Application

## Details

The application is composed of several modules:

- Data import

- Data column selection

- Data download

- Family selection

- Health selection

- Informative selection

- Subfamily selection

- Plotting pedigree

- Family information

## Examples

``` r
if (interactive()) {
    ped_shiny()
}
```
