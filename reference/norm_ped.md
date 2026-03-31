# Normalise a Ped object dataframe

Normalise dataframe for a Ped object

## Usage

``` r
norm_ped(
  ped_df,
  na_strings = c("NA", ""),
  missid = c(NA_character_, "0"),
  try_num = FALSE,
  cols_used_del = FALSE,
  date_pattern = "%Y-%m-%d"
)
```

## Arguments

- ped_df:

  A data.frame with the individuals informations. The minimum columns
  required are:

  - `id` individual identifiers

  - `dadid` biological fathers identifiers

  - `momid` biological mothers identifiers

  - `sex` of the individual

  The `famid` column, if provided, will be merged to the *ids* field
  separated by an underscore using the
  [`upd_famid()`](https://louislenezet.github.io/Pedixplorer/reference/upd_famid.md)
  function.

  The following columns are also recognize and will be transformed with
  the
  [`vect_to_binary()`](https://louislenezet.github.io/Pedixplorer/reference/vect_to_binary.md)
  function:

  - `deceased` status -\> is the individual dead

  - `avail` status -\> is the individual available

  - `evaluated` status -\> has the individual a documented evaluation

  - `consultand` status -\> is the individual the consultand

  - `proband` status -\> is the individual the proband

  - `carrier` status -\> is the individual a carrier

  - `asymptomatic` status -\> is the individual asymptomatic

  - `adopted` status -\> is the individual adopted

  The values recognized for those columns are `1` or `0`, `TRUE` or
  `FALSE`.

  The `fertility` column will be transformed to a factor using the
  [`fertility_to_factor()`](https://louislenezet.github.io/Pedixplorer/reference/fertility_to_factor.md)
  function. `infertile_choice_na`, `infertile`, `fertile`

  The `miscarriage` column will be transformed to a using the
  [`miscarriage_to_factor()`](https://louislenezet.github.io/Pedixplorer/reference/miscarriage_to_factor.md)
  function. `SAB`, `TOP`, `ECT`, `FALSE`

  The `dateofbirth` and `dateofdeath` columns will be transformed to a
  date object using the
  [`char_to_date()`](https://louislenezet.github.io/Pedixplorer/reference/char_to_date.md)
  function.

- na_strings:

  Vector of strings to be considered as NA values.

- missid:

  A character vector with the missing values identifiers. All the id,
  dadid and momid corresponding to those values will be set to
  `NA_character_`.

- try_num:

  Boolean defining if the function should try to convert all the columns
  to numeric.

- cols_used_del:

  Boolean defining if the columns that will be used should be deleted.

- date_pattern:

  The pattern of the date

## Value

A dataframe with different variable correctly standardized and with the
errors identified in the `error` column

## Details

Normalise a dataframe and check for columns correspondance to be able to
use it as an input to create a Ped object. Multiple test are done and
errors are checked.

Will be considered available any individual with no 'NA' values in the
`available` column. Duplicated `id` will nullify the relationship of the
individual. All individuals with errors will be remove from the
dataframe and will be transfered to the error dataframe.

A number of checks are done to ensure the dataframe is correct:

### On identifiers:

- All ids (id, dadid, momid, famid) are not empty (`!= ""`)

- All `id` are unique (no duplicated)

- All `dadid` and `momid` are unique in the id column (no duplicated)

- id is not the same as dadid or momid

- Either have both parents or none

### On sex:

- All sex code are either `male`, `female`, or `unknown`.

- No parents are infertile or aborted

- All fathers are male

- All mothers are female

## See also

[`Ped()`](https://louislenezet.github.io/Pedixplorer/reference/Ped-class.md)
[Ped](https://louislenezet.github.io/Pedixplorer/reference/Ped-class.md)
[`Pedigree()`](https://louislenezet.github.io/Pedixplorer/reference/Pedigree-class.md)

## Examples

``` r
df <- data.frame(
    id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
    dadid = c("A", 0, 1, 3, 0, 4, 1, 0, 6, 6),
    momid = c(0, 0, 2, 2, 0, 5, 2, 0, 8, 8),
    famid = c(1, 1, 1, 1, 1, 1, 1, 2, 2, 2),
    sex = c(1, 2, "m", "man", "f", "male", "m", 3, NA, "f"),
    fertility = c(
      "TRUE", "FALSE", TRUE, FALSE, 1,
      0, "fertile", "infertile", 1, "TRUE"
    ),
    miscarriage = c("TOB", "SAB", NA, FALSE, "ECT", "other", 1, 0, 1, 0),
    deceased = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, 1, 0, 1, 0),
    avail = c("A", "1", 0, NA, 1, 0, 1, 0, 1, 0),
    evalutated = c(
        "TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"
    ),
    consultand = c(
        "TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"
    ),
    proband = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"),
    carrier = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"),
    asymptomatic = c(
        "TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"
    ),
    adopted = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"),
    dateofbirth = c(
         "1978-01-01", "1980-01-01", "1982-01-01", "1984-01-01",
         "1986-01-01", "1988-01-01", "1990-01-01", "1992-01-01",
         "1994-01-01", "1996-01-01"
    ),
    dateofdeath = c(
        "2000-01-01", "2002-01-01", "2004-01-01", NA, "date-not-recognize",
        "NA", "", NA, "2008/01/01", NA
    )
)
tryCatch(
    norm_ped(df),
    error = function(e) print(e)
)
#> Warning: NAs introduced by coercion
#> Warning: NAs introduced by coercion
#> Warning: NAs introduced by coercion
#> Warning: NAs introduced by coercion
#> Warning: NAs introduced by coercion
#> Warning: NAs introduced by coercion
#>      id dadid momid famid     sex fertility miscarriage deceased avail
#> 1   1_1   1_A  <NA>     1    male   fertile       FALSE     TRUE    NA
#> 2   1_2  <NA>  <NA>     1  female infertile         SAB    FALSE  TRUE
#> 3   1_3   1_1   1_2     1    male   fertile       FALSE     TRUE FALSE
#> 4   1_4   1_3   1_2     1    male infertile       FALSE    FALSE    NA
#> 5   1_5  <NA>  <NA>     1  female   fertile         ECT     TRUE  TRUE
#> 6   1_6   1_4   1_5     1    male infertile       FALSE    FALSE FALSE
#> 7   1_7   1_1   1_2     1    male   fertile       FALSE     TRUE  TRUE
#> 8   2_8  <NA>  <NA>     2  female infertile       FALSE    FALSE FALSE
#> 9   2_9   2_6   2_8     2 unknown   fertile       FALSE     TRUE  TRUE
#> 10 2_10   2_6   2_8     2  female   fertile       FALSE    FALSE FALSE
#>    evalutated consultand proband carrier asymptomatic adopted dateofbirth
#> 1        TRUE       TRUE    TRUE    TRUE         TRUE    TRUE  1978-01-01
#> 2       FALSE      FALSE   FALSE   FALSE        FALSE   FALSE  1980-01-01
#> 3        TRUE       TRUE    TRUE    TRUE         TRUE    TRUE  1982-01-01
#> 4       FALSE      FALSE   FALSE   FALSE        FALSE   FALSE  1984-01-01
#> 5           1       TRUE    TRUE    TRUE         TRUE    TRUE  1986-01-01
#> 6           0      FALSE   FALSE   FALSE        FALSE   FALSE  1988-01-01
#> 7        <NA>      FALSE   FALSE      NA           NA   FALSE  1990-01-01
#> 8        <NA>      FALSE   FALSE      NA           NA   FALSE  1992-01-01
#> 9       other      FALSE   FALSE      NA           NA   FALSE  1994-01-01
#> 10          0      FALSE   FALSE   FALSE        FALSE   FALSE  1996-01-01
#>    dateofdeath
#> 1   2000-01-01
#> 2   2002-01-01
#> 3   2004-01-01
#> 4         <NA>
#> 5         <NA>
#> 6         <NA>
#> 7         <NA>
#> 8         <NA>
#> 9         <NA>
#> 10        <NA>
#>                                                                               error
#> 1                                                                one-parent-missing
#> 2  is-infertile-but-is-parent_is-aborted-but-is-parent_is-aborted-but-has-fertility
#> 3                                                                              <NA>
#> 4                                                        is-infertile-but-is-parent
#> 5                                                          is-aborted-but-is-parent
#> 6                                                                              <NA>
#> 7                                                                              <NA>
#> 8                                                        is-infertile-but-is-parent
#> 9                                                                              <NA>
#> 10                                                                             <NA>
#>    evaluated
#> 1      FALSE
#> 2      FALSE
#> 3      FALSE
#> 4      FALSE
#> 5      FALSE
#> 6      FALSE
#> 7      FALSE
#> 8      FALSE
#> 9      FALSE
#> 10     FALSE
```
