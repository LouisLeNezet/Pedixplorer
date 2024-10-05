# NEWS

NEWS file for the Pedixplorer package

## Changes in version 1.1.4

- Update website and logo
- Improve `ped_shiny()` esthetics
- Change plot element order rendering for better looks
- Add more control to line width of box and lines
- Improve legend ordering
- Separate website building workflow from check
- Update documentation and set to internal all unnecessary functions for users
- Stabilize unit test

## Changes in version 1.1.3

- Fix github workflows
- Disable `ped_shiny()` execution in markdown
- Publish with `pkgdown`

## Changes in version 1.1.2

- Use R version 4.4 and update workflows

## Changes in version 1.1.1

- A [shiny application](https://shiny.posit.co/) is now available through
the `ped_shiny()` function.
- Function imports have been cleaned.
- Unit tests have been added as well as more snapshot to increase
package coverage.
- `relped` dataset allows to easily test special relationship.
- Documentation is enhanced and correctly linted.
- `precision` parameter has been added to `align4()` and `set_plot_area()`
to reduce noise between platform.
- `fix_parents()` has been fixed and improved.
- More controls over color setting with `generate_colors()`.
- Possibility to force computation of alignement when it fails with
`force = TRUE`.
- `upd_famid_id()` to `upd_famid()`.
- Zooming in a pedigree object is now done by subsetting the dataframe
computed by `ped_to_plotdf()`.
- `useful_inds()` function has been improved.

## Changes in version 0.99.0

- Kinship2 is renamed to Pedixplorer and hosted on Bioconductor.
- Pedigree is now a S4 object, all functions are updated to work with
the new class
- Pedigree constructor now takes a data.frame as input for the Pedigree
informations and for the special relationship.
The two data.fram are normalized before being used.
- plot.pedigree support ggplot generation, mark and label can be added
to the plot.
The plot is now generated in two steps ped_to_plotdf() and plot_fromdf().
This allows the user to modify the plot before it is generated.
- All documentation are now generated with Roxygen
- New function available: generate_aff_inds, generate_colors,
is_informative, min_dist_inf, normData, num_child, useful_inds
- All functions renamed to follow the snake\_case convention
- All parameters renamed to follow the snake\_case convention
- All test now use testthat files
- Vignettes have been updated to reflect the new changes
