# Create a text column

Aggregate multiple columns into a single text column separated by a
newline character.

## Usage

``` r
create_text_column(df, title = NULL, cols = NULL, na_strings = c("", "NA"))
```

## Arguments

- df:

  A dataframe

- title:

  The title of the text column

- cols:

  A vector of columns to concatenate

- na_strings:

  A vector of strings that should be considered as NA

## Value

The concatenated text column

## Examples

``` r
df <- data.frame(a = seq_len(3), b = c("4", "NA", 6), c = c("", "A", 2))
Pedixplorer:::create_text_column(df, "a", c("b", "c"))
#> [1] "<span style='font-size:14px'><b>1</b></span><br><b>b</b>: 4"               
#> [2] "<span style='font-size:14px'><b>2</b></span><br><b>c</b>: A"               
#> [3] "<span style='font-size:14px'><b>3</b></span><br><b>b</b>: 6<br><b>c</b>: 2"
```
