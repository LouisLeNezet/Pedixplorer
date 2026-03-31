# Shiny modules to select colours

This function allows to select different colours for an array of
variables.

## Usage

``` r
color_picker_ui(id)

color_picker_server(id, colors = NULL)

color_picker_demo()
```

## Arguments

- id:

  A string to identify the module.

- colors:

  A list of variables and their default colours.

## Value

A reactive list with the selected colours.

## Examples

``` r
if (interactive()) {
    color_picker_demo()
}
```
