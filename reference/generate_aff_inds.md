# Process the affection informations

Perform transformation uppon a vector given as the one containing the
affection status to obtain an `affected` binary state.

## Usage

``` r
generate_aff_inds(
  values,
  mods_aff = NULL,
  threshold = NULL,
  sup_thres_aff = NULL,
  is_num = NULL
)
```

## Arguments

- values:

  Vector containing the values of the column to process.

- mods_aff:

  Vector of modality to consider as affected in the case where the
  `values` is a factor.

- threshold:

  Numeric value separating the affected and healthy subject in the case
  where the `values` is numeric.

- sup_thres_aff:

  Boolean defining if the affected individual are above the threshold or
  not. If `TRUE`, the individuals will be considered affected if the
  value of `values` is stricly above the `threshold`. If `FALSE`, the
  individuals will be considered affected if the value is stricly under
  the `threshold`.

- is_num:

  Boolean defining if the values need to be considered as numeric.

## Value

A dataframe with the `affected` column processed accordingly. The
different columns are:

- `mods`: The different modalities of the column

- `labels`: The labels of the different modalities

- `affected`: The column processed to have only TRUE/FALSE values

## Details

This function helps to configure a binary state from a character or
numeric variable.

### If the variable is a `character` or a `factor`:

In this case the affected state will depend on the modality provided as
an affected status. All individuals with a value corresponding to one of
the element in the vector **mods_aff** will be considered as affected.

### If the variable is `numeric`:

In this case the affected state will be `TRUE` if the value of the
individual is above the **threshold** if **sup_thres_aff** is `TRUE` and
`FALSE` otherwise.

## Examples

``` r
generate_aff_inds(c(1, 2, 3, 4, 5), threshold = 3, sup_thres_aff = TRUE)
#>   mods          labels affected
#> 1    0 Healthy <= to 3    FALSE
#> 2    0 Healthy <= to 3    FALSE
#> 3    0 Healthy <= to 3    FALSE
#> 4    1 Affected > to 3     TRUE
#> 5    1 Affected > to 3     TRUE
generate_aff_inds(c("A", "B", "C", "A", "V", "B"), mods_aff = c("A", "B"))
#>   mods             labels affected
#> 1    1 Affected are A / B     TRUE
#> 2    1 Affected are A / B     TRUE
#> 3    0  Healthy are C / V    FALSE
#> 4    1 Affected are A / B     TRUE
#> 5    0  Healthy are C / V    FALSE
#> 6    1 Affected are A / B     TRUE
```
