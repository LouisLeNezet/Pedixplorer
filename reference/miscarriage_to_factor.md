# Miscarriage variable to factor

Transform a miscarriage variable to a factor variable By default, all
other values are transformed to `NA` and considered as `FALSE`. Space
and case are ignored.

## Usage

``` r
miscarriage_to_factor(miscarriage)
```

## Arguments

- miscarriage:

  A character, factor or numeric vector corresponding to the miscarriage
  status of the individuals. This will be transformed to a factor with
  the following levels: `TOP`, `SAB`, `ECT`, `FALSE` The following
  values are recognized:

  - "SAB" : "spontaneous", "spontaenous abortion"

  - "TOP" : "termination", "terminated", "termination of pregnancy"

  - "ECT" : "ectopic", "ectopic pregnancy"

  - FALSE : `0`, `FALSE`, "no", `NA`

## Value

an factor vector containing the transformed variable "SAB", "TOP",
"ECT", "FALSE"

## Examples

``` r
miscarriage_to_factor(c(
   "spontaneous", "spontaenous abortion",
  "termination", "terminated", "termination of pregnancy",
  "ectopic", "ectopic pregnancy",
  "0", "false", "no", "NA"
))
#>  [1] SAB   SAB   TOP   TOP   TOP   ECT   ECT   FALSE FALSE FALSE FALSE
#> Levels: SAB TOP ECT FALSE
```
