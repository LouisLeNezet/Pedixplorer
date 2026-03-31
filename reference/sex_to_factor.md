# Gender variable to ordered factor

Gender variable to ordered factor

## Usage

``` r
sex_to_factor(sex)
```

## Arguments

- sex:

  A character, factor or numeric vector corresponding to the gender of
  the individuals. This will be transformed to an ordered factor with
  the following levels: `male` \< `female` \< `unknown`

  The following values are recognized:

  - "male": "m", "male", "man", `1`

  - "female": "f", "female", "woman", `2`

  - "unknown": "unknown", `3`

## Value

an ordered factor vector containing the transformed variable "male" \<
"female" \< "unknown"

## Examples

``` r
sex_to_factor(c(1, 2, 3, "f", "m", "man", "female"))
#> [1] male    female  unknown female  male    male    female 
#> Levels: male < female < unknown
```
