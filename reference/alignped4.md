# Alignment fourth routine

Last routines which attempts to line up children under parents and put
spouses and siblings "close" to each other, to the extent possible
within the constraints of page width.

## Usage

``` r
alignped4(rval, spouse, level, width, align, precision = 4)
```

## Arguments

- rval:

  A list with components `n`, `nid`, `pos`, and `fam`.

- spouse:

  A boolean matrix with one row per level representing if the subject is
  a spouse or not.

- level:

  Vector of the level of each subject

- width:

  For a packed output, the minimum width of the plot, in inches.

- align:

  For a packed Pedigree, align children under parents `TRUE`, to the
  extent possible given the page width, or align to to the left margin
  `FALSE`. This argument can be a two element vector, giving the
  alignment parameters, or a logical value. If `TRUE`, the default is
  `c(1.5, 2)`, or if numeric the routine `alignped4()` will be called.

- precision:

  The number of significatif numbers to round the solution to.

## Value

The updated position matrix

## Details

The `alignped4()` routine is the final step of alignment. The current
code does necessary setup and then calls the
[`quadprog::solve.QP()`](https://rdrr.io/pkg/quadprog/man/solve.QP.html)
function.

There are two important parameters for the function:

1.  The maximum width specified. The smallest possible width is the
    maximum number of subjects on a line. If the user suggestion is too
    low it is increased to that amount plus one (to give just a little
    wiggle room).

2.  The align vector of 2 alignment parameters `a` and `b`. For each set
    of siblings `x` with parents at `p_1` and `p_2` the alignment
    penalty is:

    \$\$(1/k^a)\sum\_{i=1}^{k} (x_i - (p_1 + p_2)/2)^2\$\$

    where `k` is the number of siblings in the set.

Using the fact that when `a = 1` :

\$\$\sum(x_i-c)^2 = \sum(x_i-\mu)^2 + k(c-\mu)^2\$\$

then moving a sibship with `k` sibs one unit to the left or right of
optimal will incur the same cost as moving one with only 1 or two sibs
out of place.

If `a = 0` then large sibships are harder to move than small ones. With
the default value `a = 1.5`, they are slightly easier to move than small
ones. The rationale for the default is as long as the parents are
somewhere between the first and last siblings the result looks fairly
good, so we are more flexible with the spacing of a large family. By
tethering all the sibs to a single spot they tend to be kept close to
each other.

The alignment penalty for spouses is \\b(x_1 - x_2)^2\\, which tends to
keep them together. The size of `b` controls the relative importance of
sib-parent and spouse-spouse closeness.

1.  We start by adding in these penalties. The total number of
    parameters in the alignment problem (what we hand to quadprog) is
    the set of `sum(n)` positions. A work array myid keeps track of the
    parameter number for each position so that it is easy to find. There
    is one extra penalty added at the end. Because the penalty amount
    would be the same if all the final positions were shifted by a
    constant, the penalty matrix will not be positive definite;
    `solve.QP()` does not like this. We add a tiny amount of leftward
    pull to the widest line.

2.  If there are `k` subjects on a line there will be `k+1` constraints
    for that line. The first point must be \\\ge 0\\, each subsequent
    one must be at least 1 unit to the right, and the final point must
    be \\\le\\ the max width.

## See also

[`align()`](https://louislenezet.github.io/Pedixplorer/reference/align.md)

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
