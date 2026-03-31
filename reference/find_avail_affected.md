# Find single affected and available individual from a Pedigree

Finds one subject from among available non-parents with indicated
affection status.

## Usage

``` r
# S4 method for class 'Ped'
find_avail_affected(obj, avail = NULL, affected = NULL, affstatus = NA)

# S4 method for class 'Pedigree'
find_avail_affected(obj, avail = NULL, affected = NULL, affstatus = NA)
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

- affstatus:

  Affection status to search for.

## Value

A list is returned with the following components

- ped The new Ped object

- newAvail Vector of availability status of trimmed individuals

- idTrimmed Vector of IDs of trimmed individuals

- isTrimmed logical value indicating whether Ped object has been trimmed

- bit_size Bit size of the trimmed Ped

## Details

When used within
[`shrink()`](https://louislenezet.github.io/Pedixplorer/reference/shrink.md),
this function is called with the first affected indicator, if the
affected item in the Pedigree is a matrix of multiple affected
indicators.

If **avail** or **affected** is null, then the function will use the
corresponding Ped accessor.

## See also

[`shrink()`](https://louislenezet.github.io/Pedixplorer/reference/shrink.md)

## Examples

``` r
data(sampleped)
pedi <- Pedigree(sampleped)
find_avail_affected(pedi, affstatus = 1)
#> $ped
#> Ped object with 38 individuals and 5 metadata columns:
#>                    id       dadid       momid       famid       sex fertility
#> col_class <character> <character> <character> <character> <ordered>  <factor>
#> 1_103           1_103       1_135       1_136           1      male   fertile
#> 1_104           1_104        <NA>        <NA>           1    female   fertile
#> 1_105           1_105        <NA>        <NA>           1      male   fertile
#> 1_106           1_106        <NA>        <NA>           1    female   fertile
#> 1_109           1_109        <NA>        <NA>           1    female   fertile
#> ...               ...         ...         ...         ...       ...       ...
#> 2_208           2_208       2_201       2_202           2    female   fertile
#> 2_209           2_209        <NA>        <NA>           2      male   fertile
#> 2_211           2_211       2_203       2_204           2      male   fertile
#> 2_212           2_212       2_209       2_208           2    female   fertile
#> 2_214           2_214       2_209       2_208           2      male   fertile
#>           miscarriage  deceased     avail evaluated consultand   proband
#> col_class    <factor> <logical> <logical> <logical>  <logical> <logical>
#> 1_103           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_104           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_105           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_106           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_109           FALSE      <NA>      TRUE     FALSE       TRUE     FALSE
#> ...               ...       ...       ...       ...        ...       ...
#> 2_208           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 2_209           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 2_211           FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#> 2_212           FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#> 2_214           FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#>            affected   carrier asymptomatic   adopted dateofbirth dateofdeath
#> col_class <logical> <logical>    <logical> <logical> <character> <character>
#> 1_103          TRUE      <NA>         <NA>     FALSE  1975-08-14        <NA>
#> 1_104         FALSE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 1_105          <NA>      <NA>         <NA>     FALSE        <NA>        <NA>
#> 1_106          <NA>      <NA>         <NA>     FALSE        <NA>        <NA>
#> 1_109         FALSE      <NA>         TRUE     FALSE        <NA>        <NA>
#> ...             ...       ...          ...       ...         ...         ...
#> 2_208         FALSE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 2_209         FALSE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 2_211         FALSE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 2_212         FALSE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 2_214          TRUE      <NA>         <NA>     FALSE        <NA>        <NA>
#>              useful       kin     isinf num_child_tot num_child_dir
#> col_class <logical> <numeric> <logical>     <numeric>     <numeric>
#> 1_103          <NA>      <NA>      <NA>             3             3
#> 1_104          <NA>      <NA>      <NA>             3             3
#> 1_105          <NA>      <NA>      <NA>             4             4
#> 1_106          <NA>      <NA>      <NA>             4             4
#> 1_109          <NA>      <NA>      <NA>             0             0
#> ...             ...       ...       ...           ...           ...
#> 2_208          <NA>      <NA>      <NA>             2             2
#> 2_209          <NA>      <NA>      <NA>             2             2
#> 2_211          <NA>      <NA>      <NA>             0             0
#> 2_212          <NA>      <NA>      <NA>             0             0
#> 2_214          <NA>      <NA>      <NA>             0             0
#>           num_child_ind |   affection         num       error affection_mods
#> col_class     <numeric>   <character> <character> <character>    <character>
#> 1_103                 0             1           2        <NA>              1
#> 1_104                 0             0           4        <NA>              0
#> 1_105                 0          <NA>           6        <NA>             NA
#> 1_106                 0          <NA>           1        <NA>             NA
#> 1_109                 0             0           3        <NA>              0
#> ...                 ...           ...         ...         ...            ...
#> 2_208                 0             0           1        <NA>              0
#> 2_209                 0             0           2        <NA>              0
#> 2_211                 0             0           1        <NA>              0
#> 2_212                 0             0           3        <NA>              0
#> 2_214                 0             1           0        <NA>              1
#>            avail_mods
#> col_class <character>
#> 1_103               0
#> 1_104               0
#> 1_105               0
#> 1_106               0
#> 1_109               1
#> ...               ...
#> 2_208               0
#> 2_209               0
#> 2_211               1
#> 2_212               1
#> 2_214               1
#> 
#> $new_avail
#>  [1] FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE  TRUE FALSE  TRUE
#> [13]  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE
#> [25] FALSE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE
#> [37]  TRUE  TRUE
#> 
#> $id_trimmed
#> [1] "1_124"
#> 
#> $is_trimmed
#> [1] TRUE
#> 
#> $bit_size
#> [1] 37
#> 
```
