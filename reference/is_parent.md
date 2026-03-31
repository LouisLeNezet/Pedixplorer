# Are individuals parents

Check which individuals are parents.

## Usage

``` r
# S4 method for class 'character_OR_integer'
is_parent(obj, dadid, momid, missid = NA_character_)

# S4 method for class 'Ped'
is_parent(obj, missid = NA_character_)
```

## Arguments

- obj:

  A vector of each subjects identifiers or a Ped object

- dadid:

  A vector containing for each subject, the identifiers of the
  biologicals fathers.

- momid:

  A vector containing for each subject, the identifiers of the
  biologicals mothers.

- missid:

  A character vector with the missing values identifiers. All the id,
  dadid and momid corresponding to those values will be set to
  `NA_character_`.

## Value

A vector of boolean of the same size as **obj** with TRUE if the
individual is a parent and FALSE otherwise

## Examples

``` r
is_parent(c("1", "2", "3", "4"), c("3", "3", NA, NA), c("4", "4", NA, NA))
#> [1] FALSE FALSE  TRUE  TRUE

data(sampleped)
pedi <- Pedigree(sampleped)
is_parent(ped(pedi))
#>  [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE
#> [13] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE
#> [25] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE
#> [37]  TRUE  TRUE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE
#> [49]  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE
```
