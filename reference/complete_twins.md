# Complete missing twins relationship

Given a dataframe of relationships, complete the missing twins
relationship.

## Usage

``` r
complete_twins(rel_df, multi_code = "error")
```

## Arguments

- rel_df:

  A dataframe of relationships

- multi_code:

  How to handle multiple relationship codes in the same group If
  "error", an error is thrown. If "warn", a warning is thrown and the
  relationship code is set to twins of unknow zigosity. Default is
  "error".

## Value

The completed dataframe of relationships

## Examples

``` r
data(relped)
Pedixplorer:::complete_twins(relped)
#>   famid   id1   id2 group    code
#> 1     1 1_139 1_140     1 MZ twin
#> 2     1 1_139 1_141     1 MZ twin
#> 3     1 1_140 1_141     1 MZ twin
#> 4     1 1_121 1_123     2 DZ twin
#> 5     1 1_130 1_133     3 UZ twin
#> 6     1   129   126    NA  Spouse
#> 7     2 2_210 2_211     4 MZ twin
#> 8     2 2_204 2_208     5 DZ twin
#> 9     2 2_212 2_213     6 UZ twin
```
