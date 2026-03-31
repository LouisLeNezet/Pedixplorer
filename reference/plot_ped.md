# Internal function to generate the plot

This function is used by the Shiny module to generate the plot. If the
`interactive` argument is set to TRUE, it generates an interactive plot
using `plotly`. If it is set to FALSE, it generates a static plot
function.

This module allows to plot a pedigree object. The plot can be
interactive. The function is composed of two parts: the UI and the
server. The UI is called with the function `plot_ped_ui()` and the
server with the function `plot_ped_server()`.

## Usage

``` r
plot_ped_ui(id)

app_plot_fct(
  pedi,
  cex = 1,
  plot_par = list(),
  interactive = FALSE,
  mytitle = "My Pedigree",
  precision = 2,
  lwd = 1,
  aff_mark = TRUE,
  label = NULL,
  symbolsize = 1,
  force = TRUE,
  mytips = NULL,
  align_parents = TRUE
)

plot_ped_server(
  id,
  pedi,
  my_title = NA,
  precision = 2,
  my_tips = NULL,
  plot_lwd = 1,
  width = "80%",
  height = "400px",
  plot_cex = 1,
  symbolsize = 1,
  force = TRUE,
  plot_par = list(),
  is_interactive = FALSE,
  aff_mark = TRUE,
  label = NULL,
  computebest = FALSE,
  tolerance = 5,
  align_parents = TRUE,
  timeout = 60
)

plot_ped_demo(pedi = NULL, precision = 4, interactive = FALSE)
```

## Arguments

- id:

  A string.

- pedi:

  A reactive pedigree object.

- cex:

  A numeric to set the size of the text.

- plot_par:

  A list of parameters to pass to the plot function.

- interactive:

  A boolean to set if the plot is interactive.

- mytitle:

  A string to set the title of the plot.

- precision:

  An integer to set the precision of the plot.

- lwd:

  A numeric to set the line width of the plot.

- aff_mark:

  A boolean to set if the affected individuals should be marked.

- label:

  A string to set the label of the plot.

- symbolsize:

  A numeric to set the size of the symbols.

- force:

  A boolean to set if the plot should be forced.

- mytips:

  A character vector of the column names of the data frame to use as
  tooltips. If NULL, no tooltips are added.

- my_title:

  A string to name the plot.

- my_tips:

  A character vector of the column names of the data frame to use as
  tooltips. If NULL, no tooltips are added.

- plot_lwd:

  A numeric to set the line width of the plot.

- width:

  A numeric to set the width of the plot.

- height:

  A numeric to set the height of the plot.

- plot_cex:

  A numeric to set the size of the text.

- is_interactive:

  A boolean to set if the plot is interactive.

## Value

A function or a plotly object.

A reactive ggplot or the pedigree object.

## Examples

``` r
data("sampleped")
pedi <- Pedigree(sampleped[sampleped$famid == "1", ])
Pedixplorer:::app_plot_fct(
   pedi, cex = 1, plot_par = list(),
   interactive = FALSE,
   mytitle = "My Pedigree",
   precision = 2, lwd = 1
)
#> function () 
#> {
#>     plot(pedi, ggplot_gen = interactive, aff_mark = TRUE, label = NULL, 
#>         cex = cex, symbolsize = symbolsize, force = force, ped_par = plot_par, 
#>         title = mytitle, tips = mytips, precision = precision, 
#>         lwd = lwd, align_parents = align_parents)
#> }
#> <bytecode: 0x556c53218148>
#> <environment: 0x556c53211388>
if (interactive()) {
    data("sampleped")
    pedi <- shiny::reactive({
        Pedigree(sampleped[sampleped$famid == "1", ])
    })
    plot_ped_demo(pedi)
}
```
