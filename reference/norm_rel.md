# Normalise a Rel object dataframe

Normalise a dataframe and check for columns correspondance to be able to
use it as an input to create a Ped object.

## Usage

``` r
norm_rel(
  rel_df,
  multi_code = "error",
  na_strings = c("NA", ""),
  missid = c(NA_character_, "0")
)
```

## Arguments

- rel_df:

  A data.frame with the special relationships between individuals. See
  [`Rel()`](https://louislenezet.github.io/Pedixplorer/reference/Rel-class.md)
  for more informations. The minimum columns required are `id1`, `id2`
  and `code`. The `famid` column can also be used to specify the family
  of the individuals. If a matrix is given, the columns needs to be
  ordered as `id1`, `id2`, `code` and `famid`. The code values are:

  - `1` = Monozygotic twin

  - `2` = Dizygotic twin

  - `3` = twin of unknown zygosity

  - `4` = Spouse

  The value relation code recognized by the function are the one defined
  by the
  [`rel_code_to_factor()`](https://louislenezet.github.io/Pedixplorer/reference/rel_code_to_factor.md)
  function.

- multi_code:

  How to handle multiple relationship codes in the same group If
  "error", an error is thrown. If "warn", a warning is thrown and the
  relationship code is set to twins of unknow zigosity. Default is
  "error".

- na_strings:

  Vector of strings to be considered as NA values.

- missid:

  A character vector with the missing values identifiers. All the id,
  dadid and momid corresponding to those values will be set to
  `NA_character_`.

## Value

A dataframe with the errors identified

## Details

The `famid` column, if provided, will be merged to the *ids* field
separated by an underscore using the
[`upd_famid()`](https://louislenezet.github.io/Pedixplorer/reference/upd_famid.md)
function. The `code` column will be transformed with the
[`rel_code_to_factor()`](https://louislenezet.github.io/Pedixplorer/reference/rel_code_to_factor.md).
Missing relationship for set of twins will be completed using
[`complete_twins()`](https://louislenezet.github.io/Pedixplorer/reference/complete_twins.md).
Multiple test are done and errors are checked.

A number of checks are done to ensure the dataframe is correct:

### On identifiers:

- All ids (id1, id2) are not empty (`!= ""`)

- `id1` and `id2` are not the same

### On code

- All code are recognised as either "MZ twin", "DZ twin", "UZ twin" or
  "Spouse"

## Examples

``` r
df <- data.frame(
    id1 = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
    id2 = c(2, 3, 4, 5, 6, 7, 8, 9, 10, 1),
    code = c("MZ twin", "DZ twin", "UZ twin", "Spouse",
        1, 2, 3, 4, "MzTwin", "sp oUse"),
    famid = c(1, 1, 1, 1, 1, 1, 1, 2, 2, 2)
)
norm_rel(df)
#>     id1  id2    code famid error
#> 1   1_1  1_2 MZ twin     1  <NA>
#> 2   1_2  1_3 DZ twin     1  <NA>
#> 3   1_3  1_4 UZ twin     1  <NA>
#> 4   1_4  1_5  Spouse     1  <NA>
#> 5   1_5  1_6 MZ twin     1  <NA>
#> 6   1_6  1_7 DZ twin     1  <NA>
#> 7   1_7  1_8 UZ twin     1  <NA>
#> 8   2_8  2_9  Spouse     2  <NA>
#> 9   2_9 2_10 MZ twin     2  <NA>
#> 10 2_10  2_1  Spouse     2  <NA>
```
