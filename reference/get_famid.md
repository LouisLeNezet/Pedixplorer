# Get family id

Get the family id ftom the individuals identifiers.

## Usage

``` r
get_famid(obj)

# S4 method for class 'character'
get_famid(obj)
```

## Arguments

- obj:

  A character vector of individual ids

## Value

A character vector of family ids

## Details

The family id is the first part of the individual id, separated by an
underscore. If the individual id does not contain an underscore, then
the family id is set to NA.

## Examples

``` r
get_famid(c("A", "1_B", "C_2", "D_", "_E", "F"))
#> [1] NA  "1" "C" "D" NA  NA 
```
