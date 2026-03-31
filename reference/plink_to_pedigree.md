# Import from .fam file or .ped file

Import a .fam or .ped file and return a Pedigree object

## Usage

``` r
plink_to_pedigree(
  path,
  sep = "\t",
  quote = "'",
  header = FALSE,
  na_values = c("NA", "0")
)
```

## Arguments

- path:

  Path to the file

- sep:

  Separator used in the file

- quote:

  Quote used in the file

- header:

  Boolean defining if the file has a header

- na_values:

  A vector of strings that should be considered as NA

## Value

A Pedigree object

## Examples

``` r
if (interactive()) {
    write.table(
        data.frame(
            famid = c("1", "1", "1"),
            id = c("A", "B", "C"),
            dadid = c(0, 0, "A"),
            momid = c(0, 0, "B"),
            sex = c(1, 2, 1)
        ), file = "test.fam", sep = "\t", quote = FALSE,
        row.names = FALSE, col.names = FALSE
    )
    fam <- "test.fam"
    pedi <- plink_to_pedigree(fam)
}
```
