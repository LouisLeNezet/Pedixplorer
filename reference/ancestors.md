# Ancestors indexes of a subject

Given the index of one or multiple individual(s), this function iterate
through the mom and dad indexes to list out all the ancestors of the
said individual(s). This function is use in the
[`align()`](https://louislenezet.github.io/Pedixplorer/reference/align.md)
function to identify which spouse pairs has a common ancestor and
therefore if they need to be connected with a double line (i.e. inbred).

## Usage

``` r
ancestors(idx, momx, dadx)
```

## Arguments

- idx:

  Indexes of the subjects

- momx:

  Indexes of the mothers

- dadx:

  Indexes of the fathers

## Value

A vector of ancestor indexes

## See also

[`align()`](https://louislenezet.github.io/Pedixplorer/reference/align.md)

## Examples

``` r
ancestors(c(1), c(3, 4, 5, 6), c(7, 8, 9, 10))
#> [1] 3 5 7 9
ancestors(c(1, 2), c(3, 4, 5, 6), c(7, 8, 9, 10))
#> [1]  3  4  5  6  7  8  9 10
```
