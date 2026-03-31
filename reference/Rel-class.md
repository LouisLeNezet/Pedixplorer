# Rel object

S4 class to represent the special relationships in a Pedigree.

### Constructor :

You either need to provide a vector of the same size for each slot or a
`data.frame` with the corresponding columns.

## Usage

``` r
# S4 method for class 'data.frame'
Rel(obj)

# S4 method for class 'character_OR_integer'
Rel(obj, id2, code, famid = NA_character_, group = NA_character_)
```

## Arguments

- obj:

  A character vector with the id of the first individuals of each pairs
  or a `data.frame` with all the informations in corresponding columns.

- id2:

  A character vector with the id of the second individuals of each pairs

- code:

  A character, factor or numeric vector corresponding to the relation
  code of the individuals:

  - MZ twin = Monozygotic twin

  - DZ twin = Dizygotic twin

  - UZ twin = twin of unknown zygosity

  - Spouse = Spouse The following values are recognized:

  - character() or factor() : "MZ twin", "DZ twin", "UZ twin", "Spouse"
    with of without space between the words. The case is not important.

  - numeric() : 1 = "MZ twin", 2 = "DZ twin", 3 = "UZ twin", 4 =
    "Spouse"

- famid:

  A character vector with the family identifiers of the individuals. If
  provide, will be aggregated to the individuals identifiers separated
  by an underscore.

- group:

  A numeric vector with the set number for twins.

## Value

A Rel object.

## Details

A Rel object is a list of special relationships between individuals in
the pedigree. It is used to create a Pedigree object. The minimal needed
informations are `id1`, `id2` and `code`.

If a `famid` is provided, the individuals `id` will be aggregated to the
`famid` character to ensure the uniqueness of the `id`.

## Slots

- `id1`:

  A character vector with the id of the first individual.

- `id2`:

  A character vector with the id of the second individual.

- `code`:

  An ordered factor vector with the code of the special relationship.

  (i.e. `MZ twin` \< `DZ twin` \< `UZ twin` \< `Spouse`).

- `famid`:

  A character vector with the famid of the individuals.

- `group`:

  A numeric vector with the set number for twins.

## Accessors

For all the following accessors, the `x` parameters is a Rel object.
Each getters return a vector of the same length as `x` with the values
of the corresponding slot.

- `code(x)` : Relationships' code

&nbsp;

- `id1(x)` : Relationships' first individuals' identifier

&nbsp;

- `id2(x)` : Relationships' second individuals' identifier

&nbsp;

- `famid(x)` : Relationships' individuals' family identifier

&nbsp;

- `famid(x) <- value` : Set the relationships' individuals' family
  identifier

  - `value` : A character or integer vector of the same length as x with
    the family identifiers

## Generics

- `summary(x)`: Compute the summary of a Rel object

&nbsp;

- `show(x)`: Convert the Rel object to a data.frame and print it with
  its summary.

&nbsp;

- `as.list(x)`: Convert a Rel object to a list

&nbsp;

- `as.data.frame(x)`: Convert a Rel object to a data.frame

&nbsp;

- `subset(x, i, keep = TRUE)`: Subset a Rel object based on the
  individuals identifiers given.

  - `i` : A vector of individuals identifiers to keep.

  - `keep` : A logical value indicating if the individuals should be
    kept or deleted.

## See also

[`Pedigree()`](https://louislenezet.github.io/Pedixplorer/reference/Pedigree-class.md)

## Examples

``` r
rel_df <- data.frame(
    id1 = c("1", "2", "3"),
    id2 = c("2", "3", "4"),
    code = c(1, 1, 4)
)
Rel(rel_df)
#> Rel object with 4 relationshipswith 3 MZ twin, 0 DZ twin, 0 UZ twin, 1 Spouse:
#>           id1         id2                     code       famid     group
#>   <character> <character> <c("ordered", "factor")> <character> <numeric>
#> 1           1           2                  MZ twin        <NA>         1
#> 2           1           3                  MZ twin        <NA>         1
#> 3           2           3                  MZ twin        <NA>         1
#> 4           3           4                   Spouse        <NA>      <NA>

Rel(
    obj = c("1", "2", "3"),
    id2 = c("2", "3", "4"),
    code = c(1, 1, 4)
)
#> Rel object with 4 relationshipswith 3 MZ twin, 0 DZ twin, 0 UZ twin, 1 Spouse:
#>           id1         id2                     code       famid     group
#>   <character> <character> <c("ordered", "factor")> <character> <numeric>
#> 1           1           2                  MZ twin        <NA>         1
#> 2           1           3                  MZ twin        <NA>         1
#> 3           2           3                  MZ twin        <NA>         1
#> 4           3           4                   Spouse        <NA>      <NA>
```
