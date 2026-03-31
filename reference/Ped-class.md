# Ped object

S4 class to represent the identity informations of the individuals in a
pedigree.

### Constructor :

You either need to provide a vector of the same size for each slot or a
`data.frame` with the corresponding columns.

The metadata will correspond to the columns that do not correspond to
the Ped slots.

## Usage

``` r
# S4 method for class 'data.frame'
Ped(
  obj,
  cols_used_init = FALSE,
  cols_used_del = FALSE,
  date_pattern = "%Y-%m-%d"
)

# S4 method for class 'character_OR_integer'
Ped(
  obj,
  dadid,
  momid,
  sex,
  famid = NA,
  fertility = NA,
  miscarriage = NA,
  deceased = NA,
  avail = NA,
  evaluated = NA,
  consultand = NA,
  proband = NA,
  affected = NA,
  carrier = NA,
  asymptomatic = NA,
  adopted = NA,
  dateofbirth = NA,
  dateofdeath = NA,
  missid = c(NA_character_, "0"),
  useful = NA,
  isinf = NA,
  kin = NA_real_
)
```

## Arguments

- obj:

  A character vector with the id of the individuals or a `data.frame`
  with all the informations in corresponding columns.

- cols_used_init:

  Boolean defining if the columns that will be used should be
  initialised to NA.

- cols_used_del:

  Boolean defining if the columns that will be used should be deleted.

- date_pattern:

  The pattern of the date

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

- affected:

  A logical vector with the affection status of the individuals (i.e.
  `FALSE` = unaffected, `TRUE` = affected, `NA` = unknown).

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

- missid:

  A character vector with the missing values identifiers. All the id,
  dadid and momid corresponding to those values will be set to
  `NA_character_`.

- useful:

  A logical vector with the usefulness status of the individuals (i.e.
  `FALSE` = not useful, `TRUE` = useful).

- isinf:

  A logical vector indicating if the individual is informative or not
  (i.e. `FALSE` = not informative, `TRUE` = informative).

- kin:

  A numeric vector with minimal kinship value between the individuals
  and the informative individuals.

## Value

A Ped object.

## Details

The minimal needed informations are `id`, `dadid`, `momid` and `sex`.
The other slots are used to store recognized informations. Additional
columns can be added to the Ped object and will be stored in the
`elementMetadata` slot of the Ped object.

## Slots

- `id`:

  A character vector with the id of the individuals.

- `dadid`:

  A character vector with the id of the father of the individuals.

- `momid`:

  A character vector with the id of the mother of the individuals.

- `famid`:

  A character vector with the family identifiers of the individuals
  (optional).

- `sex`:

  An ordered factor vector for the sex of the individuals (i.e. `male`
  \< `female` \< `unknown`).

- `fertility`:

  A factor vector with the fertility status of the individuals
  (optional). (i.e. `infertile_choice_na` = no children by choice or
  unknown reason, `infertile` = individual is inferile, `fertile` =
  individual is fertile).

- `miscarriage`:

  A factor vector with the miscarriage status of the individuals
  (optional). (i.e. `TOP` = Termination of Pregnancy, `SAB` =
  Spontaneous Abortion, `ECT` = Ectopic Pregnancy, `FALSE` = no
  miscarriage).

- `deceased`:

  A logical vector with the death status of the individuals (optional).
  (i.e. `FALSE` = alive, `TRUE` = dead, `NA` = unknown).

- `avail`:

  A logical vector with the availability status of the individuals
  (optional). (i.e. `FALSE` = not available, `TRUE` = available, `NA` =
  unknown).

- `evaluated`:

  A logical vector with the evaluation status of the individuals
  (optional). (i.e. `FALSE` = documented evaluation not available,
  `TRUE` = documented evaluation available).

- `consultand`:

  A logical vector with the consultand status of the individuals
  (optional). A consultand being an individual seeking genetic
  counseling/testing (i.e. `FALSE` = not a consultand, `TRUE` =
  consultand).

- `proband`:

  A logical vector with the proband status of the individuals
  (optional). A proband being an affected family member coming to
  medical attention independent of other family members. (i.e. `FALSE` =
  not a proband, `TRUE` = proband).

- `affected`:

  A logical vector with the affection status of the individuals
  (optional). (i.e. `FALSE` = not affected, `TRUE` = affected, `NA` =
  unknown).

- `carrier`:

  A logical vector with the carrier status of the individuals
  (optional). A carrier being an individual who has the genetic trait
  but who is not likely to manifest the disease regardless of
  inheritance pattern (i.e. `FALSE` = not carrier, `TRUE` = carrier,
  `NA` = unknown).

