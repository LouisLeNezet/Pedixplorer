# Check if a Hints object is valid

Check if horder and spouse slots are valid:

- horder is named numeric vector

- spouse is a data.frame

  - Has the three `idr`, `idl`, `anchor` columns

  - `idr` and `idl` are different and doesn't contains `NA`

  - `idr` and `idl` couple are unique

  - `anchor` column only have `right`, `left` or `either` values

- all ids in spouse needs to be in the names of the horder vector

## Usage

``` r
is_valid_hints(object)
```

## Arguments

- object:

  A Hints object.

## Value

A character vector with the errors or `TRUE` if no errors.
