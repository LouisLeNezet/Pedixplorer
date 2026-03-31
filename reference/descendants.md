# Descendants of individuals

Find all the descendants of a particular list of individuals given a
Pedigree object.

## Usage

``` r
# S4 method for class 'character_OR_integer,character_OR_integer'
descendants(idlist, obj, dadid, momid)

# S4 method for class 'character_OR_integer,Pedigree'
descendants(idlist, obj)

# S4 method for class 'character_OR_integer,Ped'
descendants(idlist, obj)
```

## Arguments

- idlist:

  List of individuals identifiers to be considered

- obj:

  A Ped or Pedigree object or a vector of the individuals identifiers.

- dadid:

  A vector containing for each subject, the identifiers of the
  biologicals fathers.

- momid:

  A vector containing for each subject, the identifiers of the
  biologicals mothers.

## Value

Vector of all descendants of the individuals in idlist. The list is not
ordered.

## Examples

``` r
data("sampleped")
pedi <- Pedigree(sampleped)
descendants(c("1_101", "2_208"), pedi)
#> [1] "1_109" "2_212" "2_213" "2_214" "1_121" "1_122" "1_123" "1_124"
```
