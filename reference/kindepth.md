# Individual's depth in a pedigree

Computes the depth of each subject in the Pedigree.

## Usage

``` r
# S4 method for class 'character_OR_integer'
kindepth(obj, dadid, momid, align_parents = FALSE, force = FALSE)

# S4 method for class 'Pedigree'
kindepth(obj, align_parents = FALSE, force = FALSE)

# S4 method for class 'Ped'
kindepth(obj, align_parents = FALSE, force = FALSE)
```

## Arguments

- obj:

  A character vector with the id of the individuals or a `data.frame`
  with all the informations in corresponding columns.

- dadid:

  A vector containing for each subject, the identifiers of the
  biologicals fathers.

- momid:

  A vector containing for each subject, the identifiers of the
  biologicals mothers.

- align_parents:

  If `align_parents = TRUE`, go one step further and try to make both
  parents of each child have the same depth. (This is not always
  possible). It helps the drawing program by lining up pedigrees that
  'join in the middle' via a marriage.

- force:

  If `force = TRUE`, the function will return the depth minus
  `min(depth)` if `depth` reach a state with no founders is not
  possible.

## Value

An integer vector containing the depth for each subject

## Details

Mark each person as to their depth in a Pedigree; `0` for a founder,
otherwise :

\$\$depth = 1 + \max(fatherDepth, motherDepth)\$\$

In the case of an inbred Pedigree a perfect alignment may not exist.

## See also

[`align()`](https://louislenezet.github.io/Pedixplorer/reference/align.md)

## Author

Terry Therneau, updated by Louis Le Nezet

## Examples

``` r
kindepth(
    c("A", "B", "C", "D", "E"),
    c("C", "D", "0", "0", "0"),
    c("E", "E", "0", "0", "0")
)
#> [1] 1 1 0 0 0
data(sampleped)
ped1 <- Pedigree(sampleped[sampleped$famid == "1",])
kindepth(ped1)
#>  [1] 0 0 1 0 0 0 0 0 1 2 2 2 0 2 1 1 0 1 1 1 3 3 3 3 3 3 3 3 2 2 2 2 2 2 0 0 0 1
#> [39] 2 2 2
```
