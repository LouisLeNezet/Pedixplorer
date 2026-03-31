# Find uninformative but available subject

Finds subjects from among available non-parents with all affection equal
to `0`.

## Usage

``` r
# S4 method for class 'Ped'
find_avail_noninform(obj, avail = NULL, affected = NULL)

# S4 method for class 'Pedigree'
find_avail_noninform(obj, avail = NULL, affected = NULL)
```

## Arguments

- obj:

  A Ped or Pedigree object.

- avail:

  A logical vector with the availability status of the individuals (i.e.
  `FALSE` = not available, `TRUE` = available, `NA` = unknown).

- affected:

  A logical vector with the affection status of the individuals (i.e.
  `FALSE` = unaffected, `TRUE` = affected, `NA` = unknown).

## Value

Vector of subject ids who can be removed by having lowest
informativeness.

## Details

Identify subjects to remove from a Pedigree who are available but
non-informative (unaffected). This is the second step to remove subjects
in
[`shrink()`](https://louislenezet.github.io/Pedixplorer/reference/shrink.md)
if the Pedigree does not meet the desired bit size.

If **avail** or **affected** is null, then the function will use the
corresponding Ped accessor.

## See also

[`shrink()`](https://louislenezet.github.io/Pedixplorer/reference/shrink.md)

## Examples

``` r
data(sampleped)
pedi <- Pedigree(sampleped)
find_avail_noninform(pedi)
#>  [1] "1_101" "1_102" "1_107" "1_108" "1_111" "1_113" "1_121" "1_122" "1_123"
#> [10] "1_131" "1_132" "1_134" "1_139" "2_205" "2_210" "2_213"
```
