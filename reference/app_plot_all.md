# Shiny module with all the components to plot a pedigree

This module plots a Pedigree object and allows to download the plot and
the data. Different options are available to customize the plot.

## Usage

``` r
plot_all_ui(id)

plot_all_server(
  id,
  pedi,
  ind_max_warning = 100,
  ind_max_error = 500,
  my_title_l = "My Pedigree",
  my_title_s = "ped_1",
  init_width = "100%",
  precision = 4
)

app_plot_all_demo(ind_max_warning = 10, ind_max_error = 30)
```

## Arguments

- id:

  A string to identify the module.

- pedi:

  A reactive pedigree object.

- ind_max_warning:

  An integer to define the maximum number of individuals to plot before
  throwing a warning. If the number of individuals is greater than this
  value, the user will be asked to confirm the plot.

- ind_max_error:

  An integer to define the maximum number of individuals to plot before
  throwing an error. If the number of individuals is greater than this
  value, an error will be thrown and the plot will not be computed.

- my_title_l:

  A string to define the title of the plot.

- my_title_s:

  A string to define the title of the plot for the download.

- init_width:

  A string to define the initial width of the plot.

- precision:

  An integer to define the precision of the plot.

## Value

A reactive list with the plot and the class of the plot.

## Examples

``` r
if (interactive()) {
   app_plot_all_demo()
}
```
