# Plot Pedigrees

This function is used to plot a Pedigree object.

It is a wrapper for
[`plot_fromdf()`](https://louislenezet.github.io/Pedixplorer/reference/plot_fromdf.md)
and
[`ped_to_plotdf()`](https://louislenezet.github.io/Pedixplorer/reference/ped_to_plotdf.md)
as well as
[`ped_to_legdf()`](https://louislenezet.github.io/Pedixplorer/reference/ped_to_legdf.md)
if `legend = TRUE`.

## Usage

``` r
# S4 method for class 'Pedigree,missing'
plot(
  x,
  aff_mark = TRUE,
  id_lab = "id",
  label = NULL,
  ggplot_gen = FALSE,
  cex = 1,
  symbolsize = 1,
  branch = 0.6,
  packed = TRUE,
  align = c(1.5, 2),
  align_parents = TRUE,
  force = FALSE,
  width = 6,
  title = NULL,
  subreg = NULL,
  pconnect = 0.5,
  fam_to_plot = 1,
  legend = FALSE,
  leg_cex = 0.8,
  leg_symbolsize = 0.5,
  leg_loc = NULL,
  leg_adjx = 0,
  leg_adjy = 0,
  precision = 4,
  lwd = 1,
  ped_par = list(),
  leg_par = list(),
  tips = NULL,
  title_cex = 2,
  leg_usr = NULL,
  add_to_existing = FALSE,
  label_dist = c(1, 3, 5),
  label_cex = c(1, 0.7, 1)
)
```

## Arguments

- x:

  A Pedigree object.

- aff_mark:

  If `TRUE`, add a aff_mark to each box corresponding to the value of
  the affection column for each filling scale.

- id_lab:

  The column name of the id for each individuals.

- label:

  If not `NULL`, add a label to each box under the id corresponding to
  the value of the column given.

- ggplot_gen:

  If `TRUE`, the function will use the `ggplot2` package to generate the
  plot.

- cex:

  Character expansion of the text

- symbolsize:

  Size of the symbols

- branch:

  defines how much angle is used to connect various levels of nuclear
  families.

- packed:

  Should the Pedigree be compressed. (i.e. allow diagonal lines
  connecting parents to children in order to have a smaller overall
  width for the plot.)

- align:

  For a packed Pedigree, align children under parents `TRUE`, to the
  extent possible given the page width, or align to to the left margin
  `FALSE`. This argument can be a two element vector, giving the
  alignment parameters, or a logical value. If `TRUE`, the default is
  `c(1.5, 2)`, or if numeric the routine
  [`alignped4()`](https://louislenezet.github.io/Pedixplorer/reference/alignped4.md)
  will be called.

- align_parents:

  If `align_parents = TRUE`, go one step further and try to make both
  parents of each child have the same depth. (This is not always
  possible). It helps the drawing program by lining up pedigrees that
  'join in the middle' via a marriage.

- force:

  If `force = TRUE`, the function will return the depth minus
  `min(depth)` if `depth` reach a state with no founders is not
  possible.

- width:

  For a packed output, the minimum width of the plot, in inches.

- title:

  The title of the plot.

- subreg:

  A 4-element vector for (min x, max x, min depth, max depth), used to
  edit away portions of the plot coordinates returned by
  [`ped_to_plotdf()`](https://louislenezet.github.io/Pedixplorer/reference/ped_to_plotdf.md).
  This is useful for zooming in on a particular region of the Pedigree.

- pconnect:

  When connecting parent to children the program will try to make the
  connecting line as close to vertical as possible, subject to it lying
  inside the endpoints of the line that connects the children by at
  least `pconnect` people. Setting this option to a large number will
  force the line to connect at the midpoint of the children.

- fam_to_plot:

  default=1. If the Pedigree contains multiple families, this parameter
  can be used to select which family to plot. It can be a numeric value
  or a character value. If numeric, it is the index of the family to
  plot returned by `unique(x$ped$famid)`. If character, it is the family
  id to plot.

- legend:

  default=FALSE. If TRUE, a legend will be added to the plot.

- leg_cex:

  default=0.8. Controls the size of the legend text.

- leg_symbolsize:

  default=0.5. Controls the size of the legend symbols.

- leg_loc:

  default=NULL. If NULL, the legend will be placed in the upper right
  corner of the plot. Otherwise, a 4-element vector of the form (x0, x1,
  y0, y1) can be used to specify the location of the legend. The legend
  will be fitted to the specified and might be distorted if the aspect
  ratio of the legend is different from the aspect ratio of the
  specified location.

- leg_adjx:

  default=0. Controls the horizontal labels adjustment of the legend.

- leg_adjy:

  default=0. Controls the vertical labels adjustment of the legend.

- precision:

  The number of significatif numbers to round the solution to.

- lwd:

  default=1. Controls the line width of the segments, arcs and polygons.

- ped_par:

  default=list(). A list of parameters to use as graphical parameters
  for the main plot.

- leg_par:

  default=list(). A list of parameters to use as graphical parameters
  for the legend.

- tips:

  A character vector of the column names of the data frame to use as
  tooltips. If `NULL`, no tooltips are added.

- title_cex:

  The size of the title.

- leg_usr:

  default=NULL. A vector of user coordinates to use for the legend.

- add_to_existing:

  If `TRUE`, the plot will be added to the current plot.

- label_dist:

  A numeric vector of length 3 giving the distance between the id, date
  and label text and the bottom of the box. This value is multiplied by
  the obtained `labh` value.

- label_cex:

  A numeric vector of length 3 giving the cex of the id, date and label
  text. This value is multiplied by the `cex` argument

## Value

an invisible list containing

- df : the data.frame used to plot the Pedigree

- par_usr : the user coordinates used to plot the Pedigree

- ggplot : the ggplot object if ggplot_gen = TRUE

## Details

Two important parameters control the looks of the result. One is the
user specified maximum width. The smallest possible width is the maximum
number of subjects on a line, if the user's suggestion is too low it is
increased to 1 + that amount (to give just a little wiggle room).

To make a Pedigree where all children are centered under parents simply
make the width large enough, however, the symbols may get very small.

The second is `align`, a vector of 2 alignment parameters `a` and `b`.
For each set of siblings at a set of locations `x` and with parents at
`p=c(p1,p2)` the alignment penalty is

\$\$(1/k^a)\sum{i=1}{k} \[(x_i - (p1+p2)/2)\]^2\$\$

\$\$\sum(x- \overline(p))^2/(k^a)\$\$

Where k is the number of siblings in the set.

When `a = 1` moving a sibship with `k` sibs one unit to the left or
right of optimal will incur the same cost as moving one with only 1 or
two sibs out of place.

If `a = 0` then large sibships are harder to move than small ones, with
the default value `a = 1.5` they are slightly easier to move than small
ones. The rationale for the default is as long as the parents are
somewhere between the first and last siblings the result looks fairly
good, so we are more flexible with the spacing of a large family. By
tethering all the sibs to a single spot they are kept close to each
other. The alignment penalty for spouses is \\b(x_1 - x_2)^2\\, which
tends to keep them together. The size of `b` controls the relative
importance of sib-parent and spouse-spouse closeness.

## Side Effects

Creates plot on current plotting device.

## See also

[`Pedigree()`](https://louislenezet.github.io/Pedixplorer/reference/Pedigree-class.md)

## Examples

``` r
data(sampleped)
pedAll <- Pedigree(sampleped)
if (interactive()) { plot(pedAll) }
```
