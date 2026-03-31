# IBD matrix

Transform identity by descent (IBD) matrix data from the form produced
by external programs such as SOLAR into the compact form used by the
coxme and lmekin routines.

## Usage

``` r
ibd_matrix(id1, id2, ibd, idmap, diagonal)
```

## Arguments

- id1:

  A character vector with the id of the first individuals of each pairs
  or a matrix or data frame with 3 columns: id1, id2, and ibd

- id2:

  A character vector with the id of the second individuals of each pairs

- ibd:

  the IBD value for that pair

- idmap:

  an optional 2 column matrix or data frame whose first element is the
  internal value (as found in `id1` and `id2`, and whose second element
  will be used for the dimnames of the result

- diagonal:

  optional value for the diagonal element. If present, any missing
  diagonal elements in the input data will be set to this value.

## Value

a sparse matrix of class `dsCMatrix`. This is the same form used for
kinship matrices.

## Details

The IBD matrix for a set of n subjects will be an n by n symmetric
matrix whose i,j element is the contains, for some given genetic
location, a 0/1 indicator of whether 0, 1/2 or 2/2 of the alleles for i
and j are identical by descent. Fractional values occur if the IBD
fraction must be imputed. The diagonal will be 1. Since a large fraction
of the values will be zero, programs such as Solar return a data set
containing only the non-zero elements. As well, Solar will have
renumbered the subjects as seq_len(n) in such a way that families are
grouped together in the matrix; a separate index file contains the
mapping between this new id and the original one. The final matrix
should be labeled with the original identifiers.

## See also

[`kinship()`](https://louislenezet.github.io/Pedixplorer/reference/kinship.md)

## Examples

``` r
df <- data.frame(
    id1 = c("1", "2", "1"),
    id2 = c("2", "3", "4"),
    ibd = c(0.5, 0.16, 0.27)
)
ibd_matrix(df$id1, df$id2, df$ibd, diagonal = 2)
#> 4 x 4 sparse Matrix of class "dsCMatrix"
#>      1    2    3    4
#> 1 2.00 0.50 .    0.27
#> 2 0.50 2.00 0.16 .   
#> 3 .    0.16 2.00 .   
#> 4 0.27 .    .    2.00
```
