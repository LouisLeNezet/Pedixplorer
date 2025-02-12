#' Check column configuration
#' 
#' This function checks the validity of the column configuration
#' provided to the `data_col_sel_server` function.
#' 
#' The list names must correspond to the column names of the dataframe
#' to be selected. Each list must contain two keys: 'alternate' and 'mandatory'.
#' The 'alternate' key must contain a character vector of column names
#' that can be selected as an alternative to the main column.
#' The 'mandatory' key must contain a logical value (TRUE/FALSE) to indicate
#' whether the column is required to be selected.
#' 
#' @param col_config A list of column definitions.
#' It must contain a list for each column, with the following
#' keys: 'alternate' and 'mandatory'.
#' @return TRUE if the configuration is valid.
#' @examples
#' check_col_config(list(
#'    ColA = list(alternate = c("A"), mandatory = TRUE),
#'   ColB = list(alternate = c("B"), mandatory = FALSE)
#' ))
#' @keywords internal
check_col_config <- function(col_config) {
    # Ensure col_config is a list
    if (!is.list(col_config)) {
        stop("col_config must be a list.")
    }

    if (any(duplicated(names(col_config)))) {
        stop(paste(
            "Duplicate column names detected in col_config.",
            "Ensure each column is defined only once."
        ))
    }

    # Ensure each element is properly structured
    for (col_name in names(col_config)) {
        col_def <- col_config[[col_name]]
        if (!is.list(col_def) || !"alternate" %in% names(col_def)
            || !"mandatory" %in% names(col_def
        )) {
            stop(paste(
                "Each column definition in col_config",
                "must be a list with 'alternate' and 'mandatory' keys.",
                "Issue with:", col_name
            ))
        }

        # Check 'alternate' is a character vector
        if (!is.character(col_def$alternate)
            || length(col_def$alternate) == 0
        ) {
            stop(paste(
                "The 'alternate' field for", col_name,
                "must be a non-empty character vector."
            ))
        }

        # Check 'mandatory' is logical (TRUE/FALSE)
        if (!is.logical(col_def$mandatory)
            || length(col_def$mandatory) != 1
        ) {
            stop(paste(
                "The 'mandatory' field for", col_name,
                "must be a single TRUE/FALSE value."
            ))
        }
    }

    # Check for duplicate column names in 'alternate' lists
    all_alternates <- unlist(lapply(col_config, function(x) x$alternate))
    all_alternates <- all_alternates[!is.na(all_alternates)]
    if (any(duplicated(all_alternates))) {
        all_alternates <- all_alternates[duplicated(all_alternates)]
        stop(paste(
            all_alternates, "is duplicated in alternate configuration.",
            "Ensure each column appears in only one definition."
        ))
    }

    return(TRUE)  # If all checks pass, return TRUE
}

#' Rename columns in a dataframe
#' 
#' This function renames the columns of a dataframe based on the
#' user-selected columns.
#' It also validates the user-selected columns and ensures that
#' the mandatory columns are selected.
#' 
#' @param df A dataframe to be modified.
#' @param selections A named list of user-selected columns, the 
#' names of the list must correspond to the new column names.
#' @param col_config A list of columns configuration
#' see [check_col_config()] for more details.
#' @param others_cols A boolean to authorize other columns to be
#' present in the output datatable.
#' @return A dataframe with the selected columns renamed.
#' @examples
#' df <- data.frame(
#'    ColN1 = c(1, 2), ColN2 = 4, ColTU1 = "A", ColTU2 = 3
#' )
#' validate_and_rename_df(
#'    df, list(Need1 = "ColN1", Sup2 = "ColTU1"),
#'    list(
#'        Need1 = list(alternate = c("ColN1", "ColN3"), mandatory = TRUE),
#'        Sup2 = list(alternate = c("ColTU1", "ColTU3"), mandatory = FALSE)
#'    )
#' )
#' @keywords internal
validate_and_rename_df <- function(df, selections, col_config, others_cols = TRUE) {
    # Ensure df is a data.table or data.frame
    if (!is.data.frame(df)) {
        stop("The input 'df' must be a data frame or data table.")
    }
    
    # Ensure selections is a named list
    if (!is.list(selections) || is.null(names(selections))) {
        stop("The 'selections' argument must be a named list.")
    }

    # Select only valid columns
    selected_valid <- selections[selections != "NA"]

    # Check for duplicate selections
    if (any(duplicated(unlist(selected_valid)))) {
        stop("You have selected the same column multiple times.")
    }

    # Ensure all mandatory columns are selected
    mandatory_cols <- names(col_config)[sapply(col_config, function(x) x$mandatory)]
    if (any(!mandatory_cols %in% names(selected_valid))) {
        return(NULL)
    }

    # Ensure selected columns exist in df
    if (any(!unlist(selected_valid) %in% colnames(df))) {
        stop("Selected column is not in the dataframe!")
    }

    # Rename dataframe columns
    colnames(df)[match(
        unlist(selected_valid),
        colnames(df)
    )] <- names(selected_valid)

    # Return either full or filtered dataframe
    if (others_cols) {
        return(df)
    } else {
        return(df[names(selected_valid)])
    }

}

