### Use a small sample pedigree data set

This is a small fictive pedigree data set, with 55 individuals in 2 families.
The aim was to create a data set with a variety of pedigree structures.

It contains a data frame with 55 observations, one line per subject, on the
following 7 variables.

- `famid` : Family identifier
- `id` : Subject identifier
- `dadid` : Identifier of the father, if the father is part of the
data set; zero otherwise
- `momid` : Identifier of the mother, if the mother is part of the
data set; zero otherwise
- `sex` : `1` for male or `2` for female
- `affection` : `1` or `0`
- `avail` : `1` or `0`
- `num` : Numerical test variable from 0 to 6 randomly distributed
