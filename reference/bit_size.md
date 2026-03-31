# Bit size of a Pedigree

Utility function used in the
[`shrink()`](https://louislenezet.github.io/Pedixplorer/reference/shrink.md)
function to calculate the bit size of a Pedigree.

## Usage

``` r
# S4 method for class 'character_OR_integer'
bit_size(obj, momid, missid = NA_character_)

# S4 method for class 'Pedigree'
bit_size(obj)

# S4 method for class 'Ped'
bit_size(obj)
```

## Arguments

- obj:

  A Ped or Pedigree object or a vector of fathers identifiers

- momid:

  A vector containing for each subject, the identifiers of the
  biologicals mothers.

- missid:

  A character vector with the missing values identifiers. All the id,
  dadid and momid corresponding to those values will be set to
  `NA_character_`.

## Value

A list with the following components:

- bit_size The bit size of the Pedigree

- nFounder The number of founders in the Pedigree

- nNonFounder The number of non founders in the Pedigree

## Details

The bit size of a Pedigree is defined as :

\$\$ 2 \times NbNonFounders - NbFounders \$\$

Where `NbNonFounders` is the number of non founders in the Pedigree
(i.e. individuals with identified parents) and `NbFounders` is the
number of founders in the Pedigree (i.e. individuals without identified
parents).

## See also

[`shrink()`](https://louislenezet.github.io/Pedixplorer/reference/shrink.md)

## Examples

``` r
data(sampleped)
pedi <- Pedigree(sampleped)
bit_size(pedi)
#> $bit_size
#> [1] 62
#> 
#> $nFounder
#> [1] 16
#> 
#> $nNonFounder
#> [1] 39
#> 
```
