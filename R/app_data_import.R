# This module was created during the St Jude Bio-Hackathon of May 2023
# by the team 13.
# author: Max Qiu (maxqiu@unl.edu)
# author: Louis Le Nézet (louislenezet@gmail.com)

#### Library needed #### ----------
usethis::use_package("shiny")
usethis::use_package("readxl")
usethis::use_package("shinyWidgets")
usethis::use_package("shinytoastr")

#### Function needed to work #### ----------

#' Read data from file path
#'
#' @description Read dataframe based on the extension of the file
#'
#' @details This function detect the extension of the file and proceed to use
#' the according function to read it with the parameters given by the user.
#'
#' @param file The file path
#' @param sep A string defining the separator to use for the file
#' @param quote A string defining the quote to use
#' @param header A boolean defining if the dataframe contain a header or not
#' @param df_name A string defining the name of the dataframe / sheet to use
#' @param stringsAsFactors A boolean defining if all the strings should be
#' interpreted ad factor
#' @param to_char A boolean defining if all the dataset should be read as
#' character.
#' @returns A dataframe.
#' @examples
#' \dontrun{
#'     read_data('path/to/my/file.txt', sep=',', header=FALSE)
#' }
#' @keywords data_import, internal
read_data <- function(
    file, sep = ";", quote = "'", header = TRUE, df_name = NA,
    stringsAsFactors = FALSE, to_char = TRUE,
    na_values = c("", "NA", "NULL", "None")
) {
    shiny::req(file)
    if (!is.null(file)) {
        tryCatch({
            ext <- tools::file_ext(file)
            if (!ext %in% c("csv", "txt", "xls", "xlsx", "rda", "tab")) {
                stop("Please upload a (csv, txt, xls, xlsx, rda, tab) file")
            }

            if (to_char) {
                col_classes <- "character"
                col_types <- "text"
            } else {
                col_classes <- NA
                col_types <- NULL
            }

            if (ext %in% c("csv", "txt")) {
                df <- utils::read.csv(
                    file, sep = sep, quote = quote,
                    header = header, colClasses = col_classes,
                    na.strings = na_values
                )
            } else if (ext %in% c("tab")) {
                df <- utils::read.table(
                    file, quote = quote, header = header,
                    sep = sep, fill = TRUE, colClasses = col_classes,
                    na.strings = na_values
                )
            } else if (ext %in% c("xls", "xlsx")) {
                sheets_present <- readxl::excel_sheets(file)
                if (is.null(df_name)) {
                    stop("Please select a sheet")
                } else {
                    if (df_name %in% sheets_present) {
                        df <- as.data.frame(readxl::read_excel(
                            file, sheet = df_name,
                            col_names = header, col_types = col_types,
                            na = na_values
                        ))
                    } else {
                        stop("Sheet selected isn't in file")
                    }
                }
            } else if (ext %in% c("rda")) {
                shiny::req(df_name)
                all_data <- base::load(file)
                if (is.na(df_name)) {
                    stop("Please select a dataframe")
                } else {
                    if (df_name %in% all_data) {
                        df <- get(df_name)
                    } else {
                        stop("Dataframe selected isn't in file")
                    }
                }
            }
        }, error = function(e) {
            shinytoastr::toastr_error(
                title = "Error while reading the file", conditionMessage(e)
            )
            return(NULL)
        })
        as.data.frame(unclass(df), stringsAsFactors = stringsAsFactors)
    } else {
        NULL
    }
}

#' Get dataframe name
#'
#' @description Extract the name of the different dataframe present in a file
#'
#' @details This function detect the extension of the file and extract if
#' necessary the different dataframe / sheet names available.
#' @param file The file path
#' @returns A vector of all the dataframe name present.
#' @examples
#' \dontrun{
#'     get_dataframe('path/to/my/file.txt')
#' }
#' @keywords data_import, internal
get_dataframe <- function(file) {
    shiny::req(file)
    ext <- tools::file_ext(file)
    if (ext %in% c("xls", "xlsx")) {
        sheets_present <- readxl::excel_sheets(file)
        if (!is.null(sheets_present)) {
            sheets_present
        } else {
            shinytoastr::toastr_info(title = "No sheets find in file")
            NULL
        }
    } else if (ext == "rda") {
        base::load(file)
    } else {
        message("File not an xls, xlsx nor rda")
        NULL
    }
}

#### UI function of the module #### ----------

#' @rdname data_import
data_import_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::tagList(
        shinytoastr::useToastr(),
        shiny::uiOutput(ns("fileselection")),
        shiny::fluidRow(
            shiny::h5("Use test data"),
            shiny::column(
                width = 6,
                shinyWidgets::switchInput(
                    ns("testdf"), value = FALSE, size = "small"
                )
            ),
            shiny::column(
                width = 6,
                shiny::actionButton(
                    ns("options"),
                    "Options", style = "simple", size = "sm"
                )
            )
        ),
        shiny::selectInput(
            ns("sep"), "Separator",
            c(Comma = ",", `Semi-colon` = ";", Tabulation = "\t", Space = " "),
            selected = "\t"
        ),
        shiny::uiOutput(ns("dfselection"))
    )
}


