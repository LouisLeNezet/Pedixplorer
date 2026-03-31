# Shiny modules to import data files

This module allow to import multiple type of data. The file type
currently supported are csv, txt, xls, xslx, rda and tab. The server
dynamically create a selection input if multiple dataframe are present
in the file selected. This module is composed of two parts: the UI and
the server. The UI is called with the function `data_import_ui()` and
the server with the function `data_import_server()`. Different options
are available to the user to import the data.

## Usage

``` r
data_import_ui(id)

data_import_server(
  id,
  label = "Select data file",
  help_data = NULL,
  help_data_title = "",
  help_test_data = NULL,
  help_test_data_title = "",
  dftest = datasets::mtcars,
  max_request_size = 30,
  help_colour = "grey",
  help_type = "inline"
)

data_import_demo(options = list())
```

## Arguments

- id:

  A string.

- label:

  A string use to prompt the user

- help_data:

  A string to define the help content for the data import. If NULL, no
  help content is displayed.

- help_data_title:

  A string to define the title of the help content. Set it to "" to not
  display a title or to use the one present in the markdown.

- help_test_data:

  A string to define the help content for the test data. If NULL, no
  help content is displayed.

- help_test_data_title:

  A string to define the title of the help content. Set it to "" to not
  display a title or to use the one present in the markdown.

- dftest:

  A dataframe to test the function

- max_request_size:

  A number to define the maximum size of the file that can be uploaded.

- help_colour:

  A string to define the colour of the help icon

- help_type:

  A string to define the type of help content This can be "inline" or
  "markdown"

## Value

A reactive dataframe selected by the user.

## Examples

``` r
if (interactive()) {
    data_import_demo()
}
```
