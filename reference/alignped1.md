# Alignment first routine

First alignment routine which create the subtree founded on a single
subject as though it were the only tree.

## Usage

``` r
alignped1(idx, dadx, momx, level, horder, packed, spouselist)
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

In this routine the **nid** array consists of the final
`nid array + 1/2` of the final spouse array. Note that the
**spouselist** matrix will only contain spouse pairs that are not yet
processed. The logic for anchoring is slightly tricky.

### 1. Anchoring:

First, if col 4 of the spouselist matrix is 0, we anchor at the first
opportunity. Also note that if `spouselist[, 3] == spouselist[, 4]` it
is the husband who is the anchor (just write out the possibilities).

### 2. Return values initialization:

Create the set of 3 return structures, which will be matrices with
`1 + nspouse` columns. If there are children then other routines will
widen the result.

### 3. Create **lspouse** and **rspouse**:

This two complimentary lists denote the spouses plotted on the left and
on the right. For someone with lots of spouses we try to split them
evenly. If the number of spouses is odd, then men should have more on
the right than on the left, women more on the right. Any hints in the
spouselist matrix override. We put the undecided marriages closest to
**idx**, then add predetermined ones to the left and right. The majority
of marriages will be undetermined singletons, for which **nleft** will
be `1` for female (put my husband to the left) and `0` for male. In one
bug found by plotting canine data, lspouse could initially be empty but
`length(rspouse) > 1`. This caused `nleft > length(indx)`. A fix was to
not let **indx** to be indexed beyond its length, fix by JPS 5/2013.

### 4. List the children:

For each spouse get the list of children. If there are any we call
[`alignped2()`](https://louislenezet.github.io/Pedixplorer/reference/alignped2.md)
to generate their tree and then mark the connection to their parent. If
multiple marriages have children we need to join the trees.

### 5. Splice the tree:

To finish up we need to splice together the tree made up from all the
kids, which only has data from `lev + 1` down, with the data here. There
are 3 cases:

1.  No children were found.

2.  The tree below is wider than the tree here, in which case we add the
    data from this level onto theirs.

3.  The tree below is narrower, for instance an only child.

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
