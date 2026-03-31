# Polygonal element

Create a list of x and y coordinates for a polygon with a given number
of slices and a list of coordinates for the polygon.

## Usage

``` r
polyfun(nslice, coor, start = 90)
```

## Arguments

- nslice:

  Number of slices in the polygon

- coor:

  Element form which to generate the polygon containing x and y
  coordinates

- start:

  Starting angle in degree

## Value

a list of x and y coordinates

## Examples

``` r
Pedixplorer:::polyfun(2, list(
    x = c(-0.5, -0.5, 0.5, 0.5),
    y = c(-0.5, 0.5, 0.5, -0.5)
), start = 45)
#> [[1]]
#> [[1]]$x
#> [1]  0.0  0.5 -0.5 -0.5 -0.5
#> 
#> [[1]]$y
#> [1]  0.0  0.5  0.5 -0.5 -0.5
#> 
#> 
#> [[2]]
#> [[2]]$x
#> [1]  0.0 -0.5  0.5  0.5  0.5
#> 
#> [[2]]$y
#> [1]  0.0 -0.5 -0.5  0.5  0.5
#> 
#> 
```
