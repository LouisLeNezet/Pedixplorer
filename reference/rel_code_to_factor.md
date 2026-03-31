# Relationship code variable to ordered factor

Relationship code variable to ordered factor

## Usage

``` r
rel_code_to_factor(code)
```

## Arguments

- code:

  A character, factor or numeric vector corresponding to the relation
  code of the individuals:

  - MZ twin = Monozygotic twin

  - DZ twin = Dizygotic twin

  - UZ twin = twin of unknown zygosity

  - Spouse = Spouse The following values are recognized:

  - character() or factor() : "MZ twin", "DZ twin", "UZ twin", "Spouse"
    with of without space between the words. The case is not important.

  - numeric() : 1 = "MZ twin", 2 = "DZ twin", 3 = "UZ twin", 4 =
    "Spouse"

## Value

an ordered factor vector containing the transformed variable "MZ twin"
\< "DZ twin" \< "UZ twin" \< "Spouse"

## Examples

``` r
rel_code_to_factor(c(1, 2, 3, 4, "MZ twin", "DZ twin", "UZ twin", "Spouse"))
#> [1] MZ twin DZ twin UZ twin Spouse  MZ twin DZ twin UZ twin Spouse 
#> Levels: MZ twin < DZ twin < UZ twin < Spouse
```
