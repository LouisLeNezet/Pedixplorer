usethis::use_package("shiny")

data_col_sel_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::tagList(
        shiny::div(
            id = ns("Div"), class = "div-global",
            style = "margin-top:1.5em",
            shiny::uiOutput(ns("all_cols_sel"))
        ),
        shiny::div(
            id = ns("Div"), class = "div-global",
            style = "margin-top:1.5em",
            shiny::uiOutput(ns("cols_avail"))
        )
    )
}

data_col_sel_server <- function(
    id, df, cols_needed, cols_supl, title, null = FALSE
) {
    stopifnot(shiny::is.reactive(df))
    ns <- shiny::NS(id)
    shiny::moduleServer(id, function(input, output, session) {
        print("Bal: data_col_sel_server")
        all_cols <- shiny::reactive({
            all_cols <- colnames(df())
            setNames(c("NA", all_cols), c("", all_cols))
        })

        v <- list()
        all_sel <- shiny::reactive({
            for (col in c(cols_needed, cols_supl)) {
                v[[col]] <- shiny::div(
                    id = ns("Div"), class = "div-null",
                    style = "margin-top:-1.5em",
                    shiny::selectInput(
                        ns(paste0("select_", col)),
                        label = shiny::h5(paste(title, col)),
                        choices = all_cols()
                    )
                )
            }
            v
        })

        output$all_cols_sel <- shiny::renderUI({
            all_sel()
        })

        r <- list()
        col_select_list <- shiny::reactive({
            for (col in c(cols_needed, cols_supl)) {
                input_select_cols <- input[[paste0("select_", col)]]
                r[[col]] <- input_select_cols
            }
            r
        })

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
            c("Need1", "Need2"), c("Supl1", "Supl2"),
            "Select column"
        )
        output$selected_cols <- shiny::renderTable({
            df()
        })
    }
    shiny::shinyApp(ui, server)
}
