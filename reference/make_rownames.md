# Make rownames for rectangular data display

Make rownames for rectangular data display

## Usage

``` r
make_rownames(x_rownames, nrow, nhead, ntail)
```

## Arguments

- x_rownames:

  The rownames of the data

- nrow:

  The number of rows in the data

- nhead:

  The number of rownames to display at the beginning

- ntail:

  The number of rownames to display at the end

## Value

A character vector of rownames

## Examples

``` r
Pedixplorer:::make_rownames(rownames(mtcars), nrow(mtcars), 3, 3)
#> [1] "Mazda RX4"     "Mazda RX4 Wag" "Datsun 710"    "..."          
#> [5] "Ferrari Dino"  "Maserati Bora" "Volvo 142E"   
```
