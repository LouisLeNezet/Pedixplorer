# Update family prefix in individuals id

Update the family prefix in the individuals identifiers. Individuals
identifiers are constructed as follow **famid**\_**id**. Therefore to
update their family prefix the ids are split by the first underscore and
the first part is overwritten by **famid**.

## Usage

``` r
# S4 method for class 'character,ANY'
upd_famid(obj, famid, missid = NA_character_)

# S4 method for class 'Ped,character_OR_integer'
upd_famid(obj, famid)

# S4 method for class 'Ped,missing'
upd_famid(obj)

# S4 method for class 'Rel,character_OR_integer'
upd_famid(obj, famid)

# S4 method for class 'Rel,missing'
upd_famid(obj)

# S4 method for class 'Pedigree,character_OR_integer'
upd_famid(obj, famid)

# S4 method for class 'Pedigree,missing'
upd_famid(obj)
```

## Arguments

- obj:

  Ped or Pedigree object or a character vector of individual ids

- famid:

  A character vector with the family identifiers of the individuals. If
  provide, will be aggregated to the individuals identifiers separated
  by an underscore.

- missid:

  A character vector with the missing values identifiers. All the id,
  dadid and momid corresponding to those values will be set to
  `NA_character_`.

## Value

A character vector of individual ids with family prefix updated

## Details

If famid is *missing*, then the
[`famid()`](https://louislenezet.github.io/Pedixplorer/reference/Ped-class.md)
function will be called on the object.

## Examples

``` r
upd_famid(c("1", "2", "B_3"), c("A", "B", "A"))
#> [1] "A_1" "B_2" "A_3"
upd_famid(c("1", "B_2", "C_3", "4"), c("A", NA, "A", NA))
#> [1] "A_1" "2"   "A_3" "4"  

data(sampleped)
ped1 <- Pedigree(sampleped[,-1])
id(ped(ped1))
#>  [1] "101" "102" "103" "104" "105" "106" "107" "108" "109" "110" "111" "112"
#> [13] "113" "114" "115" "116" "117" "118" "119" "120" "121" "122" "123" "124"
#> [25] "125" "126" "127" "128" "129" "130" "131" "132" "133" "134" "135" "136"
#> [37] "137" "138" "139" "140" "141" "201" "202" "203" "204" "205" "206" "207"
#> [49] "208" "209" "210" "211" "212" "213" "214"
new_fam <- make_famid(id(ped(ped1)), dadid(ped(ped1)), momid(ped(ped1)))
id(ped(upd_famid(ped1, new_fam)))
#>  [1] "1_101" "1_102" "1_103" "1_104" "1_105" "1_106" "1_107" "1_108" "1_109"
#> [10] "1_110" "1_111" "1_112" "113"   "1_114" "1_115" "1_116" "1_117" "1_118"
#> [19] "1_119" "1_120" "1_121" "1_122" "1_123" "1_124" "1_125" "1_126" "1_127"
#> [28] "1_128" "1_129" "1_130" "1_131" "1_132" "1_133" "1_134" "1_135" "1_136"
#> [37] "1_137" "1_138" "1_139" "1_140" "1_141" "2_201" "2_202" "2_203" "2_204"
#> [46] "2_205" "2_206" "2_207" "2_208" "2_209" "2_210" "2_211" "2_212" "2_213"
#> [55] "2_214"

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