#' Distribute elements by group
#' 
#' This function distributes elements by group
#' for a given number of elements. The
#' distribution can be done by row or by column.
#' 
#' @param nb_group The number of group.
#' @param nb_elem The number of elements to distribute.
#' @param by_row A boolean to distribute by row or by column.
#' @return A vector of group indices.
#' @examples
#' distribute_by(3, 10)
#' distribute_by(3, 10, by_row = TRUE)
#' @keywords internal
distribute_by <- function(nb_group, nb_elem, by_row = FALSE) {                
    if (by_row) {
        return(rep_len(1:nb_group, nb_elem))
    }

    base_size <- nb_elem %/% nb_group  # Minimum group size
    remainder <- nb_elem %% nb_group   # Extra items to distribute

    group_sizes <- rep(base_size, nb_group) + (1:nb_group <= remainder)
    
    return(rep(1:nb_group, times = group_sizes))
}

#' @rdname data_col_sel
#' @importFrom shiny NS column div uiOutput tagList
data_col_sel_ui <- function(id, ui_col_nb = 1) {
    ns <- shiny::NS(id)
    shiny::tagList(
        shinytoastr::useToastr(),
        shiny::fluidRow(
            # Dynamically create columns
            lapply(seq_len(ui_col_nb), function(i) {
                shiny::column(
                    # Distribute UI evenly
                    width = floor(12 / ui_col_nb),
                    shiny::div(
                        id = ns(paste0("Div_", i)), 
                        class = "div-global",
                        style = "margin-top:1.5em",
                        shiny::uiOutput(ns(paste0("col_group_", i)))
                    )
                )
            })
        )
    )
}

