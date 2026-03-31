# Process the filling and border colors based on affection and availability

Perform transformation uppon a dataframe given to compute the colors for
the filling and the border of the individuals based on the affection and
availability status.

## Usage

``` r
# S4 method for class 'character'
generate_colors(
  obj,
  avail,
  mods_aff = NULL,
  is_num = FALSE,
  keep_full_scale = FALSE,
  colors_aff = c("yellow2", "red"),
  colors_unaff = c("white", "steelblue4"),
  colors_avail = c("green", "black"),
  colors_na = "grey"
)

# S4 method for class 'numeric'
generate_colors(
  obj,
  avail,
  threshold = 0.5,
  sup_thres_aff = TRUE,
  is_num = TRUE,
  keep_full_scale = FALSE,
  breaks = 3,
  colors_aff = c("yellow2", "red"),
  colors_unaff = c("white", "steelblue4"),
  colors_avail = c("green", "black"),
  colors_na = "grey"
)

# S4 method for class 'Pedigree'
generate_colors(
  obj,
  col_aff = "affection",
  add_to_scale = TRUE,
  col_avail = "avail",
  is_num = NULL,
  mods_aff = TRUE,
  threshold = 0.5,
  sup_thres_aff = TRUE,
  keep_full_scale = FALSE,
  breaks = 3,
  colors_aff = c("yellow2", "red"),
  colors_unaff = c("white", "steelblue4"),
  colors_avail = c("green", "black"),
  colors_na = "grey",
  reset = TRUE
)
```

## Arguments

- obj:

  A Pedigree object or a vector containing the affection status for each
  individuals. The affection status can be numeric or a character.

- avail:

  A logical vector with the availability status of the individuals (i.e.
  `FALSE` = not available, `TRUE` = available, `NA` = unknown).

- mods_aff:

  Vector of modality to consider as affected in the case where the
  `values` is a factor.

- is_num:

  Boolean defining if the values need to be considered as numeric.

- keep_full_scale:

  Boolean defining if the affection values need to be set as a scale. If
  `values` is numeric the filling scale will be calculated based on the
  values and the number of breaks given. If `values` isn't numeric then
  each levels will get it's own color

- colors_aff:

  Set of increasing colors to use for the filling of the affected
  individuls.

- colors_unaff:

  Set of increasing colors to use for the filling of the unaffected
  individuls.

- colors_avail:

  Set of 2 colors to use for the box's border of an individual. The
  first color will be used for available individual (`avail == 1`) and
  the second for the unavailable individual (`avail == 0`).

- colors_na:

  Color to use for individuals with no informations.

- threshold:

  Numeric value separating the affected and healthy subject in the case
  where the `values` is numeric.

- sup_thres_aff:

  Boolean defining if the affected individual are above the threshold or
  not. If `TRUE`, the individuals will be considered affected if the
  value of `values` is stricly above the `threshold`. If `FALSE`, the
  individuals will be considered affected if the value is stricly under
  the `threshold`.

- breaks:

  Number of breaks to use when using full scale with numeric values. The
  same number of breaks will be done for values from affected
  individuals and unaffected individuals.

- col_aff:

  A character vector with the name of the column to be used for the
  affection status.

- add_to_scale:

  Boolean defining if the scales need to be added to the existing scales
  or if they need to replace the existing scales.

- col_avail:

  A character vector with the name of the column to be used for the
  availability status.

- reset:

  If `TRUE` the scale of the specified column will be reset if already
  present.

## Value

### When used with a vector

A list of two elements

- The list containing the filling colors processed and their description

- The list containing the border colors processed and their description

### When used with a Pedigree object

The Pedigree object with the `affected` and `avail` columns processed
accordingly as well as the `scales` slot updated.

## Details

