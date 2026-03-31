# Shrink Pedigree object

Shrink Pedigree object to specified bit size with priority placed on
trimming uninformative subjects. The algorithm is useful for getting a
Pedigree condensed to a minimally informative size for algorithms or
testing that are limited by size of the Pedigree.

If **avail** or **affected** are `NULL`, they are extracted with their
corresponding accessors from the Ped object.

## Usage

``` r
# S4 method for class 'Pedigree'
shrink(obj, avail = NULL, affected = NULL, max_bits = 16)

# S4 method for class 'Ped'
shrink(obj, avail = NULL, affected = NULL, max_bits = 16)
```

## Arguments

- obj:

  A Pedigree or Ped object.

- avail:

  A logical vector with the availability status of the individuals (i.e.
  `FALSE` = not available, `TRUE` = available, `NA` = unknown).

- affected:

  A logical vector with the affection status of the individuals (i.e.
  `FALSE` = unaffected, `TRUE` = affected, `NA` = unknown).

- max_bits:

  Optional, the bit size for which to shrink the Pedigree

## Value

A list containing the following elements:

- pedObj: Pedigree object after trimming

- id_trim: Vector of ids trimmed from Pedigree

- id_lst: List of ids trimmed by category

- bit_size: Vector of bit sizes after each trimming step

- avail: Vector of availability status after trimming

- pedSizeOriginal: Number of subjects in original Pedigree

- pedSizeIntermed: Number of subjects after initial trimming

- pedSizeFinal: Number of subjects after final trimming

## Details

Iteratively remove subjects from the Pedigree. The random removal of
members was previously controlled by a seed argument, but we remove
this, forcing users to control randomness outside the function. First
remove uninformative subjects, i.e., unavailable (not genotyped) with no
available descendants. Next, available terminal subjects with unknown
phenotype if both parents available. Last, iteratively shrinks Pedigrees
by preferentially removing individuals (chosen at random if there are
multiple of the same status):

1.  Subjects with unknown affected status

2.  Subjects with unaffected affected status

3.  Affected subjects.

## See also

