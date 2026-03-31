# Are individuals disconnected

Check which individuals are disconnected.

## Usage

``` r
is_disconnected(id, dadid, momid)
```

## Arguments

- dadid:

  A vector containing for each subject, the identifiers of the
  biologicals fathers.

- momid:

  A vector containing for each subject, the identifiers of the
  biologicals mothers.

## Value

A vector of boolean of the same size as **id** with `TRUE` if the
individual is disconnected and `FALSE` otherwise

## Details

An individuals is considered disconnected if the kinship with all the
other individuals is `0`.

## Examples

``` r
is_disconnected(
    c("1", "2", "3", "4", "5"),
    c("3", "3", NA, NA, NA),
    c("4", "4", NA, NA, NA)
)
#>     1     2     3     4     5 
#> FALSE FALSE FALSE FALSE  TRUE 
```
