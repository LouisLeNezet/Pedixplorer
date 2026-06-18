# The Pedixplorer package for pedigree data

The Pedixplorer package for pedigree data an updated package of the
`kinship2` package. The `kinship2` package was originally written by
Terry Therneau and Jason Sinnwell. The `Pedixplorer` package is a fork
of the `kinship2` package with additional functionality and bug fixes.

## Details

The package download, NEWS, and README are available on CRAN:
[Kinship2](https://cran.r-project.org/package=kinship2) for the previous
version of the package.

## Functions

Below are listed some of the most widely used functions available in
arsenal:

[`Pedigree()`](https://louislenezet.github.io/Pedixplorer/reference/Pedigree-class.md):
Contstructor of the Pedigree class, given identifiers, sex, affection
status(es), and special relationships

[`kinship()`](https://louislenezet.github.io/Pedixplorer/reference/kinship.md):
Calculates the kinship matrix, the probability having an allele sampled
from two individuals be the same via IBD.

[`plot()`](https://rdrr.io/r/graphics/plot.default.html) : Method to
transform a Pedigree object into a graphical plot. Allows extra
information to be included in the id under the plot symbol. This method
use the
[`plot_fromdf()`](https://louislenezet.github.io/Pedixplorer/reference/plot_fromdf.md)
function to transform the Pedigree object into a data frame of graphical
elements, the same is done for the legend with the
[`ped_to_legdf()`](https://louislenezet.github.io/Pedixplorer/reference/ped_to_legdf.md)
function. When done, the data frames are plotted with the
[`plot_fromdf()`](https://louislenezet.github.io/Pedixplorer/reference/plot_fromdf.md)
function.

[`shrink()`](https://louislenezet.github.io/Pedixplorer/reference/shrink.md):
Shrink a Pedigree to a specific bit size, removing non-informative
members first.

[`bit_size()`](https://louislenezet.github.io/Pedixplorer/reference/bit_size.md):
Approximate the output from SAS's `PROC FREQ` procedure when using the
`/list` option of the `TABLE` statement.

## Data

- [`sampleped()`](https://louislenezet.github.io/Pedixplorer/reference/sampleped.md):
  Pedigree example data sets with two pedigrees

- [`minnbreast()`](https://louislenezet.github.io/Pedixplorer/reference/minnbreast.md):
  Larger cohort of pedigrees from MN breast cancer study

## See also

Useful links:

- <https://louislenezet.github.io/Pedixplorer/>

- Report bugs at <https://github.com/LouisLeNezet/Pedixplorer/issues>

## Author

**Maintainer**: Louis Le Nezet <louislenezet@gmail.com>
([ORCID](https://orcid.org/0009-0000-0202-2703)) \[contributor\]

Authors:

- Jason Sinnwell <sinnwell.jason@mayo.edu>

- Terry Therneau

Other contributors:

- Daniel Schaid \[contributor\]

- Elizabeth Atkinson \[contributor\]

## Examples

``` r
library(Pedixplorer)
```
