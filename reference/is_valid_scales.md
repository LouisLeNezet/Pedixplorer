# Check if a Scales object is valid

Check if the fill and border slots are valid:

- fill slot is a data.frame with "order", "column_values",
  "column_mods", "mods", "labels", "affected", "fill", "density",
  "angle" columns.

  - "affected" is logical.

  - "density", "angle", "order", "mods" are numeric.

  - "column_values", "column_mods", "labels", "fill" are character.

- border slot is a data.frame with "column_values", "column_mods",
  "mods", "labels", "border" columns.

  - "column_values", "column_mods", "labels", "border" are character.

  - "mods" is numeric.

## Usage

``` r
is_valid_scales(object)
```

## Arguments

- object:

  A Scales object.

## Value

A character vector with the errors or `TRUE` if no errors.
