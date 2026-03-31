# Shiny modules to display family information

This module allows to display the health and availability data for all
individuals in a pedigree object. The output is a datatable. The
function is composed of two parts: the UI and the server. The UI is
called with the function `ped_avaf_infos_ui()` and the server with the
function `ped_avaf_infos_server()`.

## Usage

``` r
ped_avaf_infos_ui(id)

ped_avaf_infos_server(id, pedi, title = "Family informations", height = "auto")

ped_avaf_infos_demo(height = "auto")
```

## Arguments

- id:

  A string to identify the module.

- pedi:

  A reactive pedigree object.

- title:

  The title of the module.

- height:

  The height of the datatable.

## Value

A reactive dataframe with the selected columns renamed to the names of
cols_needed and cols_supl.

## Examples

``` r
if (interactive()) {
    ped_avaf_infos_demo()
}
```
