# Shiny module to export plot

This module allow to export multiple type of plot from a reactive
object. The file type currently supported are png, pdf and html. The
function is composed of two parts: the UI and the server. The UI is
called with the function `plot_download_ui()` and the server with the
function `plot_download_server()`.

## Usage

``` r
plot_download_ui(id)

plot_download_server(
  id,
  my_plot,
  plot_class,
  filename = "saveplot",
  label = "Download",
  width = 500,
  height = 500
)

plot_download_demo()
```

## Arguments

- id:

  A string.

- my_plot:

  Reactive object containing the plot or the plot function.

- plot_class:

  A string to define the class of the plot ("ggplot", "htmlwidget",
  "plotly", "grob" or "function").

- filename:

  A string to name the file.

- label:

  A string to name the download button.

- width:

  A numeric to set the width of the plot.

- height:

  A numeric to set the height of the plot.

## Value

A shiny module to export a plot.

## Examples

``` r
if (interactive()) {
    plot_download_demo()
}
```
