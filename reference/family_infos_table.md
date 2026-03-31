# Affection and availability information table

This function creates a table with the affection and availability
information for all individuals in a pedigree object.

## Usage

``` r
family_infos_table(pedi, col_val = NA)
```

## Arguments

- pedi:

  A pedigree object.

- col_val:

  The column name in the `fill` slot of the pedigree object to use for
  the table.

## Value

A cross table dataframe with the affection and availability information.

## Examples

``` r
data(sampleped)
pedi <- Pedigree(sampleped)
pedi <- generate_colors(pedi, "num_child_tot", threshold = 2)
#> Warning: 1_1141_117 individual(s) are/is proband but not affected
#> Warning: 1_109 individual(s) are/is asymptomatic but affected
#> Warning: 1_1141_117 individual(s) are/is proband but not affected
#> Warning: 1_109 individual(s) are/is asymptomatic but affected
Pedixplorer:::family_infos_table(pedi, "num_child_tot")
#>   Affected            mods TRUE FALSE NA
#> 1        0 Healthy <= to 2   20    21  0
#> 2        1 Affected > to 2    4    10  0
#> 3       NA              NA    0     0  0
Pedixplorer:::family_infos_table(pedi, "affection")
#>   Affected              mods TRUE FALSE NA
#> 1        0 Healthy <= to 0.5   11    12  0
#> 2        1 Affected > to 0.5   12    10  0
#> 3       NA                NA    1     9  0
```
