# Pedigree object

A pedigree is a ensemble of individuals linked to each other into a
family tree. A Pedigree object store the informations of the individuals
and the special relationships between them. It also permit to store the
informations needed to plot the pedigree (i.e. scales and hints).

### Constructor :

Main constructor of the package. This constructor help to create a
`Pedigree` object from different `data.frame` or a set of vectors.

If any errors are found in the data, the function will return the
data.frame with the errors of the Ped object and the Rel object.

## Usage

``` r
Pedigree(obj, ...)

# S4 method for class 'character_OR_integer'
Pedigree(
  obj,
  dadid,
  momid,
  sex,
  famid = NA,
  fertility = NULL,
  miscarriage = NULL,
  deceased = NULL,
  avail = NULL,
  evaluated = NULL,
  consultand = NULL,
  proband = NULL,
  affections = NULL,
  carrier = NULL,
  asymptomatic = NULL,
  adopted = NULL,
  dateofbirth = NULL,
  dateofdeath = NULL,
  rel_df = NULL,
  missid = c(NA_character_, "0"),
  col_aff = "affection",
  date_pattern = "%Y-%m-%d",
  normalize = TRUE,
  ...
)

# S4 method for class 'data.frame'
Pedigree(
  obj = data.frame(id = character(), dadid = character(), momid = character(), famid =
    character(), sex = numeric(), fertility = numeric(), miscarriage = numeric(),
    deceased = numeric(), avail = numeric(), evaluated = logical(), consultand =
    logical(), proband = logical(), affection = logical(), carrier = logical(),
    asymptomatic = logical(), adopted = logical(), dateofbirth = character(), dateofdeath
    = character()),
  rel_df = data.frame(id1 = character(), id2 = character(), code = numeric(), famid =
    character()),
  cols_ren_ped = list(id = "indId", dadid = "fatherId", momid = "motherId", famid =
    "family", sex = "gender", fertility = c("sterilisation", "steril"), miscarriage =
    c("miscarriage", "aborted"), deceased = c("status", "dead", "vitalStatus"), avail =
    "available", evaluated = "evaluation", consultand = "consultant", proband =
    "proband", affection = "affected", carrier = "carrier", asymptomatic =
    "presymptomatic", adopted = "adoption", dateofbirth = c("dob", "birth"), dateofdeath
    = c("dod", "death")),
  cols_ren_rel = list(id1 = "indId1", id2 = "indId2", famid = "family"),
  hints = list(horder = NULL, spouse = NULL),
  normalize = TRUE,
  missid = c(NA_character_, "0"),
  col_aff = "affection",
  date_pattern = "%Y-%m-%d",
  na_strings = c("NA", "N/A", "None", "none", "null", "NULL"),
  ...
)
```

## Arguments

