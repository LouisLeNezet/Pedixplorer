# Process the border colors based on availability

Perform transformation uppon a vector given as the one containing the
availability status to compute the border color. The vector given will
be transformed using the
[`vect_to_binary()`](https://louislenezet.github.io/Pedixplorer/reference/vect_to_binary.md)
function.

## Usage

``` r
generate_border(values, colors_avail = c("green", "black"), colors_na = "grey")
```

## Arguments

- values:

  The vector containing the values to process as available.

- colors_avail:

  Set of 2 colors to use for the box's border of an individual. The
  first color will be used for available individual (`avail == 1`) and
  the second for the unavailable individual (`avail == 0`).

- colors_na:

  Color to use for individuals with no informations.

## Value

A list of three elements

- `mods` : The processed values column as a numeric factor

- `avail` : A logical vector indicating if the individual is available

- `sc_bord` : A dataframe containing the description of each modality of
  the scale

## Examples

``` r
generate_border(c(1, 0, 1, 0, NA, 1, 0, 1, 0, NA))
#> $mods
#>  [1]  1  0  1  0 NA  1  0  1  0 NA
#> 
#> $avail
#>  [1]  TRUE FALSE  TRUE FALSE    NA  TRUE FALSE  TRUE FALSE    NA
#> 
#> $sc_bord
#>   column mods border        labels
#> 1  avail   NA   grey            NA
#> 2  avail    1  green     Available
#> 3  avail    0  black Non Available
#> 
```
