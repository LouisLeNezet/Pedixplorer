## Changes in v1.3.1

- Add support for `.ped`, `.tsv` files in data import
- `is_informative` independent from `useful_inds`
- Use directly columns names from `fill` instead of the mods columns
- Move to R 4.4 and Bioc 3.20
- Fix unittests and update snapshots
- Change normalisation process to directly use `id`, `dadid`, `momid`, `famid`, `sex`
no more need for `indId`, `fatherId`, ...
- `affection` is now used as default affection modality columns that will be
used to generate `affected`
- `status` is replaced by `deceased`
- `steril` is replaced by `fertility` and corresponding symbols is added for
`infertile` and `infertile_choice_na`
- `terminated` is deleted
- `miscarriage`, `evaluated`, `consultand`, `proband`, `carrier`, `asymptomatic` and
`adopted` are now recognize and use for plotting
- Argument order of `Ped()` as changed when using vectors. This choice has been made
for a better consistency across the package. Please check that your argument are
properly named (i.e. `sex` has been moved after `famid` and `avail` after `deceased`).

## Changes in v1.2.0

- Change code of ped_to_legdf
- When plotting with the main plot, the legend gets its own
space separate from the plot. This allow better control over
the size and localisation of the legend.
- The graphical parameters are reset after each use of plot_fromdf
- Add tooltips control in Pedigree plots and add it to the app
- Add example of interactivness in vignette
- Fix plot area function and legend creation for better alignment

## Changes in v1.1.4

- Update website and logo
- Improve `ped_shiny()` esthetics
- Change plot element order rendering for better looks
- Add more control to line width of box and lines
- Improve legend ordering
- Separate website building workflow from check
- Update function documentation and set to internal all unnecessary
functions for users
- Stabilize unit test
- Standardize the vignettes and add more documentation
- Fix label adjusting position in plot functions

## Changes in v1.1.3

- Fix github workflows
- Disable `ped_shiny()` execution in markdown
- Publish with `pkgdown`

## Changes in v1.1.2

- Use R version 4.4 and update workflows

## Changes in v1.1.1

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

## Changes in v0.99.0

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