- `asymptomatic`:

  A logical vector with the asymptomatic status of the individuals
  (optional). An asymptomatic individual being an individual clinically
  unaffected at this time but could later exhibit symptoms. (i.e.
  `FALSE` = not asymptomatic, `TRUE` = asymptomatic, `NA` = unknown).

- `adopted`:

  A logical vector with the adopted status of the individuals
  (optional). (i.e. `FALSE` = not adopted, `TRUE` = adopted, `NA` =
  unknown).

- `dateofbirth`:

  A date vector with the birth date of the individuals (optional).

- `dateofdeath`:

  A date vector with the death date of the individuals (optional).

- `useful`:

  A logical vector with the usefulness status of the individuals
  (computed). (i.e. `FALSE` = not useful, `TRUE` = useful).

- `isinf`:

  A logical vector indicating if the individual is informative or not
  (computed). (i.e. `FALSE` = not informative, `TRUE` = informative).

- `kin`:

  A numeric vector with minimal kinship value between the individuals
  and the useful individuals (computed).

- `num_child_tot`:

  A numeric vector with the total number of children of the individuals
  (computed).

- `num_child_dir`:

  A numeric vector with the number of children of the individuals
  (computed).

- `num_child_ind`:

  A numeric vector with the number of children of the individuals
  (computed).

- `elementMetadata`:

  A DataFrame with the additional metadata columns of the Ped object.

- `metadata`:

  Meta informations about the pedigree.

## Accessors

For all the following accessors, the `x` parameters is a Ped object.
Each getters return a vector of the same length as `x` with the values
of the corresponding slot. For each getter, you have a setter with the
same name, to be use as `slot(x) <- value`. The `value` parameter is a
vector of the same length as `x`, except for the `mcols()` accessors
where `value` is a list or a data.frame with each elements with the same
length as `x`.

- `id(x)` : Individuals identifiers

&nbsp;

- `dadid(x)` : Individuals' father identifiers

&nbsp;

- `momid(x)` : Individuals' mother identifiers

&nbsp;

- `famid(x)` : Individuals' family identifiers

&nbsp;

- `sex(x)` : Individuals' gender

&nbsp;

- `fertility(x)` : Individuals' fertility status

&nbsp;

- `miscarriage(x)` : Individuals' miscarriage status

&nbsp;

- `deceased(x)` : Individuals' death status

&nbsp;

- `avail(x)` : Individuals' availability status

&nbsp;

- `evaluated(x)` : Individuals' evaluated status

&nbsp;

- `consultand(x)` : Individuals' consultand status

&nbsp;

- `proband(x)` : Individuals' proband status

&nbsp;

- `carrier(x)` : Individuals' carrier status

&nbsp;

- `asymptomatic(x)` : Individuals' asymptomatic status

&nbsp;

- `adopted(x)` : Individuals' adopted status

&nbsp;

- `affected(x)` : Individuals' affection status

&nbsp;

- `dateofbirth(x)` : Individuals' birth dates

&nbsp;

- `dateofdeath(x)` : Individuals' death dates

&nbsp;

- `isinf(x)` : Individuals' informativeness status

&nbsp;

- `kin(x)` : Individuals' kinship distance to the informative
  individuals

&nbsp;

- `useful(x)` : Individuals' usefullness status

&nbsp;

- `mcols(x)` : Individuals' metadata

## Generics

- `summary(x)`: Compute the summary of a Ped object

&nbsp;

- `show(x)`: Convert the Ped object to a data.frame and print it with
  its summary.

&nbsp;

- `as.list(x)`: Convert a Ped object to a list with the metadata columns
  at the end.

&nbsp;

- `as.data.frame(x)`: Convert a Ped object to a data.frame with the
  metadata columns at the end.

&nbsp;

- `subset(x, i, del_parents = FALSE, keep = TRUE)`: Subset a Ped object
  based on the individuals identifiers given.

  - `i` : A vector of individuals identifiers to keep.

  - `del_parents` : A value indicating if the parents of the individuals
    should be deleted.

  - `keep` : A logical value indicating if the individuals should be
    kept or deleted.

## See also

