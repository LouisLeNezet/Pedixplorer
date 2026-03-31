# Fix parents relationship and gender

Fix the sex of parents, add parents that are missing from the data. Can
be used with a dataframe or a vector of the different individuals
informations.

## Usage

``` r
# S4 method for class 'character'
fix_parents(obj, dadid, momid, sex, famid = NULL, missid = NA_character_)

# S4 method for class 'data.frame'
fix_parents(obj, del_parents = NULL, filter = NULL, missid = NA_character_)
```

## Arguments

- obj:

  A data.frame or a vector of the individuals identifiers. If a
  dataframe is given it must contain the columns `id`, `dadid`, `momid`,
  `sex` and `famid` (optional).

- dadid:

  A vector containing for each subject, the identifiers of the
  biologicals fathers.

- momid:

  A vector containing for each subject, the identifiers of the
  biologicals mothers.

- sex:

  A character, factor or numeric vector corresponding to the gender of
  the individuals. This will be transformed to an ordered factor with
  the following levels: `male` \< `female` \< `unknown`

  The following values are recognized:

  - "male": "m", "male", "man", `1`

  - "female": "f", "female", "woman", `2`

  - "unknown": "unknown", `3`

- famid:

  A character vector with the family identifiers of the individuals. If
  provide, will be aggregated to the individuals identifiers separated
  by an underscore.

- missid:

  A character vector with the missing values identifiers. All the id,
  dadid and momid corresponding to those values will be set to
  `NA_character_`.

- del_parents:

  Boolean defining if missing parents needs to be deleted or fixed. If
  `one` then if one of the parent is missing, both are removed, if
  `both` then if both parents are missing, both are removed. If `NULL`
  then no parent is removed and the missing parents are added as new
  rows.

- filter:

  Filtering column containing `0` or `1` for the rows to kept before
  proceeding.

## Value

A data.frame with id, dadid, momid, sex as columns with the
relationships fixed.

## Details

First look to add parents whose ids are given in momid/dadid. Second,
fix sex of parents. Last look to add second parent for children for whom
only one parent id is given. If a **famid** vector is given the family
id will be added to the ids of all individuals (`id`, `dadid`, `momid`)
separated by an underscore before proceeding.

### Special case for dataframe

Check for presence of both parents id in the **id** field. If not both
presence behaviour depend of **delete** parameter

- If `TRUE` then use fix_parents function and merge back the other
  fields in the dataframe then set availability to `O` for non available
  parents.

- If `FALSE` then delete the id of missing parents

## Author

Jason Sinnwell

## Examples

``` r
test1char <- data.frame(
    id = paste('fam', 101:111, sep = ''),
    sex = c('male', 'female')[c(1, 2, 1, 2, 1, 1, 2, 2, 1, 2, 1)],
    father = c(
        0, 0, 'fam101', 'fam101', 'fam101', 0, 0,
        'fam106', 'fam106', 'fam106', 'fam109'
    ),
    mother = c(
        0, 0, 'fam102', 'fam102', 'fam102', 0, 0,
        'fam107', 'fam107', 'fam107', 'fam112'
    )
)
test1newmom <- with(test1char, fix_parents(id, father, mother,
    sex,
    missid = NA_character_
))
Pedigree(test1newmom)
#> Warning: The Pedigree informations are not valid. Here is the normalised Pedigree informations with the identified problems
#>          id    momid    dadid    sex famid             error fertility
#> 1  1_fam101     <NA>     <NA>   male     1              <NA>   fertile
#> 2  1_fam102     <NA>     <NA> female     1              <NA>   fertile
#> 3  1_fam103 1_fam102 1_fam101   male     1              <NA>   fertile
#> 4  1_fam104 1_fam102 1_fam101 female     1              <NA>   fertile
#> 5  1_fam105 1_fam102 1_fam101   male     1              <NA>   fertile
#> 6  1_fam106     <NA>     <NA>   male     1              <NA>   fertile
#> 7  1_fam107     <NA>     <NA> female     1              <NA>   fertile
#> 8  1_fam108 1_fam107 1_fam106 female     1              <NA>   fertile
#> 9  1_fam109 1_fam107 1_fam106   male     1              <NA>   fertile
#> 10 1_fam110 1_fam107 1_fam106 female     1              <NA>   fertile
#> 11 1_fam111 1_fam112 1_fam109   male     1              <NA>   fertile
#> 12     <NA>     <NA>     <NA>   male     1 is-its-own-parent   fertile
#> 13     <NA>     <NA>     <NA> female  <NA> is-its-own-parent   fertile
#> 14 1_fam112     <NA>     <NA> female     1              <NA>   fertile
#>    miscarriage deceased avail evaluated consultand proband carrier asymptomatic
#> 1        FALSE       NA    NA     FALSE      FALSE   FALSE      NA           NA
#> 2        FALSE       NA    NA     FALSE      FALSE   FALSE      NA           NA
#> 3        FALSE       NA    NA     FALSE      FALSE   FALSE      NA           NA
#> 4        FALSE       NA    NA     FALSE      FALSE   FALSE      NA           NA
#> 5        FALSE       NA    NA     FALSE      FALSE   FALSE      NA           NA
#> 6        FALSE       NA    NA     FALSE      FALSE   FALSE      NA           NA
#> 7        FALSE       NA    NA     FALSE      FALSE   FALSE      NA           NA
#> 8        FALSE       NA    NA     FALSE      FALSE   FALSE      NA           NA
#> 9        FALSE       NA    NA     FALSE      FALSE   FALSE      NA           NA
#> 10       FALSE       NA    NA     FALSE      FALSE   FALSE      NA           NA
#> 11       FALSE       NA    NA     FALSE      FALSE   FALSE      NA           NA
#> 12       FALSE       NA    NA     FALSE      FALSE   FALSE      NA           NA
#> 13       FALSE       NA    NA     FALSE      FALSE   FALSE      NA           NA
#> 14       FALSE       NA    NA     FALSE      FALSE   FALSE      NA           NA
#>    adopted dateofbirth dateofdeath
#> 1    FALSE        <NA>        <NA>
#> 2    FALSE        <NA>        <NA>
#> 3    FALSE        <NA>        <NA>
#> 4    FALSE        <NA>        <NA>
#> 5    FALSE        <NA>        <NA>
#> 6    FALSE        <NA>        <NA>
#> 7    FALSE        <NA>        <NA>
#> 8    FALSE        <NA>        <NA>
#> 9    FALSE        <NA>        <NA>
#> 10   FALSE        <NA>        <NA>
#> 11   FALSE        <NA>        <NA>
#> 12   FALSE        <NA>        <NA>
#> 13   FALSE        <NA>        <NA>
#> 14   FALSE        <NA>        <NA>
```
