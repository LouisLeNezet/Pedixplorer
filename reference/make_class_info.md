# Make class information

Make class information

## Usage

``` r
make_class_info(x)
```

## Arguments

- x:

  A list of class

## Value

A character vector of class information

## Examples

``` r
Pedixplorer:::make_class_info(list(
    1, "a", 1, 2, 3, list(1, 2)
))
#> [1] "<numeric>"   "<character>" "<numeric>"   "<numeric>"   "<numeric>"  
#> [6] "<list>"     
```
