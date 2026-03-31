# Minimum distance to the informative individuals

Compute the minimum distance between the informative individuals and all
the others. This distance is a transformation of the maximum kinship
degree between the informative individuals and all the others. This
transformation is done by taking the log2 of the inverse of the maximum
kinship degree.

\\minDist = log2(1 / \max(kinship))\\

Therefore, the minimum distance is 1 when the maximum kinship is 0.5
(i.e. same individual) and is infinite when the maximum kinship is 0
(i.e. not related).

For siblings, the kinship value is 0.25 and the minimum distance is 2.
Each time the kinship degree is divided by 2, the minimum distance is
increased by 1.

## Usage

``` r
# S4 method for class 'character'
min_dist_inf(obj, dadid, momid, sex, id_inf)

# S4 method for class 'Pedigree'
min_dist_inf(obj, reset = FALSE, ...)

# S4 method for class 'Ped'
min_dist_inf(obj, reset = FALSE)
```

## Arguments

- obj:

  A character vector with the id of the individuals or a `data.frame`
  with all the informations in corresponding columns.

- ...:

  Additional arguments

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

- id_inf:

  An identifiers vector of informative individuals.

- reset:

  If TRUE, the `kin` and if `isinf` columns is reset

## Value

### When obj is a vector

A vector of the minimum distance between the informative individuals and
all the others corresponding to the order of the individuals in the
`obj` vector.

### When obj is a Pedigree

The Pedigree object with a new slot named 'kin' containing the minimum
distance between each individuals and the informative individuals. The
`isinf` slot is also updated with the informative individuals.

## See also

[`kinship()`](https://louislenezet.github.io/Pedixplorer/reference/kinship.md)

## Examples

``` r
min_dist_inf(
    c("A", "B", "C", "D", "E"),
    c("C", "D", "0", "0", "0"),
    c("E", "E", "0", "0", "0"),
    sex = c(1, 2, 1, 2, 1),
    id_inf = c("D", "E")
)
#>   A   B   C   D   E 
#>   2   2 Inf   1   1 

data(sampleped)
pedi <- is_informative(
    Pedigree(sampleped),
    informative = "AvAf", col_aff = "affection"
)
kin(ped(min_dist_inf(pedi, col_aff = "affection")))
#> 1_101 1_102 1_103 1_104 1_105 1_106 1_107 1_108 1_109 1_110 1_111 1_112 1_113 
#>     3     3     2     2     2     2   Inf   Inf     2     1     2     2   Inf 
#> 1_114 1_115 1_116 1_117 1_118 1_119 1_120 1_121 1_122 1_123 1_124 1_125 1_126 
#>     2     2     1   Inf     1     1   Inf     2     2     2     1     2     2 
#> 1_127 1_128 1_129 1_130 1_131 1_132 1_133 1_134 1_135 1_136 1_137 1_138 1_139 
#>     1     1     2     2     2     2     2     2     3     3   Inf     3     4 
#> 1_140 1_141 2_201 2_202 2_203 2_204 2_205 2_206 2_207 2_208 2_209 2_210 2_211 
#>     4     4     1     2     1     2     2     1     1     2     2     2     2 
#> 2_212 2_213 2_214 
#>     2     2     1 
```