- obj:

  A vector of the individuals identifiers or a data.frame with the
  individuals informations. See
  [`Ped()`](https://louislenezet.github.io/Pedixplorer/reference/Ped-class.md)
  for more informations.

- ...:

  Arguments passed on to
  [`generate_colors`](https://louislenezet.github.io/Pedixplorer/reference/generate_colors.md)

  :   

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

- fertility:

  A character, factor or numeric vector corresponding to the fertility
  status of the individuals. This will be transformed to a factor with
  the following levels: `infertile_choice_na`, `infertile`, `fertile`

  The following values are recognized:

  - "inferile_choice_na" : "infertile_choice", "infertile_na"

  - "infertile" : "infertile", "steril", `FALSE`, `0`

  - "fertile" : "fertile", `TRUE`, `1`, `NA`

- miscarriage:

  A character, factor or numeric vector corresponding to the miscarriage
  status of the individuals. This will be transformed to a factor with
  the following levels: `TOP`, `SAB`, `ECT`, `FALSE` The following
  values are recognized:

  - "SAB" : "spontaneous", "spontaenous abortion"

  - "TOP" : "termination", "terminated", "termination of pregnancy"

  - "ECT" : "ectopic", "ectopic pregnancy"

  - FALSE : `0`, `FALSE`, "no", `NA`

- deceased:

  A logical vector with the death status of the individuals (i.e.
  `FALSE` = alive, `TRUE` = dead, `NA` = unknown).

- avail:

  A logical vector with the availability status of the individuals (i.e.
  `FALSE` = not available, `TRUE` = available, `NA` = unknown).

- evaluated:

  A logical vector with the evaluation status of the individuals. (i.e.
  `FALSE` = documented evaluation not available, `TRUE` = documented
  evaluation available).

- consultand:

  A logical vector with the consultand status of the individuals. A
  consultand being an individual seeking genetic counseling/testing
  (i.e. `FALSE` = not a consultand, `TRUE` = consultand).

- proband:

  A logical vector with the proband status of the individuals. A proband
  being an affected family member coming to medical attention
  independent of other family members. (i.e. `FALSE` = not a proband,
  `TRUE` = proband).

- affections:

  A logical vector with the affections status of the individuals (i.e.
  `FALSE` = unaffected, `TRUE` = affected, `NA` = unknown). Can also be
  a data.frame with the same length as `obj`. If it is a matrix, it will
  be converted to a data.frame and the columns will be named after the
  `col_aff` argument.

- carrier:

  A logical vector with the carrier status of the individuals. A carrier
  being an individual who has the genetic trait but who is not likely to
  manifest the disease regardless of inheritance pattern (i.e. `FALSE` =
  not carrier, `TRUE` = carrier, `NA` = unknown).

- asymptomatic:

  A logical vector with the asymptomatic status of the individuals. An
  asymptomatic individual being an individual clinically unaffected at
  this time but could later exhibit symptoms. (i.e. `FALSE` = not
  asymptomatic, `TRUE` = asymptomatic, `NA` = unknown).

- adopted:

  A logical vector with the adopted status of the individuals. (i.e.
  `FALSE` = not adopted, `TRUE` = adopted, `NA` = unknown).

- dateofbirth:

  A character vector with the date of birth of the individuals.

- dateofdeath:

  A character vector with the date of death of the individuals.

- rel_df:

  A data.frame with the special relationships between individuals. See
  [`Rel()`](https://louislenezet.github.io/Pedixplorer/reference/Rel-class.md)
  for more informations. The minimum columns required are `id1`, `id2`
  and `code`. The `famid` column can also be used to specify the family
  of the individuals. If a matrix is given, the columns needs to be
  ordered as `id1`, `id2`, `code` and `famid`. The code values are:

  - `1` = Monozygotic twin

  - `2` = Dizygotic twin

  - `3` = twin of unknown zygosity

  - `4` = Spouse

  The value relation code recognized by the function are the one defined
  by the
  [`rel_code_to_factor()`](https://louislenezet.github.io/Pedixplorer/reference/rel_code_to_factor.md)
  function.

- missid:

  A character vector with the missing values identifiers. All the id,
  dadid and momid corresponding to those values will be set to
  `NA_character_`.

- col_aff:

  A character vector with the name of the column to be used for the
  affection status.

- date_pattern:

  The pattern of the date

- normalize:

  A logical to know if the data should be normalised.

- cols_ren_ped:

  A named list with the columns to rename for the pedigree dataframe.
  This is useful if you want to use a dataframe with different column
  names. The names of the list should be the new column names and the
  values should be the old column names. The default values are to be
  used with `normalize = TRUE`.

- cols_ren_rel:

  A named list with the columns to rename for the relationship matrix.
  This is useful if you want to use a dataframe with different column
  names. The names of the list should be the new column names and the
  values should be the old column names.

- hints:

  A Hints object or a named list containing `horder` and `spouse`.

- na_strings:

  Vector of strings to be considered as NA values.

## Value

A Pedigree object.

## Details

If the normalization is set to `TRUE`, then the data will be
standardized using the function
[`norm_ped()`](https://louislenezet.github.io/Pedixplorer/reference/norm_ped.md)
and
[`norm_rel()`](https://louislenezet.github.io/Pedixplorer/reference/norm_rel.md).

If a data.frame is given, the columns names needed are as follow:

- `id`: the individual identifier

- `dadid`: the identifier of the biological father

- `momid`: the identifier of the biological mother

- `famid`: the family identifier of the individual

- `sex`: the sex of the individual

- `fertility`: the fertility status of the individual

- `miscarriage`: the miscarriage status of the individual

- `deceased`: the death status of the individual

- `avail`: the availability status of the individual

- `evaluated`: the evaluation status of the individual

- `consultand`: the consultand status of the individual

- `proband`: the proband status of the individual

- `affection`: the affection status of the individual

- `carrier`: the carrier status of the individual

- `asymptomatic`: the asymptomatic status of the individual

- `adopted`: the adopted status of the individual

- `dateofbirth`: the date of birth of the individual

- `dateofdeath`: the date of death of the individual

- `...`: other columns that will be stored in the `elementMetadata` slot

The minimum columns required are :

- `id`

- `dadid`

- `momid`

- `sex`

The `famid` column can also be used to specify the family of the
individuals and will be merge to the `id` field separated by an
underscore.

The columns `deceased`, `avail`, `evaluated`, `consultand`, `proband`,
`carrier`, `asymptomatic`, `adopted` will be transformed with the
[`vect_to_binary()`](https://louislenezet.github.io/Pedixplorer/reference/vect_to_binary.md)
function when the normalisation is selected.

The `fertility` column will be transformed with the
[`fertility_to_factor()`](https://louislenezet.github.io/Pedixplorer/reference/fertility_to_factor.md)
function.

The `miscarriage` column will be transformed with the
[`miscarriage_to_factor()`](https://louislenezet.github.io/Pedixplorer/reference/miscarriage_to_factor.md)
function.

The `dateofbirth` and `dateofdeath` columns will be transformed with the
[`char_to_date()`](https://louislenezet.github.io/Pedixplorer/reference/char_to_date.md)
function.

If `affections` is a data.frame, **col_aff** will be overwritten by the
column names of the data.frame.

## Slots

- `ped`:

  A Ped object for the identity informations. See
  [`Ped()`](https://louislenezet.github.io/Pedixplorer/reference/Ped-class.md)
  for more informations.

- `rel`:

  A Rel object for the special relationships. See
  [`Rel()`](https://louislenezet.github.io/Pedixplorer/reference/Rel-class.md)
  for more informations.

- `scales`:

  A Scales object for the filling and bordering colors used in the plot.
  See
  [`Scales()`](https://louislenezet.github.io/Pedixplorer/reference/Scales-class.md)
  for more informations.

- `hints`:

  A Hints object for the ordering of the individuals in the plot. See
  [`Hints()`](https://louislenezet.github.io/Pedixplorer/reference/Hints-class.md)
  for more informations.

## Accessors

- `ped(x, slot)` : Get the value of a specific slot of the Ped object

&nbsp;

- `ped(x)` : Get the Ped object

&nbsp;

- `ped(x, slot) <- value` : Set the value of a specific slot of the Ped
  object Wrapper of `slot(ped(x)) <- value`

&nbsp;

- `ped(x) <- value` : Set the Ped object

&nbsp;

- `mcols(x)` : Get the metadata of a Pedigree object. This function is a
  wrapper around `mcols(ped(x))`.

&nbsp;

- `mcols(x) <- value` : Set the metadata of a Pedigree object. This
  function is a wrapper around `mcols(ped(x)) <- value`.

&nbsp;

- `rel(x, slot)` : Get the value of a specific slot of the Rel object

&nbsp;

- `rel(x)` : Get the Rel object

&nbsp;

- `rel(x, slot) <- value` : Set the value of a specific slot of the Rel
  object Wrapper of `slot(rel(x)) <- value`

&nbsp;

- `rel(x) <- value` : Set the Rel object

&nbsp;

- `scales(x)` : Get the Scales object

&nbsp;

- `scales(x) <- value` : Set the Scales object

&nbsp;

- `fill(x)` : Get the fill data.frame from the Scales object. Wrapper of
  `fill(scales(x))`

&nbsp;

- `fill(x) <- value` : Set the fill data.frame from the Scales object.
  Wrapper of `fill(scales(x)) <- value`

&nbsp;

- `border(x)` : Get the border data.frame from the Scales object.
  Wrapper of `border(scales(x))`

&nbsp;

- `border(x) <- value` : Set the border data.frame from the Scales
  object. Wrapper of `border(scales(x)) <- value`

&nbsp;

- `hints(x)` : Get the Hints object

&nbsp;

- `hints(x) <- value` : Set the Hints object

&nbsp;

- `horder(x)` : Get the horder vector from the Hints object. Wrapper of
  `horder(hints(x))`

&nbsp;

- `horder(x) <- value` : Set the horder vector from the Hints object.
  Wrapper of `horder(hints(x)) <- value`

&nbsp;

- `spouse(x)` : Get the spouse data.frame from the Hints object. Wrapper
  of `spouse(hints(x))`.

&nbsp;

- `spouse(x) <- value` : Set the spouse data.frame from the Hints
  object. Wrapper of `spouse(hints(x)) <- value`.

## Generics

- `length(x)`: Get the length of a Pedigree object. Wrapper of
  `length(ped(x))`.

&nbsp;

- `show(x)`: Print the information of the Ped and Rel object inside the
  Pedigree object.

&nbsp;

- `summary(x)`: Compute the summary of the Ped and Rel object inside the
  Pedigree object.

&nbsp;

- `as.list(x)`: Convert a Pedigree object to a list

&nbsp;

- `subset(x, i, keep = TRUE)`: Subset a Pedigree object based on the
  individuals identifiers given.

  - `i` : A vector of individuals identifiers to keep.

  - `del_parents` : A logical value indicating if the parents of the
    individuals should be deleted.

  - `keep` : A logical value indicating if the individuals should be
    kept or deleted.

&nbsp;

- `x[i, del_parents, keep]`: Subset a Pedigree object based on the
  individuals identifiers given.

## See also

`Pedigree()`
[`Ped()`](https://louislenezet.github.io/Pedixplorer/reference/Ped-class.md)
[`Rel()`](https://louislenezet.github.io/Pedixplorer/reference/Rel-class.md)
[`Scales()`](https://louislenezet.github.io/Pedixplorer/reference/Scales-class.md)
[`Hints()`](https://louislenezet.github.io/Pedixplorer/reference/Hints-class.md)

[`Ped()`](https://louislenezet.github.io/Pedixplorer/reference/Ped-class.md)
[`Rel()`](https://louislenezet.github.io/Pedixplorer/reference/Rel-class.md)
[`Scales()`](https://louislenezet.github.io/Pedixplorer/reference/Scales-class.md)

## Examples

``` r
Pedigree(
    obj = c("1", "2", "3", "4", "5", "6"),
    dadid = c("4", "4", "6", "0", "0", "0"),
    momid = c("5", "5", "5", "0", "0", "0"),
    sex = c(1, 2, 3, 1, 2, 1),
    avail = c(0, 1, 0, 1, 0, 1),
    affections = matrix(c(
        0, 1, 0, 1, 0, 1,
        1, 1, 1, 1, 1, 1
    ), ncol = 2),
    col_aff = c("aff1", "aff2"),
    missid = "0",
    rel_df = matrix(c(
        "1", "2", 2
    ), ncol = 3, byrow = TRUE),
)
#> Pedigree object with: 
#> Ped object with 6 individuals and 6 metadata columns:
#>                    id       dadid       momid       famid       sex fertility
#> col_class <character> <character> <character> <character> <ordered>  <factor>
#> 1                   1           4           5        <NA>      male   fertile
#> 2                   2           4           5        <NA>    female   fertile
#> 3                   3           6           5        <NA>   unknown   fertile
#> 4                   4        <NA>        <NA>        <NA>      male   fertile
#> 5                   5        <NA>        <NA>        <NA>    female   fertile
#> 6                   6        <NA>        <NA>        <NA>      male   fertile
#>           miscarriage  deceased     avail evaluated consultand   proband
#> col_class    <factor> <logical> <logical> <logical>  <logical> <logical>
#> 1               FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 2               FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#> 3               FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 4               FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#> 5               FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 6               FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#>            affected   carrier asymptomatic   adopted dateofbirth dateofdeath
#> col_class <logical> <logical>    <logical> <logical> <character> <character>
#> 1              TRUE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 2              TRUE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 3              TRUE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 4              TRUE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 5              TRUE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 6              TRUE      <NA>         <NA>     FALSE        <NA>        <NA>
#>              useful       kin     isinf num_child_tot num_child_dir
#> col_class <logical> <numeric> <logical>     <numeric>     <numeric>
#> 1              <NA>      <NA>      <NA>             0             0
#> 2              <NA>      <NA>      <NA>             0             0
#> 3              <NA>      <NA>      <NA>             0             0
#> 4              <NA>      <NA>      <NA>             3             2
#> 5              <NA>      <NA>      <NA>             3             3
#> 6              <NA>      <NA>      <NA>             3             1
#>           num_child_ind |          V1          V2       error     V1_mods
#> col_class     <numeric>   <character> <character> <character> <character>
#> 1                     0             0           1        <NA>           0
#> 2                     0             1           1        <NA>           1
#> 3                     0             0           1        <NA>           0
#> 4                     1             1           1        <NA>           1
#> 5                     0             0           1        <NA>           0
#> 6                     2             1           1        <NA>           1
#>            avail_mods     V2_mods
#> col_class <character> <character>
#> 1                   0           1
#> 2                   1           1
#> 3                   0           1
#> 4                   1           1
#> 5                   0           1
#> 6                   1           1
#> Rel object with 1 relationshipwith 0 MZ twin, 1 DZ twin, 0 UZ twin, 0 Spouse:
#>           id1         id2                     code       famid     group
#>   <character> <character> <c("ordered", "factor")> <character> <numeric>
#> 1           1           2                  DZ twin        <NA>         1

data(sampleped)
Pedigree(sampleped)
#> Pedigree object with: 
#> Ped object with 55 individuals and 5 metadata columns:
#>                    id       dadid       momid       famid       sex fertility
#> col_class <character> <character> <character> <character> <ordered>  <factor>
#> 1_101           1_101        <NA>        <NA>           1      male   fertile
#> 1_102           1_102        <NA>        <NA>           1    female   fertile
#> 1_103           1_103       1_135       1_136           1      male   fertile
#> 1_104           1_104        <NA>        <NA>           1    female   fertile
#> 1_105           1_105        <NA>        <NA>           1      male   fertile
#> ...               ...         ...         ...         ...       ...       ...
#> 2_210           2_210       2_203       2_204           2      male   fertile
#> 2_211           2_211       2_203       2_204           2      male   fertile
#> 2_212           2_212       2_209       2_208           2    female   fertile
#> 2_213           2_213       2_209       2_208           2      male   fertile
#> 2_214           2_214       2_209       2_208           2      male   fertile
#>           miscarriage  deceased     avail evaluated consultand   proband
#> col_class    <factor> <logical> <logical> <logical>  <logical> <logical>
#> 1_101           FALSE      <NA>     FALSE      TRUE      FALSE     FALSE
#> 1_102           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_103           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_104           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_105           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> ...               ...       ...       ...       ...        ...       ...
#> 2_210           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 2_211           FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#> 2_212           FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#> 2_213           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 2_214           FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#>            affected   carrier asymptomatic   adopted dateofbirth dateofdeath
#> col_class <logical> <logical>    <logical> <logical> <character> <character>
#> 1_101         FALSE      <NA>         <NA>     FALSE  1968-01-22        <NA>
#> 1_102          TRUE      <NA>         <NA>     FALSE  1975-06-27        <NA>
#> 1_103          TRUE      <NA>         <NA>     FALSE  1975-08-14        <NA>
#> 1_104         FALSE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 1_105          <NA>      <NA>         <NA>     FALSE        <NA>        <NA>
#> ...             ...       ...          ...       ...         ...         ...
#> 2_210         FALSE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 2_211         FALSE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 2_212         FALSE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 2_213         FALSE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 2_214          TRUE      <NA>         <NA>     FALSE        <NA>        <NA>
#>              useful       kin     isinf num_child_tot num_child_dir
#> col_class <logical> <numeric> <logical>     <numeric>     <numeric>
#> 1_101          <NA>      <NA>      <NA>             1             1
#> 1_102          <NA>      <NA>      <NA>             1             1
#> 1_103          <NA>      <NA>      <NA>             4             4
#> 1_104          <NA>      <NA>      <NA>             4             4
#> 1_105          <NA>      <NA>      <NA>             4             4
#> ...             ...       ...       ...           ...           ...
#> 2_210          <NA>      <NA>      <NA>             0             0
#> 2_211          <NA>      <NA>      <NA>             0             0
#> 2_212          <NA>      <NA>      <NA>             0             0
#> 2_213          <NA>      <NA>      <NA>             0             0
#> 2_214          <NA>      <NA>      <NA>             0             0
#>           num_child_ind |   affection         num       error affection_mods
#> col_class     <numeric>   <character> <character> <character>    <character>
#> 1_101                 0             0           2        <NA>              0
#> 1_102                 0             1           3        <NA>              1
#> 1_103                 0             1           2        <NA>              1
#> 1_104                 0             0           4        <NA>              0
#> 1_105                 0          <NA>           6        <NA>             NA
#> ...                 ...           ...         ...         ...            ...
#> 2_210                 0             0           2        <NA>              0
#> 2_211                 0             0           1        <NA>              0
#> 2_212                 0             0           3        <NA>              0
#> 2_213                 0             0           2        <NA>              0
#> 2_214                 0             1           0        <NA>              1
#>            avail_mods
#> col_class <character>
#> 1_101               0
#> 1_102               0
#> 1_103               0
#> 1_104               0
#> 1_105               0
#> ...               ...
#> 2_210               0
#> 2_211               1
#> 2_212               1
#> 2_213               0
#> 2_214               1
#> Rel object with 0 relationshipswith 0 MZ twin, 0 DZ twin, 0 UZ twin, 0 Spouse:
#>          id1         id2                     code       famid     group
#>  <character> <character> <c("ordered", "factor")> <character> <numeric>
```
