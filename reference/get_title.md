# Get the title of the family information table

This function generates the title of the family information table
depending on the selected family and subfamily and other parameters.

## Usage

``` r
get_title(
  family_sel,
  subfamily_sel,
  family_var,
  mod,
  inf_selected,
  kin_max,
  keep_parents,
  nb_rows,
  short_title = FALSE
)
```

## Arguments

- family_sel:

  the selected family

- subfamily_sel:

  the selected subfamily

- family_var:

  the selected family variable

- mod:

  the selected affected modality

- inf_selected:

  the selected informative individuals

- kin_max:

  the maximum kinship

- keep_parents:

  the keep parents option

- nb_rows:

  the number of individuals

- short_title:

  a boolean to generate a short title

## Value

a string with the title

## Examples

``` r
get_title(1, 1, "health", "A", "All", 3, TRUE, 10, FALSE)
#> [1] "Pedigree trimmed of family N*1 sub-family N*1 (N=10) from All individuals."
get_title(1, 1, "health", "A", "All", 3, TRUE, 10, TRUE)
#> [1] "Ped_F1_K3_T_IAll_SF1"
get_title(1, 1, "health", "A", "All", 3, FALSE, 10, FALSE)
#> [1] "Pedigree of family N*1 sub-family N*1 (N=10) from All individuals."
```
