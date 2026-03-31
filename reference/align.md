# Align a Pedigree object

Given a Pedigree, this function creates helper matrices that describe
the layout of a plot of the Pedigree.

## Usage

``` r
# S4 method for class 'Pedigree'
align(
  obj,
  packed = TRUE,
  width = 10,
  align = TRUE,
  hints = NULL,
  missid = "NA_character_",
  align_parents = TRUE,
  force = FALSE,
  precision = 4
)
```

## Arguments

- obj:

  A Pedigree object

- packed:

  Should the Pedigree be compressed. (i.e. allow diagonal lines
  connecting parents to children in order to have a smaller overall
  width for the plot.)

- width:

  For a packed output, the minimum width of the plot, in inches.

- align:

  For a packed Pedigree, align children under parents `TRUE`, to the
  extent possible given the page width, or align to to the left margin
  `FALSE`. This argument can be a two element vector, giving the
  alignment parameters, or a logical value. If `TRUE`, the default is
  `c(1.5, 2)`, or if numeric the routine
  [`alignped4()`](https://louislenezet.github.io/Pedixplorer/reference/alignped4.md)
  will be called.

- hints:

  A Hints object or a named list containing `horder` and `spouse`. If
  `NULL` then the Hints stored in **obj** will be used.

- missid:

  A character vector with the missing values identifiers. All the id,
  dadid and momid corresponding to those values will be set to
  `NA_character_`.

- align_parents:

  If `align_parents = TRUE`, go one step further and try to make both
  parents of each child have the same depth. (This is not always
  possible). It helps the drawing program by lining up pedigrees that
  'join in the middle' via a marriage.

- force:

  If `force = TRUE`, the function will return the depth minus
  `min(depth)` if `depth` reach a state with no founders is not
  possible.

- precision:

  The number of significatif numbers to round the solution to.

## Value

A list with components

- `n`: A vector giving the number of subjects on each horizonal level of
  the plot

- `nid`: A matrix with one row for each level, giving the numeric id of
  each subject plotted. (A value of `17` means the 17th subject in the
  Pedigree).

- `pos`: A matrix giving the horizontal position of each plot point

- `fam`: A matrix giving the family id of each plot point. A value of
  `3` would mean that the two subjects in positions 3 and 4, in the row
  above, are this subject's parents.

- `spouse`: A matrix with values

  - `0` = not a spouse

  - `1` = subject plotted to the immediate right is a spouse

  - `2` = subject plotted to the immediate right is an inbred spouse

- `twins`: Optional matrix which will only be present if the Pedigree
  contains twins :

  - `0` = not a twin

  - `1` = sibling to the right is a monozygotic twin

  - `2` = sibling to the right is a dizygotic twin

  - `3` = sibling to the right is a twin of unknown zygosity

## Details

This is an internal routine, used almost exclusively by
[`ped_to_plotdf()`](https://louislenezet.github.io/Pedixplorer/reference/ped_to_plotdf.md).

The subservient functions
[`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md),
[`alignped1()`](https://louislenezet.github.io/Pedixplorer/reference/alignped1.md),
[`alignped2()`](https://louislenezet.github.io/Pedixplorer/reference/alignped2.md),
[`alignped3()`](https://louislenezet.github.io/Pedixplorer/reference/alignped3.md),
and
[`alignped4()`](https://louislenezet.github.io/Pedixplorer/reference/alignped4.md)
contain the bulk of the computation.

If the **hints** are missing the
[`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md)
routine is called to supply an initial guess.

If multiple families are present in the **obj** Pedigree, this routine
is called once for each family, and the results are combined in the list
returned.

For more information you can read the associated vignette:
[`vignette("pedigree_alignment")`](https://louislenezet.github.io/Pedixplorer/articles/pedigree_alignment.md).

## See also

[`alignped1()`](https://louislenezet.github.io/Pedixplorer/reference/alignped1.md),
[`alignped2()`](https://louislenezet.github.io/Pedixplorer/reference/alignped2.md),
[`alignped3()`](https://louislenezet.github.io/Pedixplorer/reference/alignped3.md),
[`alignped4()`](https://louislenezet.github.io/Pedixplorer/reference/alignped4.md),
[`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md)

## Examples

``` r
data(sampleped)
pedi <- Pedigree(sampleped)
align(pedi)
#> $`1`
#> $`1`$n
#> [1]  2 10 16 14
#> 
#> $`1`$nid
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12] [,13] [,14]
#> [1,]   35   36    0    0    0    0    0    0    0     0     0     0     0     0
#> [2,]    1    2    3    4   37   38    5    6    7     8     0     0     0     0
#> [3,]    9   10   11   12   14   39   40   41   14    15    12    18    17    16
#> [4,]   21   22   23   24   27   28   25   26   29    30    31    32    33    34
#>      [,15] [,16]
#> [1,]     0     0
#> [2,]     0     0
#> [3,]    19    20
#> [4,]     0     0
#> 
#> $`1`$pos
#>       [,1]  [,2]  [,3]  [,4]  [,5]  [,6]  [,7]  [,8]  [,9] [,10] [,11] [,12]
#> [1,] 3.804 4.804 0.000 0.000 0.000 0.000  0.00  0.00  0.00  0.00  0.00  0.00
#> [2,] 0.000 1.000 2.804 3.804 4.804 5.804 11.25 12.25 14.01 15.01  0.00  0.00
#> [3,] 0.000 1.000 2.000 3.000 4.000 5.000  6.00  7.00  8.00  9.00 10.00 11.00
#> [4,] 0.000 1.000 2.000 3.000 6.010 7.010  8.01  9.01 10.01 11.01 12.01 13.01
#>      [,13] [,14] [,15] [,16]
#> [1,]  0.00  0.00     0     0
#> [2,]  0.00  0.00     0     0
#> [3,] 12.00 13.00    14    15
#> [4,] 14.01 15.01     0     0
#> 
#> $`1`$fam
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12] [,13] [,14]
#> [1,]    0    0    0    0    0    0    0    0    0     0     0     0     0     0
#> [2,]    0    0    1    0    0    1    0    0    0     0     0     0     0     0
#> [3,]    1    3    3    3    3    5    5    5    0     7     0     7     0     7
#> [4,]    1    1    1    1    9    9   11   11   13    15    15    15    15    15
#>      [,15] [,16]
#> [1,]     0     0
#> [2,]     0     0
#> [3,]     7     9
#> [4,]     0     0
#> 
#> $`1`$spouse
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12] [,13] [,14]
#> [1,]    1    0    0    0    0    0    0    0    0     0     0     0     0     0
#> [2,]    1    0    1    0    1    0    1    0    1     0     0     0     0     0
#> [3,]    1    0    0    0    0    0    0    0    1     0     1     0     1     0
#> [4,]    0    0    0    0    0    0    0    0    0     0     0     0     0     0
#>      [,15] [,16]
#> [1,]     0     0
#> [2,]     0     0
#> [3,]     1     0
#> [4,]     0     0
#> 
#> 
#> $`2`
#> $`2`$n
#> [1] 2 7 5
#> 
#> $`2`$nid
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7]
#> [1,]    1    2    0    0    0    0    0
#> [2,]    3    4    5    6    7    9    8
#> [3,]   10   11   12   13   14    0    0
#> 
#> $`2`$pos
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7]
#> [1,]  2.7  3.7  0.0  0.0  0.0    0    0
#> [2,]  0.0  1.0  2.0  3.0  4.0    5    6
#> [3,]  0.0  1.0  4.5  5.5  6.5    0    0
#> 
#> $`2`$fam
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7]
#> [1,]    0    0    0    0    0    0    0
#> [2,]    0    1    1    1    1    0    1
#> [3,]    1    1    6    6    6    0    0
#> 
#> $`2`$spouse
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7]
#> [1,]    1    0    0    0    0    0    0
#> [2,]    1    0    0    0    0    1    0
#> [3,]    0    0    0    0    0    0    0
#> 
#> 
```
