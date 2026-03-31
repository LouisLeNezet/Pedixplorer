# Distribute elements by group

This function distributes elements by group for a given number of
elements. The distribution can be done by row or by column.

## Usage

``` r
distribute_by(nb_group, nb_elem, by_row = FALSE)
```

## Arguments

- nb_group:

  The number of group.

- nb_elem:

  The number of elements to distribute.

- by_row:

  A boolean to distribute by row or by column.

## Value

A vector of group indices.

## Examples

``` r
Pedixplorer:::distribute_by(3, 10)
#>  [1] 1 1 1 1 2 2 2 3 3 3
Pedixplorer:::distribute_by(3, 10, by_row = TRUE)
#>  [1] 1 2 3 1 2 3 1 2 3 1
```
