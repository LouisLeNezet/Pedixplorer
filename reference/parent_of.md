# Get parents of individuals

Get the parents of individuals.

## Usage

``` r
# S4 method for class 'character_OR_integer'
parent_of(obj, dadid, momid, id2)

# S4 method for class 'Ped'
parent_of(obj, id2)

# S4 method for class 'Pedigree'
parent_of(obj, id2)
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

- id2:

  A vector of individuals identifiers to get the parents from

## Value

A vector of individuals identifiers corresponding to the parents of the
individuals in **id2**

## Examples

``` r
data(sampleped)
ped <- Pedigree(sampleped)
parent_of(ped, "1_121")
#> [1] "1_110" "1_109"
```
