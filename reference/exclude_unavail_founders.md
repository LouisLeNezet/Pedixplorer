# Exclude unavailable founders

Exclude any unavailable founders.

## Usage

``` r
exclude_unavail_founders(id, dadid, momid, avail, missid = NA_character_)
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

- avail:

  A logical vector with the availability status of the individuals (i.e.
  `FALSE` = not available, `TRUE` = available, `NA` = unknown).

- missid:

  A character vector with the missing values identifiers. All the id,
  dadid and momid corresponding to those values will be set to
  `NA_character_`.

## Value

Returns a list with the following components:

- n_trimmed Number of trimmed individuals

- id_trimmed Vector of IDs of trimmed individuals

- id Vector of subject identifiers

- dadid Vector of father identifiers

- momid Vector of mother identifiers

## See also

[`shrink()`](https://louislenezet.github.io/Pedixplorer/reference/shrink.md)
