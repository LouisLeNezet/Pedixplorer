# Vector variable to binary vector

Transform a vector to a binary vector. All values that are not `0`, `1`,
`TRUE`, `FALSE`, or `NA` are transformed to `NA`.

## Usage

``` r
vect_to_binary(vect, logical = FALSE, default = NA)
```

## Arguments

- vect:

  A character, factor, logical or numeric vector corresponding to a
  binary variable (i.e. `0` or `1`). The following values are
  recognized:

  - character() or factor() : "TRUE", "FALSE", "0", "1", "NA" will be
    respectively transformed to `1`, `0`, `0`, `1`, `NA`. Spaces and
    case are ignored. All other values will be transformed to NA.

  - numeric() : `0` and `1` are kept, all other values are transformed
    to NA.

  - logical() : `TRUE` and `FALSE` are tansformed to `1` and`0`.

- logical:

  Boolean defining if the output should be a logical vector instead of a
  numeric vector (i.e. `0` and `1` becomes `FALSE` and \`TRUE).

- default:

  The default value to use for the values that are not recognized. By
  default, `NA` is used, but it can be `0` or `1`.

## Value

numeric binary vector of the same size as **vect** with `0` and `1`

## Examples

``` r
vect_to_binary(
    c(0, 1, 2, 3.6, "TRUE", "FALSE", "0", "1", "NA", "B", TRUE, FALSE, NA)
)
#> Warning: NAs introduced by coercion
#>  [1]  0  1 NA NA  1  0  0  1 NA NA  1  0 NA
```
