# Shiny module to select the informative individuals in a pedigree

This module allows to select informative individuals in a pedigree
object. They will be used to subset the pedigree object with the
function
[`useful_inds()`](https://louislenezet.github.io/Pedixplorer/reference/useful_inds.md).
Further filtering options are available (max kinship and keep parents).
The function is composed of two parts: the UI and the server. The UI is
called with the function `inf_sel_ui()` and the server with the function
`inf_sel_server()`.

## Usage

``` r
inf_sel_ui(id)

inf_sel_server(id, pedi, help_colour = "grey")

inf_sel_demo(pedi)
```

## Arguments

- id:

  A string to identify the module.

- pedi:

  A reactive pedigree object.

- help_colour:

  A string to define the colour of the help icon.

## Value

A reactive pedigree object subselected from the informative individuals.

## Examples

``` r
if (interactive()) {
    data("sampleped")
    pedi <- shiny::reactive({
        Pedigree(sampleped[sampleped$famid == "1", ])
    })
    inf_sel_demo(pedi)
}
```
