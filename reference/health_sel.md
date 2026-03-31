# Shiny module to select a health variable in a pedigree

This module allows to select health variables in a pedigree object. The
function is composed of two parts: the UI and the server. The UI is
called with the function `health_sel_ui()` and the server with the
function `health_sel_server()`.

## Usage

``` r
health_sel_ui(id)

health_sel_server(
  id,
  pedi,
  var = NULL,
  as_num = NULL,
  mods_aff = NULL,
  threshold = NULL,
  sup_threshold = NULL
)

health_sel_demo()
```

## Arguments

- id:

  A string to identify the module.

- pedi:

  A reactive pedigree object.

- var:

  A string with the name of the health variable to select.

- as_num:

  A boolean to know if the health variable needs to be considered as
  numeric.

- mods_aff:

  A character vector of the affected modalities.

- threshold:

  A numeric threshold to determine affected individuals.

- sup_threshold:

  A boolean to know if the affected individuals are strickly superior to
  the threshold.

## Value

A reactive list with the following informations:`actions-box`

- health_var: the selected health variable,

- to_num: a boolean to know if the health variable needs to be
  considered as numeric,

- mods_aff: a character vector of the affected modalities,

- threshold: a numeric threshold to determine affected individuals,

- sup_threshold: a boolean to know if the affected individuals are
  strickly superior to the threshold.

## Examples

``` r
if (interactive()) {
    health_sel_demo()
}
```
