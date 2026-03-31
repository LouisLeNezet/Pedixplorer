# Subset a region of a Pedigree

Subset a region of a Pedigree

## Usage

``` r
subregion(df, subreg = NULL)
```

## Arguments

- df:

  A data frame with all the plot coordinates

- subreg:

  A 4-element vector for (min x, max x, min depth, max depth), used to
  edit away portions of the plot coordinates returned by
  [`ped_to_plotdf()`](https://louislenezet.github.io/Pedixplorer/reference/ped_to_plotdf.md).
  This is useful for zooming in on a particular region of the Pedigree.

## Value

A subset of the plot coordinates
