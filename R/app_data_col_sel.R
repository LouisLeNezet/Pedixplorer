#' @importFrom shiny NS column div h5 uiOutput tagList

usethis::use_package("shiny")

#' User interface of selecting columns module
#'
#' @param id A string to identify the module.
#' @return A Shiny module UI.
#' @examples
#' data_col_sel_demo()
#' @export
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

#' Server function of selecting columns module
#'
#' @param id A string to identify the module.
#' @param df A reactive dataframe.
#' @param cols_needed A character vector of the mandatory columns.
#' @param cols_supl A character vector of the optional columns.
#' @param title A string to display in the selectInput.
#' @param na_omit A boolean to allow or not the selection of NA.
#' @return A reactive dataframe with the selected columns renamed
#' to the names of cols_needed and cols_supl.
#' @examples
#' data_col_sel_demo()
#' @export
data_col_sel_server <- function(
    id, df, cols_needed, cols_supl, title, na_omit = FALSE
) {
    stopifnot(shiny::is.reactive(df))
    ns <- shiny::NS(id)
    shiny::moduleServer(id, function(input, output, session) {
        # Set all columns as named vector -------------------------------------
        all_cols <- shiny::reactive({
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
            for (col in c(cols_needed, cols_supl)) {
                mandatory <- ifelse(col %in% cols_needed, "*", "")
                v[[col]] <- shiny::div(
                    id = ns("Div"), class = "div-null",
                    style = "margin-top:-1.5em",
                    shiny::selectInput(
                        ns(paste0("select_", col)),
                        label = shiny::h5(paste(title, col, mandatory)),
                        choices = all_cols()
                    )
                )
            }
            v
        })

        # Rendering of the needed columns -------------------------------------
        output$all_cols_need <- shiny::renderUI({
            all_sel()[cols_needed]
        })
        # Rendering of the optional columns -----------------------------------
        output$all_cols_supl <- shiny::renderUI({
            all_sel()[cols_supl]
        })

        # Obtain all selected columns -----------------------------------------
        r <- list()
        col_select_list <- shiny::reactive({
            for (col in c(cols_needed, cols_supl)) {
                input_select_cols <- input[[paste0("select_", col)]]
                r[[col]] <- input_select_cols
            }
            r
        })

        # Rename the columns of the dataframe ---------------------------------
        df_rename <- shiny::reactive({
            cols_ren <- col_select_list()[col_select_list() != "NA"]
            if (any(!cols_needed %in% names(cols_ren))) {
                NULL
            } else {
                if (any(duplicated(as.vector(unlist(cols_ren))))) {
                    shiny::showNotification(
                        "You have selected twice the same column !"
                    )
                    NULL
                } else {
                    df_rename <- data.table::copy(df())
                    data.table::setnames(
                        df_rename,
                        old = as.vector(unlist(cols_ren)),
                        new = names(cols_ren)
                    )
                    # Select only setted columns
                    df_rename[, c(
                        cols_needed, cols_supl[cols_supl %in% names(cols_ren)]
                    )]
                }
            }
        })
        return(df_rename)
    })
}

#' Demo function of selecting columns module
#' @examples
#' data_col_sel_demo()
data_col_sel_demo <- function() {
    ui <- shiny::fluidPage(
        data_col_sel_ui("datafile"),
        shiny::tableOutput("selected_cols")
    )
    server <- function(input, output, session) {
        df <- data_col_sel_server(
            "datafile",
            shiny::reactive({
                mtcars
            }),
            c("Need1", "Need2"),
            c("Supl1", "Supl2"),
            "Select column"
        )
        output$selected_cols <- shiny::renderTable({
            df()
        })
    }
    shiny::shinyApp(ui, server)
}