#' Shiny modules to select columns from a dataframe
#'
#' This function allows to select columns from a dataframe
#' and rename them to the names of cols_needed and cols_supl.
#' This generate a Shiny module that can be used in a Shiny app.
#' The function is composed of two parts: the UI and the server.
#' The UI is called with the function `data_col_sel_ui()` and the server
#' with the function `data_col_sel_server()`.
#'
#' @param id A string to identify the module.
#' @param df A reactive dataframe.
#' @param cols_needed A character vector of the mandatory columns.
#' @param cols_supl A character vector of the optional columns.
#' @param title A string to display in the selectInput.
#' @param na_omit A boolean to allow or not the selection of NA.
#' @param others_cols A boolean to authorize other columns to be
#' present in the output datatable.
#'
#' @return A reactive dataframe with the selected columns renamed
#' to the names of cols_needed and cols_supl.
#' @examples
#' if (interactive()) {
#'     data_col_sel_demo()
#' }
#' @rdname data_col_sel
#' @keywords internal
#' @importFrom shiny moduleServer NS req renderUI selectInput
#' @importFrom shiny reactive is.reactive div selectInput h5
#' @importFrom shinytoastr toastr_error
#' @importFrom data.table copy setnames
#' @importFrom stats setNames
data_col_sel_server <- function(
    id, df, col_config, title,
    na_omit = TRUE, others_cols = TRUE,
    ui_col_nb = 1, by_row = FALSE
) {
    stopifnot(shiny::is.reactive(df))
    ns <- shiny::NS(id)

    shiny::moduleServer(id, function(input, output, session) {

        # Store error messages
        error_msg <- shiny::reactiveVal(NULL)

        # Validate col_config before running module
        tryCatch({
            check_col_config(col_config)
        }, error = function(e) {
            error_msg(conditionMessage(e))
            return(NULL)
        })

        # Get all column names from df -------------------------------------
        all_cols <- shiny::reactive({
            shiny::req(df())
            col_names <- colnames(df())
            if (na_omit) {
                stats::setNames(c("NA", col_names), c("", col_names))
            } else {
                stats::setNames(col_names, col_names)
            }
        })

        # Generate UI selectors dynamically  -------------------------------
        col_selectors <- shiny::reactive({
            shiny::req(all_cols())
            selectors <- list()

            seq_groups <- distribute_by(ui_col_nb, length(col_config), by_row)

            for (i in seq_along(names(col_config))) {
                col_name <- names(col_config)[i]
                col_options <- c(col_config[[col_name]]$alternate, col_name)
                mandatory <- ifelse(col_config[[col_name]]$mandatory, "*", "")

                # Pre-select a matching column if available
                selected_col <- intersect(tolower(col_options), tolower(all_cols()))[1]

                # Restore the original column name casing from all_cols()
                selected_col <- all_cols()[match(selected_col, tolower(all_cols()))]
                selected_col <- ifelse(length(selected_col) > 0, selected_col, NA)

                selectors[[col_name]] <- list(
                    ui = shiny::div(
                        class = "div-null",
                        style = "margin-top:-1.5em",
                        shiny::selectInput(
                            ns(paste0("select_", col_name)),
                            label = shiny::h5(paste(title, col_name, mandatory)),
                            choices = all_cols(),
                            selected = selected_col
                        )
                    ),
                    group = seq_groups[i]
                )
            }
            selectors
        })

        # Dynamically render UI groups
        lapply(seq_len(ui_col_nb), function(i) {
            output[[paste0("col_group_", i)]] <- shiny::renderUI({
                shiny::req(col_selectors())
                # Render only selectors assigned to this group
                lapply(names(col_selectors()), function(col_name) {
                    if (col_selectors()[[col_name]]$group == i) {
                        col_selectors()[[col_name]]$ui
                    }
                })
            })
        })

        # Collect user-selected columns
        selected_cols <- shiny::reactive({
            shiny::req(df())
            shiny::req(col_selectors())
            selections <- list()
            for (col_name in names(col_config)) {
                selections[[col_name]] <- input[[paste0("select_", col_name)]]
            }
            selections
        })

        # Rename the columns of the dataframe ---------------------------------
        df_rename <- shiny::reactive({
            if (is.null(df()) ||
                is.null(selected_cols()) ||
                length(selected_cols()) == 0
            ) {
                return(NULL)
            }
            shiny::req(df(), selected_cols())
            tryCatch({
                validate_and_rename_df(
                    df(), selected_cols(), col_config, others_cols
                )
            }, error = function(e) {
                error_msg(conditionMessage(e))
                return(NULL)
            })
        })

        # Observe error messages and trigger toastr notifications
        shiny::observeEvent(error_msg(), {
            if (!is.null(error_msg())) {
                print(error_msg())
                shinytoastr::toastr_error(
                    title = "Error in column selection module",
                    message = error_msg()
                )
                error_msg(NULL)  # Reset error message after showing the popup
            }
        })

        return(df_rename)
    })
}

#' @rdname data_col_sel
#' @export
#' @importFrom shiny fluidPage tableOutput shinyApp
#' @importFrom shiny exportTestValues reactive
data_col_sel_demo <- function(ui_col_nb = 2, by_row = FALSE) {
    ui <- shiny::fluidPage(
        data_col_sel_ui("datafile", ui_col_nb),
        shiny::tableOutput("selected_cols")
    )
    server <- function(input, output, session) {
        my_df <- data_col_sel_server(
            "datafile",
            shiny::reactive({
                datasets::mtcars
            }),
            list(
                "Need1" = list(alternate = c("mpg", "cyl"), mandatory = TRUE),
                "Need2" = list(alternate = c(NA_character_), mandatory = TRUE),
                "Supl1" = list(alternate = c("disp"), mandatory = FALSE),
                "Supl2" = list(alternate = c(NA_character_), mandatory = FALSE)
            ),
            title = "Select column", ui_col_nb = ui_col_nb, by_row = by_row
        )
        output$selected_cols <- shiny::renderTable({
            my_df()
        })
        shiny::exportTestValues(my_df = {
            my_df()
        })
    }
    shiny::shinyApp(ui, server)
}
