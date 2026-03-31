# Read data from file path

Read dataframe based on the extension of the file

## Usage

``` r
read_data(
  file,
  sep = ";",
  quote = "'",
  header = TRUE,
  df_name = NA,
  strings_as_factors = FALSE,
  to_char = TRUE,
  na_values = c("", "NA", "NULL", "None")
)
```

## Arguments

- file:

  The file path

- sep:

  A string defining the separator to use for the file

- quote:

  A string defining the quote to use

- header:

  A boolean defining if the dataframe contain a header or not

- df_name:

  A string defining the name of the dataframe / sheet to use

- strings_as_factors:

  A boolean defining if all the strings should be interpreted ad factor

- to_char:

  A boolean defining if all the dataset should be read as character.

## Value

A dataframe.

## Details

This function detect the extension of the file and proceed to use the
according function to read it with the parameters given by the user.

## Examples

``` r
if (FALSE) { # \dontrun{
    read_data('path/to/my/file.txt', sep=',', header=FALSE)
} # }
```
