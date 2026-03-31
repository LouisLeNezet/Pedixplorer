# Number of childs

Compute the number of childs per individual

## Usage

``` r
# S4 method for class 'character_OR_integer'
num_child(obj, dadid, momid, rel_df = NULL, missid = NA_character_)

# S4 method for class 'Pedigree'
num_child(obj, reset = FALSE)
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

- rel_df:

  A data.frame with the special relationships between individuals. See
  [`Rel()`](https://louislenezet.github.io/Pedixplorer/reference/Rel-class.md)
  for more informations. The minimum columns required are `id1`, `id2`
  and `code`. The `famid` column can also be used to specify the family
  of the individuals. If a matrix is given, the columns needs to be
  ordered as `id1`, `id2`, `code` and `famid`. The code values are:

  - `1` = Monozygotic twin

  - `2` = Dizygotic twin

  - `3` = twin of unknown zygosity

  - `4` = Spouse

  The value relation code recognized by the function are the one defined
  by the
  [`rel_code_to_factor()`](https://louislenezet.github.io/Pedixplorer/reference/rel_code_to_factor.md)
  function.

- missid:

  A character vector with the missing values identifiers. All the id,
  dadid and momid corresponding to those values will be set to
  `NA_character_`.

- reset:

  If TRUE, the `num_child_tot`, `num_child_ind` and the `num_child_dir`
  columns are reset.

## Value

### When obj is a vector

A dataframe with the columns `num_child_dir`, `num_child_ind` and
`num_child_tot` giving respectively the direct, indirect and total
number of child.

### When obj is a Pedigree object

An updated Pedigree object with the columns `num_child_dir`,
`num_child_ind` and `num_child_tot` added to the Pedigree `ped` slot.

## Details

Compute the number of direct child but also the number of indirect child
given by the ones related with the linked spouses. If a relation ship
dataframe is given, then even if no children is present between 2
spouses, the indirect childs will still be added.

## Examples

``` r
num_child(
    obj = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10"),
    dadid = c("3", "3", "6", "8", "0", "0", "0", "0", "0", "0"),
    momid = c("4", "5", "7", "9", "0", "0", "0", "0", "0", "0"),
    rel_df = data.frame(
        id1 = "10",
        id2 = "3",
        code = "Spouse"
    )
)
#>    id dadid momid num_child_dir num_child_tot num_child_ind
#> 1   1     3     4             0             0             0
#> 2   2     3     5             0             0             0
#> 3   3     6     7             2             2             0
#> 4   4     8     9             1             2             1
#> 5   5     0     0             1             2             1
#> 6   6     0     0             1             1             0
#> 7   7     0     0             1             1             0
#> 8   8     0     0             1             1             0
#> 9   9     0     0             1             1             0
#> 10 10     0     0             0             2             2

data(sampleped)
ped1 <- Pedigree(sampleped[sampleped$famid == "1",])
ped1 <- num_child(ped1, reset = TRUE)
summary(ped(ped1))
#> [1] "Ped object with 41 individuals and 5 metadata columns"
```
