# Alignment second routine

Second of the four co-routines which takes a collection of siblings,
grows the tree for each, and appends them side by side into a single
tree.

## Usage

``` r
alignped2(idx, dadx, momx, level, horder, packed, spouselist)
```

## Arguments

- idx:

  Indexes of the subjects

- dadx:

  Indexes of the fathers

- momx:

  Indexes of the mothers

- level:

  Vector of the level of each subject

- horder:

  A named numeric vector with one element per subject in the Pedigree.
  It determines the relative horizontal order of subjects within a
  sibship, as well as the relative order of processing for the founder
  couples. (For this latter, the female founders are ordered as though
  they were sisters). The names of the vector should be the individual
  identifiers.

- packed:

  Should the Pedigree be compressed. (i.e. allow diagonal lines
  connecting parents to children in order to have a smaller overall
  width for the plot.)

- spouselist:

  Matrix of spouses with 4 columns:

  - `1`: husband index

  - `2`: wife index

  - `3`: husband anchor

  - `4`: wife anchor

## Value

A list containing the elements to plot the Pedigree. It contains a set
of matrices along with the spouselist matrix. The latter has marriages
removed as they are processed.

- `n` : A vector giving the number of subjects on each horizonal level
  of the plot

- `nid` : A matrix with one row for each level, giving the numeric id of
  each subject plotted. (A value of `17` means the 17th subject in the
  Pedigree).

- `pos` : A matrix giving the horizontal position of each plot point

- `fam` : A matrix giving the family id of each plot point. A value of
  `3` would mean that the two subjects in positions 3 and 4, in the row
  above, are this subject's parents.

- `spouselist` : Spouse matrix with anchors informations

## Details

The input arguments are the same as those to
[`alignped1()`](https://louislenezet.github.io/Pedixplorer/reference/alignped1.md)
with the exception that **idx** will be a vector. This routine does
nothing to the spouselist matrix, but needs to pass it down the tree and
back since one of the routines called by `alignped2()` might change the
matrix.

The code below has one non-obvious special case. Suppose that two sibs
marry. When the first sib is processed by `alignped1` then both partners
(and any children) will be added to the rval structure below. When the
second sib is processed they will come back as a 1 element tree (the
marriage will no longer be on the **spouselist**), which should be added
onto rval. The rule thus is to not add any 1 element tree whose value
(which must be `idx[i]` is already in the rval structure for this level.

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
