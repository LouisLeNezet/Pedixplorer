# NA to specific length

Check if all value in a vector is `NA` or `NULL`. If so set all of them
to a new value matching the length of the template. If not check that
the size of the vector is equal to the template.

## Usage

``` r
na_to_length(x, temp, value)
```

## Arguments

- x:

  The vector to check.

- temp:

  A template vector to use to determine the length.

- value:

  The value to use to fill the vector.

## Value

A vector with the same length as temp.

## Examples

``` r
Pedixplorer:::na_to_length(NA, rep(0, 4), "NewValue")
#> [1] "NewValue" "NewValue" "NewValue" "NewValue"
Pedixplorer:::na_to_length(c(1, 2, 3, NA), rep(0, 4), "NewValue")
#> [1]  1  2  3 NA
```
