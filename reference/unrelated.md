# Find Unrelated subjects

Determine set of maximum number of unrelated available subjects from a
Pedigree.

## Usage

``` r
# S4 method for class 'Ped'
unrelated(obj, avail = NULL)

# S4 method for class 'Pedigree'
unrelated(obj, avail = NULL)
```

## Arguments

- obj:

  A Pedigree or Ped object.

- avail:

  A logical vector with the availability status of the individuals (i.e.
  `FALSE` = not available, `TRUE` = available, `NA` = unknown).

## Value

A vector of the ids of subjects that are unrelated.

## Details

Determine set of maximum number of unrelated available subjects from a
Pedigree, given vectors id, father, and mother for a Pedigree structure,
and status vector of `TRUE` / `FALSE` for whether each subject is
available (e.g. has DNA).

This is a greedy algorithm that uses the kinship matrix, sequentially
removing rows/cols that are non-zero for subjects that have the most
number of zero kinship coefficients (greedy by choosing a row of kinship
matrix that has the most number of zeros, and then remove any cols and
their corresponding rows that are non-zero. To account for ties of the
count of zeros for rows, a random choice is made. Hence, running this
function multiple times can return different sets of unrelated subjects.

If **avail** is `NULL`, it is extracted with its corresponding accessor
from the Ped object.

## Author

Dan Schaid and Shannon McDonnell updated by Jason Sinnwell

## Examples

``` r
data(sampleped)
fam1 <- sampleped[sampleped$famid == 1, -16]
ped1 <- Pedigree(fam1)
unrelated(ped1)
#> [1] "1_109" "1_113" "1_118" "1_141"
## some possible vectors
## [1] '110' '113' '133' '109'
## [1] '113' '118' '141' '109'
## [1] '113' '118' '140' '109'
## [1] '110' '113' '116' '109'
## [1] '113' '133' '141' '109'
```
