# Make a reactive object

This function checks if the input is a reactive object. If it is, it
returns it as is. If not, it converts the input into a reactive object.

## Usage

``` r
make_reactive(x)
```

## Arguments

- x:

  The input to check and convert.

## Value

A reactive object.

## Examples

``` r
Pedixplorer:::make_reactive(1)
#> reactive({
#>     x
#> }) 
```
