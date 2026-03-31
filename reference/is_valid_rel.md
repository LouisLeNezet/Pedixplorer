# Check if a Rel object is valid

Multiple checks are done here

## Usage

``` r
is_valid_rel(object)
```

## Arguments

- object:

  A Ped object.

## Value

A character vector with the errors or `TRUE` if no errors.

## Details

1.  Check that the "id1", "id2", "code", "famid" slots exist

2.  Check that the "code" slots have the right values (i.e. "MZ twin",
    "DZ twin", "UZ twin", "Spouse")

3.  Check that all "id1" are different to "id2"

4.  Check that all "id1" are smaller than "id2"

5.  Check that no duplicate relation are present