[`Pedigree()`](https://louislenezet.github.io/Pedixplorer/reference/Pedigree-class.md)

## Examples

``` r
data(sampleped)
Ped(sampleped)
#> Ped object with 55 individuals and 2 metadata columns:
#>                    id       dadid       momid       famid       sex fertility
#> col_class <character> <character> <character> <character> <ordered>  <factor>
#> 101               101        <NA>        <NA>           1      male   fertile
#> 102               102        <NA>        <NA>           1    female   fertile
#> 103               103         135         136           1      male   fertile
#> 104               104        <NA>        <NA>           1    female   fertile
#> 105               105        <NA>        <NA>           1      male   fertile
#> ...               ...         ...         ...         ...       ...       ...
#> 210               210         203         204           2      male   fertile
#> 211               211         203         204           2      male   fertile
#> 212               212         209         208           2    female   fertile
#> 213               213         209         208           2      male   fertile
#> 214               214         209         208           2      male   fertile
#>           miscarriage  deceased     avail evaluated consultand   proband
#> col_class    <factor> <logical> <logical> <logical>  <logical> <logical>
#> 101             FALSE      <NA>     FALSE      TRUE      FALSE     FALSE
#> 102             FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 103             FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 104             FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 105             FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> ...               ...       ...       ...       ...        ...       ...
#> 210             FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 211             FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#> 212             FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#> 213             FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 214             FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#>            affected   carrier asymptomatic   adopted dateofbirth dateofdeath
#> col_class <logical> <logical>    <logical> <logical> <character> <character>
#> 101            <NA>      <NA>         <NA>      <NA>  1968-01-22        <NA>
#> 102            <NA>      <NA>         <NA>      <NA>  1975-06-27        <NA>
#> 103            <NA>      <NA>         <NA>      <NA>  1975-08-14        <NA>
#> 104            <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
#> 105            <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
#> ...             ...       ...          ...       ...         ...         ...
#> 210            <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
#> 211            <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
#> 212            <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
#> 213            <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
#> 214            <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
#>              useful       kin     isinf num_child_tot num_child_dir
#> col_class <logical> <numeric> <logical>     <numeric>     <numeric>
#> 101            <NA>      <NA>      <NA>             1             1
#> 102            <NA>      <NA>      <NA>             1             1
#> 103            <NA>      <NA>      <NA>             4             4
#> 104            <NA>      <NA>      <NA>             4             4
#> 105            <NA>      <NA>      <NA>             4             4
#> ...             ...       ...       ...           ...           ...
#> 210            <NA>      <NA>      <NA>             0             0
#> 211            <NA>      <NA>      <NA>             0             0
#> 212            <NA>      <NA>      <NA>             0             0
#> 213            <NA>      <NA>      <NA>             0             0
#> 214            <NA>      <NA>      <NA>             0             0
#>           num_child_ind |   affection         num
#> col_class     <numeric>   <character> <character>
#> 101                   0             0           2
#> 102                   0             1           3
#> 103                   0             1           2
#> 104                   0             0           4
#> 105                   0          <NA>           6
#> ...                 ...           ...         ...
#> 210                   0             0           2
#> 211                   0             0           1
#> 212                   0             0           3
#> 213                   0             0           2
#> 214                   0             1           0

Ped(
    obj = c("1", "2", "3", "4", "5", "6"),
    dadid = c("4", "4", "6", "0", "0", "0"),
    momid = c("5", "5", "5", "0", "0", "0"),
    sex = c(1, 2, 3, 1, 2, 1),
    missid = "0"
)
#> Ped object with 6 individuals and 0 metadata columns:
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
#> 1               FALSE      <NA>      <NA>     FALSE      FALSE     FALSE
#> 2               FALSE      <NA>      <NA>     FALSE      FALSE     FALSE
#> 3               FALSE      <NA>      <NA>     FALSE      FALSE     FALSE
#> 4               FALSE      <NA>      <NA>     FALSE      FALSE     FALSE
#> 5               FALSE      <NA>      <NA>     FALSE      FALSE     FALSE
#> 6               FALSE      <NA>      <NA>     FALSE      FALSE     FALSE
#>            affected   carrier asymptomatic   adopted dateofbirth dateofdeath
#> col_class <logical> <logical>    <logical> <logical> <character> <character>
#> 1              <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
#> 2              <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
#> 3              <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
#> 4              <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
#> 5              <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
#> 6              <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
#>              useful       kin     isinf num_child_tot num_child_dir
#> col_class <logical> <numeric> <logical>     <numeric>     <numeric>
#> 1              <NA>      <NA>      <NA>             0             0
#> 2              <NA>      <NA>      <NA>             0             0
#> 3              <NA>      <NA>      <NA>             0             0
#> 4              <NA>      <NA>      <NA>             3             2
#> 5              <NA>      <NA>      <NA>             3             3
#> 6              <NA>      <NA>      <NA>             3             1
#>           num_child_ind
#> col_class     <numeric>
#> 1                     0
#> 2                     0
#> 3                     0
#> 4                     1
#> 5                     0
#> 6                     2
```
