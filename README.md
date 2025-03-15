# `Pedixplorer`: a BioConductor package to create, filter and draw pedigree

<!-- badges: start -->
  [![Release](https://img.shields.io/badge/release%20version-1.1.0-green.svg)](https://www.bioconductor.org/packages/Pedixplorer)
  [![Platform](http://www.bioconductor.org/shields/availability/devel/Pedixplorer.svg)](https://www.bioconductor.org/packages/release/bioc/html/Pedixplorer.html#archives)
  [![rank](http://www.bioconductor.org/shields/downloads/release/Pedixplorer.svg)](http://bioconductor.org/packages/stats/bioc/Pedixplorer/)
  [![BioC Status](https://bioconductor.org/shields/build/devel/bioc/Pedixplorer.svg)](http://bioconductor.org/checkResults/devel/bioc-LATEST/Pedixplorer/)
  [![codecov](https://codecov.io/gh/LouisLeNezet/Pedixplorer/graph/badge.svg?token=ZFQ3GZJ4BL)](https://codecov.io/gh/LouisLeNezet/Pedixplorer)
<!-- badges: end -->

|||
|-|-|
| This is a fork and the new version of the [**kinship2**](https://github.com/mayoverse/kinship2) package. Initially a set of functions to view pedigrees while developing models that use kinship matrices, the functions were useful enough to put into a package of its own. It has now an S4 class for pedigrees, a kinship function that calculates the kinship matrix from a Pedigree object, and the Pedigree plotting routines that adhere to many of the standards for genetics counselors. | <img src="https://github.com/LouisLeNezet/Pedixplorer/raw/devel/inst/figures/icon_Pedixplorer.png" align="right" max-height="140" style="align:center;max-height:200px;"/> |

> Try today the [**Pedixplorer shiny app**](https://pedixplorer.univ-rennes.fr/) to easily use the package.

## Installation through R

### From Github

```R
if (!require("remotes", quietly = TRUE))
    install.packages("remotes")

remotes::install_github("louislenezet/Pedixplorer",
    build_vignettes=TRUE
)
```

### From Bioconductor

```R
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("Pedixplorer")
```

## Main functions

### The `Pedigree()` Function

`Pedigree()` is a function that creates an S4 class Pedigree object.
The core slot of the Pedigree object is the `ped` slot built from having a row
per person, linked by the father id and mother id. Other relationships can be
specified, and affection status can be a matrix of multiple categories in the
`rel` slot. All the informations about how the affection and availability have
to be draw are stored respectively in `scales$fill` and `scales$border` slots
They are used to fill and color the border for each elements of the Pedigree graph.

### The `generate_colors()` Function

`generate_colors()` is a function that generates a color palette for an
affection status. This function is used by the `Pedigree()` function to
generate the `scales$fill` and `scales$border` slots. The user can also
use this function to generate a color palette for a specific affection
status that will be added to the Pedigree object.

### The `plot()` Method

A Pedigreee `plot()` S4 method is available to plot the object as a
"family tree", with relatives of the same generation on the same row,
and affection statuses divided over the plot symbol for each person.
This function is designed in two steps:

1. First the Pedigree object is converted into a data frame with all the
elements needed to plot the Pedigree (i.e. boxes, lines, text, etc.).
This is done by the `ped_to_plotdf()` function.
2. Then the data frame is plotted using the `plot_fromdf()` function.

### The `kinship()` Funtion

`kinship()` is a function that creates the kinship matrix from a Pedigree
object. It is coded for dyplotype organisms, handling all relationships that
can be specified for the Pedigree object, including inbreeding, monozygotic
twins, etc. A recent addition is handling the kinship matrix for the X and Y
chromosomes.

### The `ped_shiny()` Function

| | |
|-|-|
| To help anyone to easily use all the main functions of the package a shiny app has been created, allowing you to import your data, normalise it, select the family and filter the resulting `Pedigree` object before visualising it. You'll also be able to download the resulting data and plot. The application is also available on a Virtual Machine accessible at [pedixplorer.univ-rennes](https://pedixplorer.univ-rennes.fr/).| <img src="https://github.com/LouisLeNezet/Pedixplorer/raw/devel/inst/figures/ShinyAppDiagram.png" alt="shiny-app_diagram" align="right" max-width="300" style="max-width:300px;align:right;"/>|

### Other Notable Functions

* `useful_ind()` automatically find the individuals close to a given
set of individuals, allowing to split the Pedigree in smaller
family for an easier representation.

* `shrink()` will shrink a Pedigree to a given size, keeping the most
informative individuals for a single affection variable.

* `fix_parents()` will add parents for children who have a mother or dad listed
that is not already included. It will also fix the sex status for the parent if
it is mis-specified. This is useful to use before creating the **Pedigree**
object.

### Example

Here is a simple example that show how to represent a complex pedigree with a lot of different information.

```R
library(Pedixplorer)
library(dplyr)
data("sampleped")
data("relped")

# Create the Pedigree object
pedi <- Pedigree(sampleped, relped, missid = NA) %>%
    generate_colors( # Add a new affection information
        col_aff = "num", is_num = TRUE,
        keep_full_scale = TRUE, breaks = 2,
        threshold = 3,
        colors_aff = c("#8B7355", "#FFA500"),
        colors_unaff = c("#8aca25", "#3fb7db")
    ) %>%
    is_informative( # Set which individuals are informative
        col_aff = "num", informative = "AvAf"
    ) %>%
    useful_inds(
        keep_infos = TRUE, # Keep available or affected parents 
        max_dist = 2 # Maximum distance from informative individuals
    )

proband(ped(pedi)) <- isinf(ped(pedi)) # Set informative individuals as proband

plot_list <- plot(
    pedi,
    symbolsize = 1.5, # Increase the symbole size
    title = "My pedigree", # Add a title
    legend = TRUE, # Add the legend
    leg_symbolsize = 0.02, # Set the symbole size of the legend
    leg_loc = c(0.5, 0.9, 0.8, 1.1), # Specify the legend location
    lwd = 0.5, # Set the line width
    ggplot_gen = TRUE, # Use ggplot2 to draw the Pedigree
    tips = c(
        "id", "avail",
        "affection",
        "num", "dateofbirth"
    ) # Add some information in the tooltip
)

plotly::ggplotly(
    plot_list$ggplot,
    tooltip = "text"
) %>%
    plotly::layout(hoverlabel = list(bgcolor = "darkgrey"))
```

<p align="center">
    <iframe src="https://github.com/LouisLeNezet/Pedixplorer/raw/fix_plot/inst/figures/interactive_pedigree.html" alt="MyPedigree" height="400" style="height:400px;"></iframe>
</p>

## Documentation and News

To view documentation start R and enter:

```R
library(Pedixplorer)
help(package="Pedixplorer")

# Or to view the vignettes
browseVignettes("Pedixplorer")

# Or to see the news
utils::news(package="Pedixplorer")
```
