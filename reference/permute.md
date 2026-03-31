# Generate all possible permutation

Given a vector of length **n**, generate all possible permutations of
the numbers 1 to **n**. This is a recursive routine, and is not very
efficient.

## Usage

``` r
permute(x)
```

## Arguments

- x:

  A vector of length **n**

## Value

A matrix with **n** cols and **n!** rows

## Examples

``` r
Pedixplorer:::permute(seq_len(3))
#>      [,1] [,2] [,3]
#> [1,]    1    2    3
#> [2,]    2    1    3
#> [3,]    3    1    2
```
