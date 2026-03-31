# Shiny modules to download a dataframe

This function allows to download a dataframe as a csv file. This
generate a Shiny module that can be used in a Shiny app. The function is
composed of two parts: the UI and the server. The UI is called with the
function `data_download_ui()` and the server with the function
`data_download_server()`.

## Usage

``` r
data_download_ui(id)

data_download_server(
  id,
  df,
  filename,
  label = NULL,
  helper = TRUE,
  title = "Data download"
)

data_download_demo()
```

## Arguments

- id:

  A string to identify the module.

- df:

  A reactive dataframe.

- filename:

  A string to name the file.

- label:

  A string to display in the download button.

- helper:

  A boolean to display a helper message.

## Value

A shiny module to export a dataframe.

## Examples

``` r
if (interactive()) {
    data_download_demo()
}
```
