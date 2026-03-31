# Summarise the families information for a given variable in a data frame

This function summarises the families information for a given variable
in a data frame. It returns the most numerous modality for each family
and the number of individuals in the family.

## Usage

``` r
get_families_table(df, var)
```

## Arguments

- df:

  a data frame

- var:

  the variable to summarise

## Value

a data frame with the family information

## Examples

``` r
df <- data.frame(
    famid = c(1, 1, 2, 2, 3, 3),
    health = c("A", "B", "A", "A", "B", "B")
)
get_families_table(df, "health")
#> # A tibble: 3 × 3
#>   famid `Major mod` `Nb Ind`
#>   <dbl> <chr>          <int>
#> 1     1 A                  2
#> 2     2 A                  2
#> 3     3 B                  2
```
