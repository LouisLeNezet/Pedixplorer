# Process the filling colors based on affection

Perform transformation uppon a column given as the one containing
affection status to compute the filling color.

## Usage

``` r
generate_fill(
  values,
  affected,
  labels,
  is_num = NULL,
  keep_full_scale = FALSE,
  breaks = 3,
  colors_aff = c("yellow2", "red"),
  colors_unaff = c("white", "steelblue4"),
  colors_na = "grey"
)
```

## Arguments

- values:

  The vector containing the values to process as affection.

- affected:

  A logical vector with the affection status of the individuals (i.e.
  `FALSE` = unaffected, `TRUE` = affected, `NA` = unknown).

- labels:

  The vector containing the labels to use for the affection.

- is_num:

  Boolean defining if the values need to be considered as numeric.

- keep_full_scale:

  Boolean defining if the affection values need to be set as a scale. If
  `values` is numeric the filling scale will be calculated based on the
  values and the number of breaks given. If `values` isn't numeric then
  each levels will get it's own color

- breaks:

  Number of breaks to use when using full scale with numeric values. The
  same number of breaks will be done for values from affected
  individuals and unaffected individuals.

- colors_aff:

  Set of increasing colors to use for the filling of the affected
  individuls.

- colors_unaff:

  Set of increasing colors to use for the filling of the unaffected
  individuls.

- colors_na:

  Color to use for individuals with no informations.

## Value

A list of three elements

- `mods` : The processed values column as a numeric factor

- `affected` : A logical vector indicating if the individual is affected

- `sc_fill` : A dataframe containing the description of each modality of
  the scale

## Details

The colors will be set using the
[`grDevices::colorRampPalette()`](https://rdrr.io/r/grDevices/colorRamp.html)
function with the colors given as parameters.

The colors will be set as follow:

- If **keep_full_scale** is `FALSE`: Then the affected individuals will
  get the first color of the **colors_aff** vector and the unaffected
  individuals will get the first color of the **colors_unaff** vector.

- If **keep_full_scale** is `TRUE`:

  - If **values** isn't numeric: Each levels of the affected **values**
    vector will get it's own color from the **colors_aff** vector using
    the
    [`grDevices::colorRampPalette()`](https://rdrr.io/r/grDevices/colorRamp.html)
    and the same will be done for the unaffected individuals using the
    **colors_unaff**.

  - If **values** is numeric: The mean of the affected individuals will
    be compared to the mean of the unaffected individuals and the colors
    will be set up such as the color gradient follow the direction of
    the affection.

## Examples

``` r
aff <- generate_aff_inds(seq_len(5), threshold = 3, sup_thres_aff = TRUE)
generate_fill(seq_len(5), aff$affected, aff$labels)
#> $mods
#> [1] 0 0 0 1 1
#> 
#> $affected
#> [1] FALSE FALSE FALSE  TRUE  TRUE
#> 
#> $sc_fill
#>   mods          labels affected  fill density angle
#> 1    0 Healthy <= to 3    FALSE white      NA    NA
#> 4    1 Affected > to 3     TRUE   red      NA    NA
#> 
generate_fill(seq_len(5), aff$affected, aff$labels, keep_full_scale = TRUE)
#> $mods
#> [1] 1 2 3 4 6
#> 
#> $affected
#> [1] FALSE FALSE FALSE  TRUE  TRUE
#> 
#> $sc_fill
#>   mods                         labels affected    fill density angle
#> 1    1 Healthy <= to 3 : [0.998,1.67]    FALSE #FFFFFF      NA    NA
#> 2    2  Healthy <= to 3 : (1.67,2.33]    FALSE #9AB1C4      NA    NA
#> 3    3     Healthy <= to 3 : (2.33,3]    FALSE #36648B      NA    NA
#> 4    4     Affected > to 3 : [4,4.33]     TRUE #EEEE00      NA    NA
#> 5    6     Affected > to 3 : (4.67,5]     TRUE #FF0000      NA    NA
#> 
```
