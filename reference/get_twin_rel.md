# Get twin relationships

Get twin relationships

## Usage

``` r
get_twin_rel(obj)
```

## Arguments

- obj:

  A Pedigree object

## Value

A list containing components

1.  `twinset` the set of twins

2.  `twinrel` the twins relationships

3.  `twinord` the order of the twins

## Details

This routine function determine the twin relationships in a Pedigree. It
determine the order of the twins in the Pedigree. It is used by
[`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md).

## See also

[`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md)
