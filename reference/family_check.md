# Check family

Error check for a family classification

## Usage

``` r
# S4 method for class 'character_OR_integer'
family_check(obj, dadid, momid, famid, newfam)

# S4 method for class 'Pedigree'
family_check(obj)

# S4 method for class 'Ped'
family_check(obj)
```

## Arguments

- obj:

  A character vector with the id of the individuals or a `data.frame`
  with all the informations in corresponding columns.

- dadid:

  A vector containing for each subject, the identifiers of the
  biologicals fathers.

- momid:

  A vector containing for each subject, the identifiers of the
  biologicals mothers.

- famid:

  A character vector with the family identifiers of the individuals. If
  provide, will be aggregated to the individuals identifiers separated
  by an underscore.

- newfam:

  The result of a call to
  [`make_famid()`](https://louislenezet.github.io/Pedixplorer/reference/make_famid.md).
  If this has already been computed by the user, adding it as an
  argument shortens the running time somewhat.

## Value

a data frame with one row for each unique family id in the `famid`
argument or the one detected in the Pedigree object. Components of the
output are:

- `famid` : The family id, as entered into the data set

- `n` : Number of subjects in the family

- `unrelated` : Number of them that appear to be unrelated to anyone
  else in the entire Pedigree. This is usually marry-ins with no
  children (in the Pedigree), and if so are not a problem.

- `split` : Number of unique 'new' family ids.

  - `0` = no one in this 'family' is related to anyone else (not good)

  - `1` = everythings is fine

  - `2` and + = the family appears to be a set of disjoint trees. Are
    you missing some of the people?

- `join` : Number of other families that had a unique family, but are
  actually joined to this one. 0 is the hope.

## Details

Given a family id vector, also compute the familial grouping from first
principles using the parenting data, and compare the results.

The
[`make_famid()`](https://louislenezet.github.io/Pedixplorer/reference/make_famid.md)
function is used to create a de novo family id from the parentage data,
and this is compared to the family id given in the data.

If there are any joins, then an attribute 'join' is attached. It will be
a matrix with family as row labels, new-family-id as the columns, and
the number of subjects as entries.

## See also

[`make_famid()`](https://louislenezet.github.io/Pedixplorer/reference/make_famid.md)

## Examples

``` r
# use 2 samplepeds
data(sampleped)
pedAll <- Pedigree(sampleped)

## check them giving separate ped ids
fcheck.sep <- family_check(pedAll)
fcheck.sep
#>   famid  n unrelated split join
#> 1     1 41         1     1    0
#> 2     2 14         0     1    0

## check assigning them same ped id
fcheck.combined <- with(sampleped, family_check(id, dadid, momid,
rep(1, nrow(sampleped))))
fcheck.combined
#>   famid  n unrelated split join
#> 1     1 55         1     2    0
```
