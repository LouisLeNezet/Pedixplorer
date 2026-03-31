# Hints object

The hints are used to specify the order of the individuals in the
pedigree and to specify the order of the spouses.

### Constructor :

You either need to provide **horder** or **spouse** in the dedicated
parameters (together or separately), or inside a list.

## Usage

``` r
Hints(horder, spouse)

# S4 method for class 'list,missing_OR_NULL'
Hints(horder, spouse)

# S4 method for class 'numeric,data.frame'
Hints(horder, spouse)

# S4 method for class 'missing_OR_NULL,data.frame'
Hints(horder, spouse)

# S4 method for class 'numeric,missing_OR_NULL'
Hints(horder, spouse)
```

## Arguments

- horder:

  A named numeric vector with one element per subject in the Pedigree.
  It determines the relative horizontal order of subjects within a
  sibship, as well as the relative order of processing for the founder
  couples. (For this latter, the female founders are ordered as though
  they were sisters). The names of the vector should be the individual
  identifiers.

- spouse:

  A data.frame with one row per hinted marriage, usually only a few
  marriages in a pedigree will need an added hint, for instance reverse
  the plot order of a husband/wife pair. Each row contains the id of the
  left spouse (i.e. `idl`), the id of the right hand spouse (i.e.
  `idr`), and the anchor (i.e : `anchor` : `1` = left, `2` = right, `0`
  = either). Children will preferentially appear under the parents of
  the anchored spouse.

## Value

A Hints object.

## Slots

- `horder`:

  A numeric named vector with one element per subject in the Pedigree.
  It determines the relative horizontal order of subjects within a
  sibship, as well as the relative order of processing for the founder
  couples. (For this latter, the female founders are ordered as though
  they were sisters).

- `spouse`:

  A data.frame with one row per hinted marriage, usually only a few
  marriages in a Pedigree will need an added hint, for instance reverse
  the plot order of a husband/wife pair. Each row contains the
  identifiers of the left spouse, the right hand spouse, and the anchor
  (i.e : `1` = left, `2` = right, `0` = either).

## Accessors

- `horder(x)` : Get the horder vector

&nbsp;

- `horder(x) <- value` : Set the horder vector

&nbsp;

- `spouse(x)` : Get the spouse data.frame

&nbsp;

- `spouse(x) <- value` : Set the spouse data.frame

## Generics

- `as.list(x)`: Convert a Hints object to a list

&nbsp;

- `subset(x, i, keep = TRUE)`: Subset a Hints object based on the
  individuals identifiers given.

  - `i` : A vector of individuals identifiers to keep.

  - `keep` : A logical value indicating if the individuals should be
    kept or deleted.

## See also

[`Pedigree()`](https://louislenezet.github.io/Pedixplorer/reference/Pedigree-class.md)

## Examples

``` r
Hints(
    list(
        horder = c("1" = 1, "2" = 2, "3" = 3),
        spouse = data.frame(
            idl = c("1", "2"),
            idr = c("2", "3"),
            anchor = c(1, 2)
        )
    )
)
#> An object of class "Hints"
#> Slot "horder":
#> 1 2 3 
#> 1 2 3 
#> 
#> Slot "spouse":
#>   idl idr anchor
#> 1   1   2   left
#> 2   2   3  right
#> 

Hints(
    horder = c("1" = 1, "2" = 2, "3" = 3),
    spouse = data.frame(
        idl = c("1", "2"),
        idr = c("2", "3"),
        anchor = c(1, 2)
    )
)
#> An object of class "Hints"
#> Slot "horder":
#> 1 2 3 
#> 1 2 3 
#> 
#> Slot "spouse":
#>   idl idr anchor
#> 1   1   2   left
#> 2   2   3  right
#> 

Hints(
    horder = c("1" = 1, "2" = 2, "3" = 3),
    spouse = data.frame(
        idl = c("1", "2"),
        idr = c("2", "3"),
        anchor = c(1, 2)
    )
)
#> An object of class "Hints"
#> Slot "horder":
#> 1 2 3 
#> 1 2 3 
#> 
#> Slot "spouse":
#>   idl idr anchor
#> 1   1   2   left
#> 2   2   3  right
#> 

Hints(
    horder = c("1" = 1, "2" = 2, "3" = 3)
)
#> An object of class "Hints"
#> Slot "horder":
#> 1 2 3 
#> 1 2 3 
#> 
#> Slot "spouse":
#> [1] idl    idr    anchor
#> <0 rows> (or 0-length row.names)
#> 
```
