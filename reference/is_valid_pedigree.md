# Check if a Pedigree object is valid

Multiple checks are done here

## Usage

``` r
is_valid_pedigree(object)
```

## Arguments

- object:

  A Ped object.

## Value

A character vector with the errors or `TRUE` if no errors.

## Details

1.  Check that the all Rel id are in the Ped object

2.  Check that twins have same parents

3.  Check that MZ twins have same sex

4.  Check that all columns used in scales are in the Ped object

5.  Check that all fill & border modalities are in the Ped object column

6.  Check that all id used in Hints object are in the Ped object

7.  Check that all spouse in Hints object are male / female