#' Shiny modules to import data files
#'
#' This module allow to import multiple type of data.
#' The file type currently supported are csv, txt, xls, xslx, rda and tab.
#' The server dynamically create a selection input if multiple
#' dataframe are present in the file selected.
#' This module is composed of two parts: the UI and the server.
#' The UI is called with the function `data_import_ui()` and the server
#' with the function `data_import_server()`.
#' Different options are available to the user to import the data.
#'
#' @param id A string.
#' @param label A string use to prompt the user
#' @param dftest A dataframe to test the function
#' @param max_request_size A number to define the maximum size of the file
#' that can be uploaded.
#' @returns A reactive dataframe selected by the user.
#' @examples
#' if (interactive()) {
#'     data_import_demo()
#' }
#' @keywords data
#' @rdname data_import
#' @keywords internal
data_import_server <- function(
    id, label = "Select data file",
    dftest = datasets::mtcars, max_request_size = 30
) {
    options(shiny.maxRequestSize = max_request_size * 1024^2)
    shiny::moduleServer(id, function(input, output, session) {
        ns <- shiny::NS(id)
        ## File rendering selection ------------------------
        output$fileselection <- shiny::renderUI({
            shiny::fileInput(ns("fileinput"), label)
        })

        ## Options rendering selection --------------------
        opt <- shiny::reactiveValues(
            heading = TRUE, to_char = FALSE,
            stringsAsFactors = FALSE, quote = "\"",
            na_values = c("", "NA", "NULL", "None")
        )
        shiny::observeEvent(input$options, {
            # display a modal dialog with a header, textinput and action buttons
            shiny::showModal(shiny::modalDialog(
                shiny::tags$h2("Select your options"),
                shiny::checkboxInput(
                    ns("heading"), "Has heading",
                    value = opt$heading
                ),
                shiny::checkboxInput(
                    ns("to_char"), "Load all data as strings",
                    value = opt$to_char
                ),
                shiny::checkboxInput(
                    ns("stringsAsFactors"),
                    "Strings as factors", value = opt$stringsAsFactors
                ),
                shinyWidgets::pickerInput(ns("quote"), "Quote", c(
                    "None" = "",
                    "Double quote" = "\"",
                    "Single quote" = "'",
                    "Both" = "\"'"
                ), selected = opt$quote, multiple = FALSE),
                shiny::textAreaInput(
                    ns("na_string"), "NA values",
                    value = paste0(opt$na_values, collapse = ","),
                    placeholder = "Enter the NA values separated by a comma"
                ),
                footer = shiny::tagList(
                    shiny::actionButton(ns("close"), "Close"),
                )
            ))
        })

        # Store the information if the user clicks close
        shiny::observeEvent(input$close, {
            shiny::removeModal()
            opt$heading <- input$heading
            opt$to_char <- input$to_char
            opt$stringsAsFactors <- input$stringsAsFactors
            opt$quote <- input$quote
            opt$na_values <- strsplit(
                input$na_values, ",", useBytes = TRUE
            )[[1]]
        })

        # Set switch to FALSE if the user upload a file
        shiny::observeEvent(input$fileinput, {
            print("File uploaded")
            shinyWidgets::updateSwitchInput(
                session = session,
                inputId = "testdf", value = FALSE
            )
        })

        ## Data selection ------------------------
        df <- shiny::reactive({
            if (is.null(input$testdf)) {
                return(NULL)
            }
            if (input$testdf) {
                if (!is.null(dftest)) {
                    return(dftest)
                } else {
                    shinytoastr::toastr_error(
                        title = "Error in data import",
                        "No test data available"
                    )
                    return(NULL)
                }
            }
            if (is.null(input$fileinput)) {
                return(NULL)
            }

            file_path <- input$fileinput$datapath
            read_data(
                file_path, sep = input$sep, quote = opt$quote,
                header = opt$heading, df_name = input$dfSelected,
                stringsAsFactors = opt$stringsAsFactors, to_char = opt$to_char,
                na_values = opt$na_values
            )
        })

        # We can run observers in here if we want to
        shiny::observe({
            shiny::req(input$fileinput)
            shinytoastr::toastr_success(
                title = "File uploaded",
                sprintf("File %s was uploaded", input$fileinput$name)
            )
        })

        output$dfselection <- shiny::renderUI({
            file_path <- input$fileinput$datapath
            df_name <- get_dataframe(file_path)
            if (!is.null(df_name)) {
                shiny::selectInput(
                    ns("dfSelected"), label = label,
                    choices = df_name, selected = df_name[1]
                )
            } else {
                NULL
            }
        })

        # Return the reactive that yields the data frame
        return(df)
    })
}

#' @rdname data_import
#' @export
data_import_demo <- function() {
    ui <- shiny::fluidPage(
        data_import_ui("my_data_import"),
        shiny::tableOutput("data")
    )
    server <- function(input, output, session) {
        df_import <- data_import_server(
            id = "my_data_import", label = "Select data file"
        )
        output$data <- shiny::renderTable({
            if (is.null(df_import())) {
                return(NULL)
            }
            df_import()
        })
        shiny::exportTestValues(df_import = {
            df_import()
        })
    }
    shiny::shinyApp(ui, server)
}