[`Pedigree()`](https://louislenezet.github.io/Pedixplorer/reference/Pedigree-class.md),
[`bit_size()`](https://louislenezet.github.io/Pedixplorer/reference/bit_size.md)

## Author

Original by Dan Schaid, updated by Jason Sinnwell and Louis Le Nezet

## Examples

``` r
data(sampleped)
ped1 <- Pedigree(sampleped[sampleped$famid == '1',])
shrink(ped1, max_bits = 12)
#> $pedObj
#> Pedigree object with: 
#> Ped object with 13 individuals and 5 metadata columns:
#>                    id       dadid       momid       famid       sex fertility
#> col_class <character> <character> <character> <character> <ordered>  <factor>
#> 1_103           1_103        <NA>        <NA>           1      male   fertile
#> 1_104           1_104        <NA>        <NA>           1    female   fertile
#> 1_105           1_105        <NA>        <NA>           1      male   fertile
#> 1_106           1_106        <NA>        <NA>           1    female   fertile
#> 1_109           1_109        <NA>        <NA>           1    female   fertile
#> ...               ...         ...         ...         ...       ...       ...
#> 1_118           1_118       1_105       1_106           1    female   fertile
#> 1_119           1_119       1_105       1_106           1      male   fertile
#> 1_124           1_124       1_110       1_109           1      male   fertile
#> 1_127           1_127       1_114       1_115           1      male   fertile
#> 1_128           1_128       1_114       1_115           1      male   fertile
#>           miscarriage  deceased     avail evaluated consultand   proband
#> col_class    <factor> <logical> <logical> <logical>  <logical> <logical>
#> 1_103           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_104           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_105           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_106           FALSE      <NA>     FALSE     FALSE      FALSE     FALSE
#> 1_109           FALSE      <NA>      TRUE     FALSE       TRUE     FALSE
#> ...               ...       ...       ...       ...        ...       ...
#> 1_118           FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#> 1_119           FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#> 1_124           FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#> 1_127           FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#> 1_128           FALSE      <NA>      TRUE     FALSE      FALSE     FALSE
#>            affected   carrier asymptomatic   adopted dateofbirth dateofdeath
#> col_class <logical> <logical>    <logical> <logical> <character> <character>
#> 1_103          TRUE      <NA>         <NA>     FALSE  1975-08-14        <NA>
#> 1_104         FALSE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 1_105          <NA>      <NA>         <NA>     FALSE        <NA>        <NA>
#> 1_106          <NA>      <NA>         <NA>     FALSE        <NA>        <NA>
#> 1_109         FALSE      <NA>         TRUE     FALSE        <NA>        <NA>
#> ...             ...       ...          ...       ...         ...         ...
#> 1_118          TRUE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 1_119          TRUE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 1_124          TRUE      <NA>         <NA>     FALSE  2006-07-28        <NA>
#> 1_127          TRUE      <NA>         <NA>     FALSE        <NA>        <NA>
#> 1_128          TRUE      <NA>         <NA>     FALSE        <NA>        <NA>
#>              useful       kin     isinf num_child_tot num_child_dir
#> col_class <logical> <numeric> <logical>     <numeric>     <numeric>
#> 1_103          <NA>      <NA>      <NA>             2             2
#> 1_104          <NA>      <NA>      <NA>             2             2
#> 1_105          <NA>      <NA>      <NA>             3             3
#> 1_106          <NA>      <NA>      <NA>             3             3
#> 1_109          <NA>      <NA>      <NA>             1             1
#> ...             ...       ...       ...           ...           ...
#> 1_118          <NA>      <NA>      <NA>             0             0
#> 1_119          <NA>      <NA>      <NA>             0             0
#> 1_124          <NA>      <NA>      <NA>             0             0
#> 1_127          <NA>      <NA>      <NA>             0             0
#> 1_128          <NA>      <NA>      <NA>             0             0
#>           num_child_ind |   affection         num       error affection_mods
#> col_class     <numeric>   <character> <character> <character>    <character>
#> 1_103                 0             1           2        <NA>              1
#> 1_104                 0             0           4        <NA>              0
#> 1_105                 0          <NA>           6        <NA>             NA
#> 1_106                 0          <NA>           1        <NA>             NA
#> 1_109                 0             0           3        <NA>              0
#> ...                 ...           ...         ...         ...            ...
#> 1_118                 0             1           2        <NA>              1
#> 1_119                 0             1           6        <NA>              1
#> 1_124                 0             1        <NA>        <NA>              1
#> 1_127                 0             1           5        <NA>              1
#> 1_128                 0             1           3        <NA>              1
#>            avail_mods
#> col_class <character>
#> 1_103               0
#> 1_104               0
#> 1_105               0
#> 1_106               0
#> 1_109               1
#> ...               ...
#> 1_118               1
#> 1_119               1
#> 1_124               1
#> 1_127               1
#> 1_128               1
#> Rel object with 0 relationshipswith 0 MZ twin, 0 DZ twin, 0 UZ twin, 0 Spouse:
#>          id1         id2                     code       famid     group
#>  <character> <character> <c("ordered", "factor")> <character> <numeric>
#> 
#> $id_trim
#>  [1] "1_101" "1_102" "1_107" "1_108" "1_111" "1_113" "1_121" "1_122" "1_123"
#> [10] "1_131" "1_132" "1_134" "1_139" "1_126" "1_125" "1_133" "1_140" "1_141"
#> [19] "1_130" "1_129" "1_116"
#> 
#> $id_lst
#> $id_lst$unavail
#>  [1] "1_101" "1_102" "1_107" "1_108" "1_111" "1_113" "1_121" "1_122" "1_123"
#> [10] "1_131" "1_132" "1_134" "1_139"
#> 
#> $id_lst$affect
#> [1] "1_126" "1_125" "1_133" "1_140" "1_141" "1_130" "1_129" "1_116"
#> 
#> 
#> $bit_size
#>  [1] 46 29 27 23 21 19 15 14 13 11
#> 
#> $avail
#>  [1] FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE
#> [13]  TRUE
#> 
#> $pedSizeOriginal
#> [1] 41
#> 
#> $pedSizeIntermed
#> [1] 28
#> 
#> $pedSizeFinal
#> [1] 13
#> 
```
