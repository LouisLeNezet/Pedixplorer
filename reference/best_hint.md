# Best hint for a Pedigree alignment

When computer time is cheap, use this routine to get a *best* Pedigree
alignment. This routine will try all possible founder orders, and return
the one with the least **stress**.

## Usage

``` r
# S4 method for class 'Pedigree'
best_hint(
  obj,
  wt = c(1000, 10, 1),
  tolerance = 0,
  align_parents = TRUE,
  force = FALSE,
  timeout = 60
)
```

## Arguments

- obj:

  A Pedigree object

- wt:

  A vector of three weights for the three error measures. Default is
  `c(1000, 10, 1)`.

  1.  The number of duplicate individuals in the plot

  2.  The sum of the absolute values of the differences in the positions
      of duplicate individuals

  3.  The sum of the absolute values of the differences between the
      center of the children and the parents.

- tolerance:

  The maximum stress level to accept. Default is `0`

- align_parents:

  If `align_parents = TRUE`, go one step further and try to make both
  parents of each child have the same depth. (This is not always
  possible). It helps the drawing program by lining up pedigrees that
  'join in the middle' via a marriage.

- force:

  If `force = TRUE`, the function will return the depth minus
  `min(depth)` if `depth` reach a state with no founders is not
  possible.

- timeout:

  The maximum time in seconds to spend searching for the best hint.
  Default is `60` seconds.

## Value

The best Hints object out of all the permutations

## Details

The
[`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md)
routine will rearrange sibling order, but not founder order. This calls
[`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md)
with every possible founder order, and finds that plot with the least
"stress". The stress is computed as a weighted sum of three error
measures:

- nbArcs The number of duplicate individuals in the plot

- lgArcs The sum of the absolute values of the differences in the
  positions of duplicate individuals

- lgParentsChilds The sum of the absolute values of the differences
  between the center of the children and the parents

\$\$stress = wt\[1\] \* nbArcs + wt\[2\] \* lgArcs + wt\[3\] \*
lgParentsChilds \$\$

If during the search, a plot is found with a stress level less than
**tolerance**, the search is terminated.

## See also

[`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md),
[`align()`](https://louislenezet.github.io/Pedixplorer/reference/align.md)

## Examples

``` r
data(sampleped)
pedi <- Pedigree(sampleped[sampleped$famid == 1,])
best_hint(pedi)
#> An object of class "Hints"
#> Slot "horder":
#> 1_101 1_102 1_103 1_104 1_105 1_106 1_107 1_108 1_109 1_110 1_111 1_112 1_113 
#>     1     1     3     4     5     3     7     4     9     1     2     3    13 
#> 1_114 1_115 1_116 1_117 1_118 1_119 1_120 1_121 1_122 1_123 1_124 1_125 1_126 
#>     4     1     3    17     2     4    20    21    22    23    24    25    26 
#> 1_127 1_128 1_129 1_130 1_131 1_132 1_133 1_134 1_135 1_136 1_137 1_138 1_139 
#>    27    28    29    30    31    32    33    34    35     2    37    38    39 
#> 1_140 1_141 
#>    40    41 
#> 
#> Slot "spouse":
#>     idl   idr anchor
#> 1 1_112 1_118  right
#> 2 1_114 1_115  right
#> 3 1_109 1_110   left
#> 
```
