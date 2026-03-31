# Find the duplicate pairs of a subject

Find the duplicate pairs of a subject

## Usage

``` r
duporder(idlist, plist, lev, obj)
```

## Arguments

- idlist:

  List of individuals identifiers to be considered

- plist:

  The alignment structure representing the Pedigree layout. See
  [`align()`](https://louislenezet.github.io/Pedixplorer/reference/align.md)
  for details.

- lev:

  The generation level of the subject

- obj:

  A Pedigree object

## Value

A matrix of duplicate pairs

## Details

This routine is used by
[`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md).
It finds the duplicate pairs of a subject and returns them in the order
they should be plotted.

## See also

[`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md)
