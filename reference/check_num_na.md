# Is numeric or NA

Check if a variable given is numeric or NA

## Usage

``` r
check_num_na(var, na_as_num = TRUE)
```

## Arguments

- var:

  Vector of value to test

- na_as_num:

  Boolean defining if the `NA` string should be considered as numerical
  values

## Value

A vector of boolean of the same size as **var**

## Details

Check if the values in **var** are numeric or if they are `NA` in the
case that `na_as_num` is set to TRUE.
