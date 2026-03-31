# Are individuals founders

Check which individuals are founders.

## Usage

``` r
is_founder(momid, dadid, missid = NA_character_)
```

## Arguments

- momid:

  A vector containing for each subject, the identifiers of the
  biologicals mothers.

- dadid:

  A vector containing for each subject, the identifiers of the
  biologicals fathers.

- missid:

  A character vector with the missing values identifiers. All the id,
  dadid and momid corresponding to those values will be set to
  `NA_character_`.

## Value

A vector of boolean of the same size as **dadid** and **momid** with
`TRUE` if the individual has no parents (i.e is a founder) and `FALSE`
otherwise.

## Examples

``` r
is_founder(c("3", "3", NA, NA), c("4", "4", NA, NA))
#> [1] FALSE FALSE  TRUE  TRUE
```
