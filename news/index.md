# Changelog

## Changes in v1.7.1

- Fix slices in
  [`circfun()`](https://louislenezet.github.io/Pedixplorer/reference/circfun.md)
- Add contributing guidelines
- Replace dplyr pipe `%>%` by `|>`

## Changes in v1.5.6

- Fix legend plotting when ggplot_gen is TRUE
- Reduce
  [`kindepth()`](https://louislenezet.github.io/Pedixplorer/reference/kindepth.md)
  warning and error messages to show necessary information.
- Fix lwd usage instead of cex in
  [`ped_to_legdf()`](https://louislenezet.github.io/Pedixplorer/reference/ped_to_legdf.md)

## Changes in v1.5.5

- Add `label_cex` and `label_size` to control id, date and label text
  position and size
- Fix csv reading with incoherent number of columns in rows
- Fix check box align_parents in
  [`ped_shiny()`](https://louislenezet.github.io/Pedixplorer/reference/ped_shiny.md)
- Fix
  [`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md)
  error when couple present twice
- Fix stress computation when individual present more than twice
- Add `ind_max_warning` and `ind_max_error` for a better control of
  pedigree size to plot in shiny application

## Changes in v1.5.4

- Add `best_hint` computation to the shiny app and split it in different
  subfunction
- Remove little used library from Imports
- Change
  [`shinyWidgets::pickerInput`](https://dreamrs.github.io/shinyWidgets/reference/pickerInput.html)
  to
  [`shiny::selectInput`](https://rdrr.io/pkg/shiny/man/selectInput.html)
- Remove `0` from default `na_strings`
- Update citation to use published article in Bioinformatics
- Add error for `_` present in any id columns
- Fix shiny app notification title and slider intermediary value
  selection
- Fix full scale data reaffection on same column
- Improve position and size of proband label and assymptomatic symbol
  for logo

## Changes in v1.5.3

- Add short explanation of
  [`hints()`](https://louislenezet.github.io/Pedixplorer/reference/Pedigree-class.md)
  usage in `Pedigree alignment details` vignette.

## Changes in v1.5.2

- Fix resizing plot in shiny module by adding dependency
- Update website and readme

## Changes in v1.5.1

- Separate plot management in a shiny module
- Add `plot_resize` shiny module
- Add help messages using `shinyhelper`
- Add `plink_to_pedigree` function to convert plink files to Pedigree
  object
- Add `0` as one of the default missing identifier value
- Set ggplot generation as independent without plotting on current
  device
- All `draw_*` functions return a layer instead of a ggplot object
- Add back message for individuals not plotted
- Add autocompletion of missing twins relationship with
  [`complete_twins()`](https://louislenezet.github.io/Pedixplorer/reference/complete_twins.md)

## Changes in v1.3.4

- Add example of interactivness in vignette
- Fix label adjusting position in plot functions
- Fix arrow size in ggplot

## Changes in v1.3.1

- Add support for `.ped`, `.tsv` files in data import
- `is_informative` independent from `useful_inds`
- Use directly columns names from `fill` instead of the mods columns
- Move to R 4.4 and Bioc 3.20
- Fix unittests and update snapshots
- Change normalisation process to directly use `id`, `dadid`, `momid`,
  `famid`, `sex` no more need for `indId`, `fatherId`, …
- `affection` is now used as default affection modality columns that
  will be used to generate `affected`
- `status` is replaced by `deceased`
- `steril` is replaced by `fertility` and corresponding symbols is added
  for `infertile` and `infertile_choice_na`
- `terminated` sex code is replace by `miscarriage` new slot
- `miscarriage`, `evaluated`, `consultand`, `proband`, `carrier`,
  `asymptomatic` and `adopted` are now recognize and use for plotting
- Argument order of
  [`Ped()`](https://louislenezet.github.io/Pedixplorer/reference/Ped-class.md)
  as changed when using vectors. This choice has been made for a better
  consistency across the package. Please check that your argument are
  properly named (i.e. `sex` has been moved after `famid` and `avail`
  after `deceased`).
- Shiny application is updated and improved (aesthetics, errors,
  warnings, functionnalities).
- Add `dateofbirth` and `dateofdeath` to the `Ped` object
- Changee from `round` to `signif` for the `precision` argument
- Improve stability of test by adding and controlling the
  [`options()`](https://rdrr.io/r/base/options.html) and
  [`par()`](https://rdrr.io/r/graphics/par.html) arguments in the
  unittests.
- `Carrier` symbols is proportional to the mean of the box size

## Changes in v1.2.0

- Change code of ped_to_legdf
- When plotting with the main plot, the legend gets its own space
  separate from the plot. This allow better control over the size and
  localisation of the legend.
- The graphical parameters are reset after each use of plot_fromdf
- Add tooltips control in Pedigree plots and add it to the app
- Add example of interactivness in vignette
- Fix plot area function and legend creation for better alignment

## Changes in v1.1.4

- Update website and logo
- Improve
  [`ped_shiny()`](https://louislenezet.github.io/Pedixplorer/reference/ped_shiny.md)
  esthetics
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
- Disable
  [`ped_shiny()`](https://louislenezet.github.io/Pedixplorer/reference/ped_shiny.md)
  execution in markdown
- Publish with `pkgdown`

## Changes in v1.1.2

- Use R version 4.4 and update workflows

## Changes in v1.1.1

- A [shiny application](https://shiny.posit.co/) is now available
  through the
  [`ped_shiny()`](https://louislenezet.github.io/Pedixplorer/reference/ped_shiny.md)
  function.
- Function imports have been cleaned.
- Unit tests have been added as well as more snapshot to increase
  package coverage.
- `relped` dataset allows to easily test special relationship.
- Documentation is enhanced and correctly linted.
- `precision` parameter has been added to `align4()` and
  [`set_plot_area()`](https://louislenezet.github.io/Pedixplorer/reference/set_plot_area.md)
  to reduce noise between platform.
- [`fix_parents()`](https://louislenezet.github.io/Pedixplorer/reference/fix_parents.md)
  has been fixed and improved.
- More controls over color setting with
  [`generate_colors()`](https://louislenezet.github.io/Pedixplorer/reference/generate_colors.md).
- Possibility to force computation of alignement when it fails with
  `force = TRUE`.
- `upd_famid_id()` to
  [`upd_famid()`](https://louislenezet.github.io/Pedixplorer/reference/upd_famid.md).
- Zooming in a pedigree object is now done by subsetting the dataframe
  computed by
  [`ped_to_plotdf()`](https://louislenezet.github.io/Pedixplorer/reference/ped_to_plotdf.md).
- [`useful_inds()`](https://louislenezet.github.io/Pedixplorer/reference/useful_inds.md)
  function has been improved.

## Changes in v0.99.0

- Kinship2 is renamed to Pedixplorer and hosted on Bioconductor.
- Pedigree is now a S4 object, all functions are updated to work with
  the new class
- Pedigree constructor now takes a data.frame as input for the Pedigree
  informations and for the special relationship. The two data.fram are
  normalized before being used.
- plot.pedigree support ggplot generation, mark and label can be added
  to the plot. The plot is now generated in two steps ped_to_plotdf()
  and plot_fromdf(). This allows the user to modify the plot before it
  is generated.
- All documentation are now generated with Roxygen
- New function available: generate_aff_inds, generate_colors,
  is_informative, min_dist_inf, normData, num_child, useful_inds
- All functions renamed to follow the snake_case convention
- All parameters renamed to follow the snake_case convention
- All test now use testthat files
- Vignettes have been updated to reflect the new changes
