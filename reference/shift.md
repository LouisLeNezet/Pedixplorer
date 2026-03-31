# Shift set of siblings to the left or right

Shift set of siblings to the left or right

## Usage

``` r
shift(id, sibs, goleft, hint, twinrel, twinset)
```

## Arguments

- id:

  The id of the subject to be shifted

- sibs:

  The ids of the siblings

- goleft:

  If `TRUE`, shift to the left, otherwise to the right

- hint:

  The current hint vector

- twinrel:

  The twin relationship matrix

- twinset:

  The twinset vector

## Value

The updated hint vector

## Details

This routine is used by
[`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md).
It shifts a set of siblings to the left or right, so that the marriage
is on the edge of the set of siblings, closest to the spouse. It also
shifts the subject himself, so that he is on the edge of the set of
siblings, closest to the spouse. It also shifts the monozygotic twins,
if any, so that they are together within the set of twins.

## See also

[`auto_hint()`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md)
