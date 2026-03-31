# Alignment third routine

Third of the four co-routines to merges two pedigree trees which are
side by side into a single object.

## Usage

``` r
alignped3(alt1, alt2, packed, space = 1)
```

## Arguments

- alt1:

  Alignment of the first tree

- alt2:

  Alignment of the second tree

- packed:

  Should the Pedigree be compressed. (i.e. allow diagonal lines
  connecting parents to children in order to have a smaller overall
  width for the plot.)

- space:

  Space between two subjects

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

The primary special case is when the rightmost person in the left tree
is the same as the leftmost person in the right tree; we need not plot
two copies of the same person side by side. (When initializing the
output structures do not worry about this, there is no harm if they are
a column bigger than finally needed.) Beyond that the work is simple
book keeping.

### 1. Slide:

For the unpacked case, which is the traditional way to draw a Pedigree
when we can assume the paper is infinitely wide, all parents are
centered over their children. In this case we think if the two trees to
be merged as solid blocks. On input they both have a left margin of 0.
Compute how far over we have to slide the right tree.

### 2. Merge:

Now merge the two trees. Start at the top level and work down.

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