The colors will be set using the generate_fill()\] and the
[`generate_border()`](https://louislenezet.github.io/Pedixplorer/reference/generate_border.md)
functions respectively for the filling and the border.

## Examples

``` r
generate_colors(
    c("A", "B", "A", "B", NA, "A", "B", "A", "B", NA),
    c(1, 0, 1, 0, NA, 1, 0, 1, 0, NA),
    mods_aff = "A"
)
#> $fill
#> $fill$mods
#>  [1]  1  0  1  0 NA  1  0  1  0 NA
#> 
#> $fill$affected
#>  [1]  TRUE FALSE  TRUE FALSE    NA  TRUE FALSE  TRUE FALSE    NA
#> 
#> $fill$sc_fill
#>   mods         labels affected  fill density angle
#> 1    1 Affected are A     TRUE   red      NA    NA
#> 2    0  Healthy are B    FALSE white      NA    NA
#> 5   NA           <NA>       NA  grey      NA    NA
#> 
#> 
#> $bord
#> $bord$mods
#>  [1]  1  0  1  0 NA  1  0  1  0 NA
#> 
#> $bord$avail
#>  [1]  TRUE FALSE  TRUE FALSE    NA  TRUE FALSE  TRUE FALSE    NA
#> 
#> $bord$sc_bord
#>   column mods border        labels
#> 1  avail   NA   grey            NA
#> 2  avail    1  green     Available
#> 3  avail    0  black Non Available
#> 
#> 

generate_colors(
    c(10, 0, 5, 7, NA, 6, 2, 1, 3, NA),
    c(1, 0, 1, 0, NA, 1, 0, 1, 0, NA),
    threshold = 3, keep_full_scale = TRUE
)
#> $fill
#> $fill$mods
#>  [1]  6  1  4  5 NA  4  2  1  3 NA
#> 
#> $fill$affected
#>  [1]  TRUE FALSE  TRUE  TRUE    NA  TRUE FALSE FALSE FALSE    NA
#> 
#> $fill$sc_fill
#>   mods                        labels affected    fill density angle
#> 1    6   Affected > to 3 : (8.33,10]     TRUE #FF0000      NA    NA
#> 2    1  Healthy <= to 3 : [-0.003,1]    FALSE #FFFFFF      NA    NA
#> 3    4    Affected > to 3 : [5,6.67]     TRUE #EEEE00      NA    NA
#> 4    5 Affected > to 3 : (6.67,8.33]     TRUE #F67700      NA    NA
#> 5   NA                       NA : NA       NA    grey      NA    NA
#> 7    2       Healthy <= to 3 : (1,2]    FALSE #9AB1C4      NA    NA
#> 9    3       Healthy <= to 3 : (2,3]    FALSE #36648B      NA    NA
#> 
#> 
#> $bord
#> $bord$mods
#>  [1]  1  0  1  0 NA  1  0  1  0 NA
#> 
#> $bord$avail
#>  [1]  TRUE FALSE  TRUE FALSE    NA  TRUE FALSE  TRUE FALSE    NA
#> 
#> $bord$sc_bord
#>   column mods border        labels
#> 1  avail   NA   grey            NA
#> 2  avail    1  green     Available
#> 3  avail    0  black Non Available
#> 
#> 
data("sampleped")
pedi <- Pedigree(sampleped)
pedi <- generate_colors(pedi, "affection", add_to_scale=FALSE)
scales(pedi)
#> An object of class "Scales"
#> Slot "fill":
#>   order column_values    column_mods mods            labels affected  fill
#> 1     1     affection affection_mods    0 Healthy <= to 0.5    FALSE white
#> 2     1     affection affection_mods    1 Affected > to 0.5     TRUE   red
#> 3     1     affection affection_mods   NA              <NA>       NA  grey
#>   density angle
#> 1      NA    NA
#> 2      NA    NA
#> 3      NA    NA
#> 
#> Slot "border":
#>   column_values column_mods mods        labels border
#> 1         avail  avail_mods   NA            NA   grey
#> 2         avail  avail_mods    1     Available  green
#> 3         avail  avail_mods    0 Non Available  black
#> 
```
