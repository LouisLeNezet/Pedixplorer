# Anchor variable to ordered factor

Anchor variable to ordered factor

## Usage

``` r
anchor_to_factor(anchor)
```

## Arguments

- anchor:

  A character, factor or numeric vector corresponding to the anchor of
  the individuals. The following values are recognized:

  - character() or factor() : "0", "1", "2", "left", "right", "either"

  - numeric() : 1 = "left", 2 = "right", 0 = "either"

## Value

An ordered factor vector containing the transformed variable "either" \<
"left" \< "right"

## Examples

``` r
Pedixplorer:::anchor_to_factor(c(1, 2, 0, "left", "right", "either"))
#> [1] left   right  either left   right  either
#> Levels: left < right < either
```
