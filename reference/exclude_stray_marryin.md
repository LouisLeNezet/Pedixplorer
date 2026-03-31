# Exclude stray marry-ins

Exclude any founders who are not parents.

## Usage

``` r
exclude_stray_marryin(id, dadid, momid)
```

## Arguments

- id:

  A character vector with the identifiers of each individuals

- dadid:

  A vector containing for each subject, the identifiers of the
  biologicals fathers.

- momid:

  A vector containing for each subject, the identifiers of the
  biologicals mothers.

## Value

Returns a data frame of subject identifiers and their parents. The data
frame is trimmed of any founders who are not parents.

## See also

[`shrink()`](https://louislenezet.github.io/Pedixplorer/reference/shrink.md)
