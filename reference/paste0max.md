# Print0 to max

Print0 the elements inside a vector until a maximum is reached.

## Usage

``` r
paste0max(x, max = 5, sep = "", ...)
```

## Arguments

- x:

  A vector.

- max:

  The maximum number of elements to print.

- ...:

  Additional arguments passed to print0

## Value

The character vector aggregated until the maximum is reached.

## Examples

``` r
x <- seq_len(10)
Pedixplorer:::paste0max(x, 5)
#> [1] "'1', '2', '3', '4', '5'..."
```
