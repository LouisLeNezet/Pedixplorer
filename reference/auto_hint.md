# Initial hint for a Pedigree alignment

Compute an initial guess for the alignment of a Pedigree

## Usage

``` r
# S4 method for class 'Pedigree'
auto_hint(
  obj,
  hints = NULL,
  packed = TRUE,
  align = FALSE,
  reset = FALSE,
  align_parents = TRUE,
  force = FALSE
)
```

## Arguments

- obj:

  A Pedigree object

- hints:

  A Hints object or a named list containing `horder` and `spouse`. If
  `NULL` then the Hints stored in **obj** will be used.

- packed:

  Should the Pedigree be compressed. (i.e. allow diagonal lines
  connecting parents to children in order to have a smaller overall
  width for the plot.)

- align:

  For a packed Pedigree, align children under parents `TRUE`, to the
  extent possible given the page width, or align to to the left margin
  `FALSE`. This argument can be a two element vector, giving the
  alignment parameters, or a logical value. If `TRUE`, the default is
  `c(1.5, 2)`, or if numeric the routine
  [`alignped4()`](https://louislenezet.github.io/Pedixplorer/reference/alignped4.md)
  will be called.

- reset:

  If `TRUE`, then even if the Ped object has Hints, reset them to the
  initial values.

- align_parents:

  If `align_parents = TRUE`, go one step further and try to make both
  parents of each child have the same depth. (This is not always
  possible). It helps the drawing program by lining up pedigrees that
  'join in the middle' via a marriage.

- force:

  If `force = TRUE`, the function will return the depth minus
  `min(depth)` if `depth` reach a state with no founders is not
  possible.

## Value

The initial
[Hints](https://louislenezet.github.io/Pedixplorer/reference/Hints-class.md)
object.

## Details

A Pedigree structure can contain a
[Hints](https://louislenezet.github.io/Pedixplorer/reference/Hints-class.md)
object which helps to reorder the Pedigree (e.g. left-to-right order of
children within family) so as to plot with minimal distortion. This
routine is used to create an initial version of the hints. They can then
be modified if desired.

This routine would not normally be called by a user. It moves children
within families, so that marriages are on the "edge" of a set children,
closest to the spouse. For pedigrees that have only a single connection
between two families this simple-minded approach works surprisingly
well. For more complex structures hand-tuning of the hints may be
required.

When `auto_hint()` is called with a a vector of numbers as the **hints**
argument, the values for the founder females are used to order the
founder families left to right across the plot. The values within a
sibship are used as the preliminary order of siblings within a family;
this may be changed to move one of them to the edge so as to match up
with a spouse. The actual values in the vector are not important, only
their order.

## See also

[`align()`](https://louislenezet.github.io/Pedixplorer/reference/align.md),
[`best_hint()`](https://louislenezet.github.io/Pedixplorer/reference/best_hint.md)

[Hints](https://louislenezet.github.io/Pedixplorer/reference/Hints-class.md)

## Examples

``` r
data(sampleped)
pedi <- Pedigree(sampleped[sampleped$famid == 1, ])
Pedixplorer:::auto_hint(pedi)
#> An object of class "Hints"
#> Slot "horder":
#> 1_101 1_102 1_103 1_104 1_105 1_106 1_107 1_108 1_109 1_110 1_111 1_112 1_113 
#>     1     2     3     4     5     6     7     8     1     1     2     3     1 
#> 1_114 1_115 1_116 1_117 1_118 1_119 1_120 1_121 1_122 1_123 1_124 1_125 1_126 
#>     4     1     3     9     2     4    10     1     2     3     4     5     6 
#> 1_127 1_128 1_129 1_130 1_131 1_132 1_133 1_134 1_135 1_136 1_137 1_138 1_139 
#>     7     8     9    10    11    12    13    14     2     3    10    11    11 
#> 1_140 1_141 
#>    12    13 
#> 
#> Slot "spouse":
#>     idl   idr anchor
#> 1 1_112 1_118  right
#> 2 1_114 1_115  right
#> 3 1_109 1_110   left
#> 
```
