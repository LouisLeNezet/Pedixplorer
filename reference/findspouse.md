# Find the spouse of a subject

Find the spouse of a subject

## Usage

``` r
findspouse(idpos, plist, lev, obj)
```

## Arguments

- idpos:

  The position of the subject

- plist:

  The alignment structure representing the Pedigree layout. See
  [`align()`](https://louislenezet.github.io/Pedixplorer/reference/align.md)
  for details.

- lev:

  The generation level of the subject

- obj:

  A Pedigree object

## Value

The position of the spouse

## Details

This routine is used by
[`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md).
It finds the spouse of a subject.

## See also

[`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md)
