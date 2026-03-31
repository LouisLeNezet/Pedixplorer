# Evaluate a permutation of founder mothers

This is a helper function for
[`best_hint()`](https://louislenezet.github.io/Pedixplorer/reference/best_hint.md).
It evaluates a permutation of founder mothers by creating a new hint and
computing the stress of the hint.

## Usage

``` r
eval_perm(idx, fmom, pmat, obj, n, wt, align_parents, force)
```

## Arguments

- idx:

  The index of the permutation to evaluate

- fmom:

  The vector of founder mother indices

- pmat:

  The matrix of permutations of founder mothers

- obj:

  A Pedigree object

- n:

  The number of individuals in the Pedigree

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

The stress value of the hint and the new hint

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
