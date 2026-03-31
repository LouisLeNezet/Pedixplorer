# Get dataframe name

Extract the name of the different dataframe present in a file

## Usage

``` r
get_dataframe(file)
```

## Arguments

- file:

  The file path

## Value

A vector of all the dataframe name present.

## Details

This function detect the extension of the file and extract if necessary
the different dataframe / sheet names available.

## Examples

``` r
if (FALSE) { # \dontrun{
    get_dataframe('path/to/my/file.txt')
} # }
```
