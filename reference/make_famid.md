# Compute family id

Construct a family identifier from pedigree information

## Usage

``` r
# S4 method for class 'character'
make_famid(obj, dadid, momid)

# S4 method for class 'Pedigree'
make_famid(obj)
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

## Value

### When used with a character vector

An integer vector giving family groupings

### When used with a Pedigree object

An updated Pedigree object with the family id added and with all ids
updated

## Details

Create a vector of length n, giving the family 'tree' number of each
subject. If the Pedigree is totally connected, then everyone will end up
in tree 1, otherwise the tree numbers represent the disconnected
subfamilies. Singleton subjects give a zero for family number.

## See also

[`kinship()`](https://louislenezet.github.io/Pedixplorer/reference/kinship.md)

## Examples

``` r
make_famid(
    c("A", "B", "C", "D", "E", "F"),
    c("C", "D", "0", "0", "0", "0"),
    c("E", "E", "0", "0", "0", "0")
)
#> [1] "1" "1" "1" "1" "1" NA 

data(sampleped)
ped1 <- Pedigree(sampleped[,-1])
make_famid(ped1)
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
