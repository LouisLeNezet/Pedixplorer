# Compute the stress of a hint

This is a helper function for
[`best_hint()`](https://louislenezet.github.io/Pedixplorer/reference/best_hint.md).
It computes the stress of a given hint by aligning the Pedigree and
computing the error measures.

## Usage

``` r
compute_stress(
  obj,
  newhint,
  wt = c(1000, 10, 1),
  align_parents = TRUE,
  force = FALSE
)
```

## Arguments

- obj:

  A Pedigree object

- newhint:

  A Hints object with the new hints

- wt:

  A vector of three weights for the three error measures. Default is
  `c(1000, 10, 1)`.

  1.  The number of duplicate individuals in the plot

  2.  The sum of the absolute values of the differences in the positions
      of duplicate individuals

  3.  The sum of the absolute values of the differences between the
      center of the children and the parents.

- align_parents:

  If `align_parents = TRUE`, go one step further and try to make both
  parents of each child have the same depth. (This is not always
  possible). It helps the drawing program by lining up pedigrees that
  'join in the middle' via a marriage.

- force:

  If `force = TRUE`, the function will return the depth minus
  `min(depth)` if `depth` reach a state with no founders is not
  possible.

## Value

The stress value of the hint

## See also

[`best_hint()`](https://louislenezet.github.io/Pedixplorer/reference/best_hint.md),
[`align()`](https://louislenezet.github.io/Pedixplorer/reference/align.md)

## Examples

``` r
data(sampleped)
pedi <- Pedigree(sampleped[sampleped$famid == 1,])
newhint <- auto_hint(pedi, align_parents = TRUE)
Pedixplorer:::compute_stress(pedi, newhint)
#> [1] 2121.45
```
