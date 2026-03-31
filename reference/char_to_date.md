# Convert a character to a date

Convert a character to a date

## Usage

``` r
char_to_date(date, date_pattern = "%Y-%m-%d")
```

## Arguments

- date:

  A character vector of dates

- date_pattern:

  The pattern of the date

## Value

A date vector

## Examples

``` r
Pedixplorer:::char_to_date("2020-01-01", "%Y-%m-%d")
#> [1] "2020-01-01"
Pedixplorer:::char_to_date("01/01/20", "%d/%m/%y")
#> [1] "2020-01-01"
```
