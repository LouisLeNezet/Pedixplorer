# Shiny module to select a family in a pedigree

This module allows to select a family in a pedigree object. The function
is composed of two parts: the UI and the server. The UI is called with
the function `family_sel_ui()` and the server with the function
`family_sel_server()`.

## Usage

``` r
family_sel_ui(id)

family_sel_server(
  id,
  pedi,
  fam_var = NULL,
  fam_sel = NULL,
  title = "Family selection",
  help_text = NULL,
  help_title = "Family selection",
  help_colour = "grey",
  help_type = "inline"
)

family_sel_demo(fam_var = NULL, fam_sel = NULL, title = "Family selection")
```

## Arguments

- id:

  A string to identify the module.

- pedi:

  A reactive pedigree object.

- fam_var:

  The default family variable to use as family indicator.

- fam_sel:

  The default family to select.

- title:

  The title of the module.

## Value

A reactive list with the subselected pedigree object and the selected
family id.

## Examples

``` r
if (interactive()) {
    family_sel_demo()
}
```
