# Check if a Ped object is valid

Multiple checks are done here

## Usage

``` r
is_valid_ped(object)
```

## Arguments

- object:

  A Ped object.

## Value

A character vector with the errors or `TRUE` if no errors.

## Details

1.  Check that the ped ids slots have the right values

2.  Check that the sex, fertility, deceased, avail and affected slots
    have the right values

3.  Check that dad are male and mom are female

4.  Check that individuals have both parents or none

5.  Check that proband are affected

6.  Check that proband and consultand are mutually exclusive

7.  Check that asymptomatic individuals are not affected
