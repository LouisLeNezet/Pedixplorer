# Relped data

Small set of related individuals for testing purposes.

## Usage

``` r
data("relped")
```

## Format

The dataframe is composed of 4 columns:

- `id1` : the first individual identifier,

- `id2` : the second individual identifier,

- `code` : the relationship between the two individuals,

- `famid` : the family identifier. The relationship codes are:

- `1` for Monozygotic twin

- `2` for Dizygotic twin

- `3` for Twin of unknown zygosity

- `4` for Spouse relationship

## Details

This is a small fictive data set of relation that accompanies the
sampleped data set. The aim was to create a data set with a variety of
relationships. There is 8 relations with 4 different types of
relationships.

## Examples

``` r
data("relped")
data("sampleped")
pedi <- Pedigree(sampleped, relped)
summary(pedi)
#> $pedigree_summary
#> [1] "Ped object with 55 individuals and 5 metadata columns"
#> 
#> $relationship_summary
#> [1] "Rel object with 9 relationshipswith 4 MZ twin, 2 DZ twin, 2 UZ twin, 1 Spouse"
#> 
if (interactive()) { plot(pedi) }
```
