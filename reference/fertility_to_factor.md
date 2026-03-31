# Fertility variable to factor

Transform a fertility variable to a factor variable By default, all
other values are transformed to `NA` and considered as fertile.

## Usage

``` r
fertility_to_factor(fertility)
```

## Arguments

- fertility:

  A character, factor or numeric vector corresponding to the fertility
  status of the individuals. This will be transformed to a factor with
  the following levels: `infertile_choice_na`, `infertile`, `fertile`

  The following values are recognized:

  - "inferile_choice_na" : "infertile_choice", "infertile_na"

  - "infertile" : "infertile", "steril", `FALSE`, `0`

  - "fertile" : "fertile", `TRUE`, `1`, `NA`

## Value

a factor vector containing the transformed variable
"infertile_choice_na", "infertile", "fertile"

## Examples

``` r
fertility_to_factor(c(
   1, "fertile", TRUE, NA,
  "infertile", "steril", FALSE, 0,
  "infertile_na", "infertile_choice_na", "infertile_choice"
))
#>  [1] fertile             fertile             fertile            
#>  [4] fertile             infertile           infertile          
#>  [7] infertile           infertile           infertile_choice_na
#> [10] infertile_choice_na infertile_choice_na
#> Levels: infertile_choice_na infertile fertile
```
