# Find informative individuals

Select the ids of the informative individuals.

## Usage

``` r
# S4 method for class 'character_OR_integer'
is_informative(obj, avail, affected, informative = "AvAf")

# S4 method for class 'Ped'
is_informative(obj, informative = "AvAf", reset = FALSE)

# S4 method for class 'Pedigree'
is_informative(obj, col_aff = NULL, informative = "AvAf", reset = FALSE)
```

## Arguments

- obj:

  A character vector with the id of the individuals or a `data.frame`
  with all the informations in corresponding columns.

- avail:

  A logical vector with the availability status of the individuals (i.e.
  `FALSE` = not available, `TRUE` = available, `NA` = unknown).

- affected:

  A logical vector with the affection status of the individuals (i.e.
  `FALSE` = unaffected, `TRUE` = affected, `NA` = unknown).

- informative:

  Informative individuals selection can take 5 values:

  - 'AvAf' (available and affected),

  - 'AvOrAf' (available or affected),

  - 'Av' (available only),

  - 'Af' (affected only),

  - 'All' (all individuals)

  - A numeric/character vector of individuals id

  - A boolean

- reset:

  If `TRUE`, the `isinf` slot is reset

- col_aff:

  A character vector with the name of the column to be used for the
  affection status.

## Value

### When obj is a vector

A vector of individuals informative identifiers.

### When obj is a Pedigree

The Pedigree object with its `isinf` slot updated.

## Details

Depending on the **informative** parameter, the function will extract
the ids of the informative individuals. In the case of a numeric vector,
the function will return the same vector. In the case of a boolean, the
function will return the ids of the individuals if TRUE, NA otherwise.
In the case of a string, the function will return the ids of the
corresponding informative individuals based on the avail and affected
columns.

## Examples

``` r
is_informative(c("A", "B", "C", "D", "E"), informative = c("A", "B"))
#> [1] "A" "B"
is_informative(c("A", "B", "C", "D", "E"), informative = c(1, 2))
#> [1] "A" "B"
is_informative(c("A", "B", "C", "D", "E"), informative = c("A", "B"))
#> [1] "A" "B"
is_informative(c("A", "B", "C", "D", "E"), avail = c(1, 0, 0, 1, 1),
    affected = c(0, 1, 0, 1, 1), informative = "AvAf")
#> [1] "D" "E"
is_informative(c("A", "B", "C", "D", "E"), avail = c(1, 0, 0, 1, 1),
    affected = c(0, 1, 0, 1, 1), informative = "AvOrAf")
#> [1] "A" "B" "D" "E"
is_informative(c("A", "B", "C", "D", "E"),
    informative = c(TRUE, FALSE, TRUE, FALSE, TRUE))
#> [1] "A" "C" "E"

data("sampleped")
pedi <- ped(Pedigree(sampleped))
pedi <- is_informative(pedi, informative = "Av")
isinf(pedi)
#>  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE
#> [13]  TRUE FALSE FALSE  TRUE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE  TRUE
#> [25]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE FALSE FALSE FALSE
#> [37] FALSE FALSE FALSE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE FALSE  TRUE  TRUE
#> [49] FALSE FALSE FALSE  TRUE  TRUE FALSE  TRUE

data("sampleped")
pedi <- Pedigree(sampleped)
pedi <- is_informative(pedi, col_aff = "affection")
isinf(ped(pedi))
#>  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
#> [13] FALSE FALSE FALSE  TRUE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE  TRUE
#> [25] FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [37] FALSE FALSE FALSE FALSE FALSE  TRUE FALSE  TRUE FALSE FALSE  TRUE  TRUE
#> [49] FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
```
