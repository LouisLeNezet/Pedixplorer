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
`rel` slot. All the informations about affection and availability are be stored
respectively in `scales$fill` and `scales$border` slots and are therefore used
to fill and color the border for each elements of the Pedigree graph.

### The `generate_colors()` Function

`generate_colors()` is a function that generates a color palette for an
affection status. This function is used by the `Pedigree()` function to
generate the `scales$fill` and `scales$border` slots. The user can also
use this function to generate a color palette for a specific affection
status that will be added to the Pedigree object.

### The `plot.Pedigree()` Method

`plot.Pedigree()` is a method for a Pedigree object that plots as a
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

* `shrink()` will shrink a Pedigree to a given size, keeping the most
informative individuals for a single affection variable.

* `fix_parents()` will add parents for children who have a mother or dad listed
that is not already included. It will also fix the sex status for the parent if
it is mis-specified. This is useful to use before creating the **Pedigree**
object.

## Diagrams

The diagrams below show the main functions of the package and how they are
related.

![Pedixplorer Diagram](https://github.com/LouisLeNezet/Pedixplorer/raw/devel/inst/figures/Pedixplorer_diagram.png)

### Details

Here is the details of the different parts of the diagram.

|       Process        |        Flow chart          |     Description      |
|:---------------------|:--------------------------:|----------------------|
| **S4 Pedixplorer creation** | <img src="https://github.com/LouisLeNezet/Pedixplorer/raw/devel/inst/figures/pedigreeobj.png" alt="pedigreeobj" width="800" style="width:800px;"/> | The *Pedigree S4 object* creation is done by the **Pedigree()** constructor function. It mainly normalise a *ped_df* dataframe containing the information of each individuals with the **norm_ped()** function and the *rel_df* dataframe containing the special relationship (i.e. twins, spouse with no child) with the **norm_rel()** function. Thereafter It calls the **generate_colors()** function to create the colors scales (i.e. filling and border) before validating the object with **is_valid()** |
| **Alignment**            | <img src="https://github.com/LouisLeNezet/Pedixplorer/raw/devel/inst/figures/alignment.png" alt="alignment" width="800" style="width:800px;"/>     | The alignment process is used to create a **plist** stroing the graphical disposition of the different individuals and their relation between them. The *hints* information used by **auto_hint()**, **align()** can be used by the user to force the ordering of some indiviuals |
| **Plotting**             | <img src="https://github.com/LouisLeNezet/Pedixplorer/raw/devel/inst/figures/plotting.png" alt="plotting" width="800" style="width:800px;"/>       | The plotting process is now separated in three distinct steps: <br> - **ped_to_plotdf()** is first called to convert the *S4 Pedigree object* into a dataframe listing all the graphical elements and their caracteristic. <br> - **ped_to_legdf()** does the same but for the legend informations. <br> - **plot_fromdf()** take as input such resulting dataframe and iteratively plot the elements based on their given characteristics. <br> All those steps are merge in one step with the **plot.Pedigree()** method. |
| **Shrinking**            | <img src="https://github.com/LouisLeNezet/Pedixplorer/raw/devel/inst/figures/shrinking.png" alt="shrinking" width="800" style="width:800px;"/>     | This process is useful when you want to reduce a huge Pedigree into a more simple version. The **shrink()** method will remove iteratively the less informative individuals from the Pedigree until it reach the *max_bits* size awaited |
| **Informations**         | <img src="https://github.com/LouisLeNezet/Pedixplorer/raw/devel/inst/figures/infos.png" alt="infos" width="800"/>             | From a *S4 Pedigree object* it is possible to extract a lot of informations about the individuals, such as their shared relatedness **kinship()**, the number of direct and indirect child **num_child()**, their informativeness based on a set variable **is_informative()**, ... |
| **Checking columns**     | <img src="https://github.com/LouisLeNezet/Pedixplorer/raw/devel/inst/figures/checkingcol.png" alt="checkingcol" height="200" style="height:200px;"/> | The **check_col()** function is used to check the presence absence of columns in a designated *data.frame* |
| **Legend**               | <img src="https://github.com/LouisLeNezet/Pedixplorer/raw/devel/inst/figures/legend.png" alt="legend" height="200"  style="height:200px;"/>           | The diagrams listed here follow this rules |

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
