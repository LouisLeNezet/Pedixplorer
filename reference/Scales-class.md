# Scales object

A Scales object is a list of two data.frame. The first one is used to
represent the affection status of the individuals and therefore the
filling of the individuals in the pedigree plot. The second one is used
to represent the availability status of the individuals and therefore
the border color of the individuals in the pedigree plot.

### Constructor :

You need to provide both **fill** and **border** in the dedicated
parameters. However this is usually done using the
[`generate_colors()`](https://louislenezet.github.io/Pedixplorer/reference/generate_colors.md)
function with a Pedigree object.

## Usage

``` r
Scales(fill, border)

# S4 method for class 'data.frame,data.frame'
Scales(fill, border)
```

## Arguments

- fill:

  A data.frame with the informations for the affection status. The
  columns needed are:

  - 'order': the order of the affection to be used

  - 'column_values': name of the column containing the raw values in the
    Ped object

  - 'column_mods': name of the column containing the mods of the
    transformed values in the Ped object

  - 'mods': all the different mods

  - 'labels': the corresponding labels of each mods

  - 'affected': a logical value indicating if the mod correspond to an
    affected individuals

  - 'fill': the color to use for this mods

  - 'density': the density of the shading

  - 'angle': the angle of the shading

- border:

  A data.frame with the informations for the availability status. The
  columns needed are:

  - 'column_values': name of the column containing the raw values in the
    Ped object

  - 'column_mods': name of the column containing the mods of the
    transformed values in the Ped object

  - 'mods': all the different mods

  - 'labels': the corresponding labels of each mods

  - 'border': the color to use for this mods

## Value

A Scales object.

## Slots

- `fill`:

  A data.frame with the informations for the affection status. The
  columns needed are:

  - 'order': the order of the affection to be used

  - 'column_values': name of the column containing the raw values in the
    Ped object

  - 'column_mods': name of the column containing the mods of the
    transformed values in the Ped object

  - 'mods': all the different mods

  - 'labels': the corresponding labels of each mods

  - 'affected': a logical value indicating if the mod correspond to an
    affected individuals

  - 'fill': the color to use for this mods

  - 'density': the density of the shading

  - 'angle': the angle of the shading

- `border`:

  A data.frame with the informations for the availability status. The
  columns needed are:

  - 'column_values': name of the column containing the raw values in the
    Ped object

  - 'column_mods': name of the column containing the mods of the
    transformed values in the Ped object

  - 'mods': all the different mods

  - 'labels': the corresponding labels of each mods

  - 'border': the color to use for this mods

## Accessors

- `fill(x)` : Get the fill data.frame

&nbsp;

- `fill(x) <- value` : Set the fill data.frame

&nbsp;

- `border(x)` : Get the border data.frame

&nbsp;

- `border(x) <- value` : Set the border data.frame from the Scales
  object.

## Generics

- `as.list(x)`: Convert a Scales object to a list

## See also

[`Pedigree()`](https://louislenezet.github.io/Pedixplorer/reference/Pedigree-class.md)

[`generate_colors()`](https://louislenezet.github.io/Pedixplorer/reference/generate_colors.md)

## Examples

``` r
Scales(
    fill = data.frame(
        order = 1,
        column_values = "affected",
        column_mods = "affected_mods",
        mods = c(0, 1),
        labels = c("unaffected", "affected"),
        affected = c(FALSE, TRUE),
        fill = c("white", "red"),
        density = c(NA, 20),
        angle = c(NA, 45)
    ),
    border = data.frame(
        column_values = "avail",
        column_mods = "avail_mods",
        mods = c(0, 1),
        labels = c("not available", "available"),
        border = c("black", "blue")
    )
)
#> An object of class "Scales"
#> Slot "fill":
#>   order column_values   column_mods mods     labels affected  fill density
#> 1     1      affected affected_mods    0 unaffected    FALSE white      NA
#> 2     1      affected affected_mods    1   affected     TRUE   red      20
#>   angle
#> 1    NA
#> 2    45
#> 
#> Slot "border":
#>   column_values column_mods mods        labels border
#> 1         avail  avail_mods    0 not available  black
#> 2         avail  avail_mods    1     available   blue
#> 
```
