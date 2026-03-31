# Shiny modules to select columns from a dataframe

This function allows to select columns from a dataframe and rename them
to a set of names present in a configuration list. This generate a Shiny
module that can be used in a Shiny app. The function is composed of two
parts: the UI and the server. The UI is called with the function
`data_col_sel_ui()` and the server with the function
`data_col_sel_server()`.

## Usage

``` r
data_col_sel_ui(id, ui_col_nb = 1)

data_col_sel_server(
  id,
  df,
  col_config,
  title,
  na_omit = TRUE,
  others_cols = TRUE,
  ui_col_nb = 1,
  by_row = FALSE,
  help_colour = "grey",
  help_type = "markdown",
  help_style = "margin-top:1em"
)

data_col_sel_demo(ui_col_nb = 2, by_row = FALSE)
```

## Arguments

- id:

  A string to identify the module.

- df:

  A reactive dataframe.

- col_config:

  A named list of column definitions. It must contain a list for each
  column, with the following keys: 'alternate' and 'mandatory'. The
  'alternate' key must contain a character vector of column names that
  can be selected as an alternative to the main column. The 'mandatory'
  key must contain a logical value (TRUE/FALSE) to indicate whether the
  column is required to be selected. The 'help' key must contain a
  string with the help message to display in the tooltip or the name of
  a markdown file to display in the help message.

- title:

  A string to display in the selectInput.

- na_omit:

  A boolean to allow or not the selection of NA.

- others_cols:

  A boolean to authorize other columns to be present in the output
  datatable.

- help_colour:

  A string to define the color of the help icon.

- help_type:

  A string to define the type of help message. It can be "inline" or
  "markdonw".

- help_style:

  A string to define the style of the help message. This is passed to
  the `style` argument of the
  [`shinyhelper::helper()`](https://rdrr.io/pkg/shinyhelper/man/helper.html)
  function.

## Value

A reactive dataframe with the selected columns renamed to the names
present in the configuration list.

## Examples

``` r
if (interactive()) {
    data_col_sel_demo()
}
```
