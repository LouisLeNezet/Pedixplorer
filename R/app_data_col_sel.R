#' @importFrom shiny NS column div h5 uiOutput tagList
#' @importFrom data.table copy setnames

usethis::use_package("shiny")
usethis::use_package("data.table")

#' @rdname data_col_sel
data_col_sel_ui <- function(id) {
    ns <- shiny::NS(id)
    tagList(
        column(6,
            div(
                id = ns("Div"), class = "div-global",
                style = "margin-top:1.5em",
                uiOutput(ns("all_cols_need"))
            )
        ), column(6,
            div(
                id = ns("Div"), class = "div-global",
                style = "margin-top:1.5em",
                uiOutput(ns("all_cols_supl"))
            )
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
#' \dontrun{
#'     data_col_sel_demo()
#' }
#' @rdname data_col_sel
data_col_sel_server <- function(
    id, df, cols_needed, cols_supl, title, na_omit = TRUE, others_cols = TRUE
) {
    stopifnot(shiny::is.reactive(df))
    ns <- shiny::NS(id)
    shiny::moduleServer(id, function(input, output, session) {
        new_cols <- c(cols_needed, cols_supl)
        # Set all columns as named vector -------------------------------------
        all_cols <- shiny::reactive({
            shiny::req(df())
            all_cols <- colnames(df())
            if (na_omit) {
                setNames(c("NA", all_cols), c("", all_cols))
            } else {
                setNames(all_cols, all_cols)
            }
        })

        # Creation of the columns selectors -----------------------------------
        v <- list()
        all_sel <- shiny::reactive({
            shiny::req(all_cols())
            for (col in names(new_cols)) {
                mandatory <- ifelse(col %in% names(cols_needed), "*", "")
                select <- all_cols()[all_cols() %in% new_cols[[col]]][1]
                v[[col]] <- shiny::div(
                    id = ns("Div"), class = "div-null",
                    style = "margin-top:-1.5em",
                    shiny::selectInput(
                        ns(paste0("select_", col)),
                        label = shiny::h5(paste(title, col, mandatory)),
                        choices = all_cols(), selected = select
                    )
                )
            }
            v
        })

        # Rendering of the needed columns -------------------------------------
        output$all_cols_need <- shiny::renderUI({
            shiny::req(all_sel())
            all_sel()[names(cols_needed)]
        })
        # Rendering of the optional columns -----------------------------------
        output$all_cols_supl <- shiny::renderUI({
            shiny::req(all_sel())
            all_sel()[names(cols_supl)]
        })

        # Obtain all selected columns -----------------------------------------
        r <- list()
        col_select_list <- shiny::reactive({
            shiny::req(df())
            shiny::req(all_sel())
            for (col in names(new_cols)) {
                r[[col]] <- input[[paste0("select_", col)]]
            }
            r
        })

        # Rename the columns of the dataframe ---------------------------------
        df_rename <- shiny::reactive({
            if (is.null(df())) {
                return(NULL)
            }
            cols_ren <- col_select_list()[col_select_list() != "NA"]
            if (any(!names(cols_needed) %in% names(cols_ren))) {
                return(NULL)
            } else {
                if (any(duplicated(as.vector(unlist(cols_ren))))) {
                    shiny::showNotification(
                        "You have selected twice the same column !"
                    )
                    return(NULL)
                } else {
                    if (any(!cols_ren %in% all_cols())) {
                        shiny::showNotification(
                            "You have selected a column that is not in the list !"
                        )
                        return(NULL)
                    }
                    df_rename <- data.table::copy(df())
                    data.table::setnames(
                        df_rename,
                        old = as.vector(unlist(cols_ren)),
                        new = names(cols_ren)
                    )
                    if (others_cols) {
                        df_rename
                    } else {
                        # Select only setted columns
                        df_rename[, c(
                            names(cols_needed),
                            names(cols_supl)[
                                names(cols_supl) %in% cols_ren
                            ]
                        )]
                    }
                }
            }
        })
        return(df_rename)
    })
}

#' @rdname data_col_sel
#' @export
data_col_sel_demo <- function() {
    ui <- shiny::fluidPage(
        data_col_sel_ui("datafile"),
        shiny::tableOutput("selected_cols")
    )
    server <- function(input, output, session) {
        df <- data_col_sel_server(
            "datafile",
            shiny::reactive({
                datasets::mtcars
            }),
            list("Need1" = c("mpg", "cyl"), "Need2" = c()),
            list("Supl1" = c("other"), "Supl2" = c("disp")),
            "Select column"
        )
        output$selected_cols <- shiny::renderTable({
            df()
        })
    }
    shiny::shinyApp(ui, server)
}
