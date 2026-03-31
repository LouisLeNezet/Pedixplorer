# Check column configuration

This function checks the validity of the column configuration provided
to the `data_col_sel_server` function.

## Usage

``` r
check_col_config(col_config)
```

## Arguments

- col_config:

  A list of column definitions. It must contain a list for each column,
  with the following keys: 'alternate' and 'mandatory'.

## Value

TRUE if the configuration is valid.

## Details

The list names must correspond to the column names of the dataframe to
be selected. Each list must contain two keys: 'alternate' and
'mandatory'. The 'alternate' key must contain a character vector of
column names that can be selected as an alternative to the main column.
The 'mandatory' key must contain a logical value (TRUE/FALSE) to
indicate whether the column is required to be selected.

## Examples

``` r
Pedixplorer:::check_col_config(list(
   ColA = list(alternate = c("A"), mandatory = TRUE),
  ColB = list(alternate = c("B"), mandatory = FALSE)
))
#> [1] TRUE
```
