# Render a resizable plot in a Shiny app

This function render a Shiny module into a resizable one. It uses the
`shinyjqui` package to make the plot resizable.

## Usage

``` r
plot_resize_ui(id)

plot_resize_server(id, plot_ui_fn, init_width = "80%", init_height = "400px")

plot_resize_demo(interactive = FALSE)
```

## Arguments

- id:

  A string to identify the module.

- plot_ui_fn:

  A function to generate the UI of the plot.

- init_width:

  A string to set the initial width of the plot.

- init_height:

  A string to set the initial height of the plot.

- interactive:

  A boolean to indicate if the plot is interactive.

## Value

A reactive list containing the width and height of the plot.

## Examples

``` r
if (interactive()) {
   plot_resize_demo(interactive = FALSE)
}
```
