# Find intersections of a ray with a segment

Given the coordinates of a segment and the angle of a ray from the
origin, this function computes the intersection point of the ray with
the segment.

## Usage

``` r
find_ray_intersections(x0, y0, x1, y1, theta)
```

## Arguments

- x0:

  x-coordinate of the segment's starting point

- y0:

  y-coordinate of the segment's starting point

- x1:

  x-coordinate of the segment's ending point

- y1:

  y-coordinate of the segment's ending point

- theta:

  Angle of the ray from the origin (in radians)

## Value

A vector of the x and y coordinates of the intersection point, or NA if
no intersection occurs.

## Examples

``` r
Pedixplorer:::find_ray_intersections(0, 0, 1, 1, pi / 4)
#> [1] 0 0
```
