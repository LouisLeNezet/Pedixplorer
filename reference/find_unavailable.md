# Find unavailable subjects in a Pedigree

Find the identifiers of subjects in a Pedigree iteratively, as anyone
who is not available and does not have an available descendant by
successively removing unavailable terminal nodes.

## Usage

``` r
# S4 method for class 'Ped'
find_unavailable(obj, avail = NULL)

# S4 method for class 'Pedigree'
find_unavailable(obj, avail = NULL)
```

## Arguments

- obj:

  A Ped or Pedigree object.

- avail:

  A logical vector with the availability status of the individuals (i.e.
  `FALSE` = not available, `TRUE` = available, `NA` = unknown).

## Value

Returns a vector of subject ids for who can be removed.

## Details

If **avail** is null, then the function will use the corresponding Ped
accessor.

Originally written as pedTrim by Steve Iturria, modified by Dan Schaid
2007, and now split into the two separate functions:
`find_unavailable()`, and `trim()` to do the tasks separately.
`find_unavailable()` calls
[`exclude_stray_marryin()`](https://louislenezet.github.io/Pedixplorer/reference/exclude_stray_marryin.md)
to find stray available marry-ins who are isolated after trimming their
unavailable offspring, and
[`exclude_unavail_founders()`](https://louislenezet.github.io/Pedixplorer/reference/exclude_unavail_founders.md).
If the subject ids are character, make sure none of the characters in
the ids is a colon (":"), which is a special character used to
concatenate and split subjects within the utility. The `trim()`
functions is now replaced by the
[`subset()`](https://rdrr.io/r/base/subset.html) function.

## Side Effects

Relation matrix from subsetting is trimmed of any special relations that
include the subjects to trim.

## See also

[`shrink()`](https://louislenezet.github.io/Pedixplorer/reference/shrink.md)

## Examples

``` r
data(sampleped)
ped1 <- Pedigree(sampleped[sampleped$famid == "1",])
find_unavailable(ped1)
#>  [1] "1_101" "1_102" "1_107" "1_108" "1_111" "1_113" "1_121" "1_122" "1_123"
#> [10] "1_131" "1_132" "1_134" "1_139"
```
