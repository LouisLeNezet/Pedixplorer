# Usefulness of individuals

Compute the usefulness of individuals

## Usage

``` r
# S4 method for class 'character'
useful_inds(
  obj,
  dadid,
  momid,
  avail,
  affected,
  num_child_tot,
  id_inf,
  keep_infos = FALSE
)

# S4 method for class 'Pedigree'
useful_inds(obj, keep_infos = FALSE, reset = FALSE, max_dist = NULL)

# S4 method for class 'Ped'
useful_inds(obj, keep_infos = FALSE, reset = FALSE, max_dist = NULL)
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

- avail:

  A logical vector with the availability status of the individuals (i.e.
  `FALSE` = not available, `TRUE` = available, `NA` = unknown).

- affected:

  A logical vector with the affection status of the individuals (i.e.
  `FALSE` = unaffected, `TRUE` = affected, `NA` = unknown).

- num_child_tot:

  A numeric vector of the number of children of each individuals

- id_inf:

  An identifiers vector of informative individuals.

- keep_infos:

  Boolean to indicate if parents with unknown status but available or
  reverse should be kept

- reset:

  Boolean to indicate if the `useful` column should be reset

- max_dist:

  The maximum distance to informative individuals

## Value

### When obj is a vector

A vector of useful individuals identifiers

### When obj is a Pedigree or Ped object

The Pedigree or Ped object with the slot 'useful' containing `TRUE` for
useful individuals and `FALSE` otherwise.

## Details

Check for the informativeness of the individuals based on the
informative parameter given, the number of children and the usefulness
of their parents. A `useful` slot is added to the Ped object with the
usefulness of the individual.

## Examples

``` r
data(sampleped)
ped1 <- Pedigree(sampleped[sampleped$famid == "1",])
ped1 <- is_informative(ped1, informative = "AvAf", col_aff = "affection")
ped(useful_inds(ped1))
#> Ped object with 41 individuals and 5 metadata columns:
#>                    id       dadid       momid       famid       sex fertility
#> col_class <character> <character> <character> <character> <ordered>  <factor>
#> 1_101           1_101        <NA>        <NA>           1      male   fertile
#> 1_102           1_102        <NA>        <NA>           1    female   fertile
#> 1_103           1_103       1_135       1_136           1      male   fertile
#> 1_104           1_104        <NA>        <NA>           1    female   fertile
#> 1_105           1_105        <NA>        <NA>           1      male   fertile
#> ...               ...         ...         ...         ...       ...       ...
#> 1_137           1_137        <NA>        <NA>           1      male   fertile
#> 1_138           1_138       1_135       1_136           1    female   fertile
#> 1_139           1_139       1_137       1_138           1    female   fertile
#> 1_140           1_140       1_137       1_138           1    female   fertile
#> 1_141           1_141       1_137       1_138           1    female   fertile
#>           miscarriage  deceased     avail evaluated consultand   proband
#> col_class    <factor> <logical> <logical> <logical>  <logical> <logical>
#> 1_101           FALSE      <NA>     FALSE      TRUE      FALSE     FALSE
#> 1_102           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_103           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_104           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_105           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> ...               ...       ...       ...       ...        ...       ...
#> 1_137           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_138           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_139           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_140           FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#> 1_141           FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#>            affected   carrier asymptomatic   adopted dateofbirth dateofdeath
#> col_class <logical> <logical>    <logical> <logical> <character> <character>
#> 1_101          <NA>      <NA>         <NA>     FALSE  1968-01-22        <NA>
#> 1_102          <NA>      <NA>         <NA>     FALSE  1975-06-27        <NA>
#> 1_103          <NA>      <NA>         <NA>     FALSE  1975-08-14        <NA>
#> 1_104          <NA>      <NA>         <NA>     FALSE        <NA>        <NA>
#> 1_105          <NA>      <NA>         <NA>     FALSE        <NA>        <NA>
#> ...             ...       ...          ...       ...         ...         ...
#> 1_137          <NA>      <NA>         <NA>     FALSE        <NA>        <NA>
#> 1_138          <NA>      <NA>         <NA>     FALSE        <NA>        <NA>
#> 1_139          <NA>      <NA>         <NA>     FALSE        <NA>        <NA>
#> 1_140          <NA>      TRUE         <NA>     FALSE        <NA>        <NA>
#> 1_141          <NA>      <NA>         TRUE     FALSE        <NA>        <NA>
#>              useful       kin     isinf num_child_tot num_child_dir
#> col_class <logical> <numeric> <logical>     <numeric>     <numeric>
#> 1_101          TRUE         3     FALSE             1             1
#> 1_102          TRUE         3     FALSE             1             1
#> 1_103          TRUE         2     FALSE             4             4
#> 1_104          TRUE         2     FALSE             4             4
#> 1_105          TRUE         2     FALSE             4             4
#> ...             ...       ...       ...           ...           ...
#> 1_137          TRUE       Inf     FALSE             3             3
#> 1_138          TRUE         3     FALSE             3             3
#> 1_139          TRUE         4     FALSE             0             0
#> 1_140          TRUE         4     FALSE             0             0
#> 1_141          TRUE         4     FALSE             0             0
#>           num_child_ind |   affection         num       error affection_mods
#> col_class     <numeric>   <character> <character> <character>    <character>
#> 1_101                 0             0           2        <NA>              0
#> 1_102                 0             1           3        <NA>              1
#> 1_103                 0             1           2        <NA>              1
#> 1_104                 0             0           4        <NA>              0
#> 1_105                 0          <NA>           6        <NA>             NA
#> ...                 ...           ...         ...         ...            ...
#> 1_137                 0          <NA>           3        <NA>             NA
#> 1_138                 0          <NA>           2        <NA>             NA
#> 1_139                 0             1           3        <NA>              1
#> 1_140                 0             0           1        <NA>              0
#> 1_141                 0             0           0        <NA>              0
#>            avail_mods
#> col_class <character>
#> 1_101               0
#> 1_102               0
#> 1_103               0
#> 1_104               0
#> 1_105               0
#> ...               ...
#> 1_137               0
#> 1_138               0
#> 1_139               0
#> 1_140               1
#> 1_141               1
```
