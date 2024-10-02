#' @rdname color_picker
#' @importFrom shiny NS fluidRow uiOutput
color_picker_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::fluidRow(
        shiny::uiOutput(ns("colors_pickers"))
    )
}

#' Shiny modules to select colours
#'
#' This function allows to select different colours for an
#' array of variables.
#'
#' @param id A string to identify the module.
#' @param colors A list of variables and their default colours.
#' @return A reactive list with the selected colours.
#' @examples
#' if (interactive()) {
#'     color_picker_demo()
#' }
#' @rdname color_picker
#' @keywords internal
#' @importFrom shiny moduleServer NS req renderUI column
#' @importFrom shiny reactive
#' @importFrom colourpicker colourInput
color_picker_server <- function(
    id, colors = NULL
) {
    ns <- shiny::NS(id)
    shiny::moduleServer(id, function(input, output, session) {

        output$colors_pickers <- shiny::renderUI({
            shiny::req(colors)
            lapply(
                names(colors),
                function(col) {
                    shiny::column(
                        width = as.integer(12 / length(colors)),
                        colourpicker::colourInput(
                            ns(paste0("select_", col)),
                            label = col,
                            value = colors[[col]],
                            showColour = "background",
                            closeOnClick = TRUE,
                            width = "50px"
                        )
                    )
                }
            )
        })

        lst_cols <- list()
        col_select_list <- shiny::reactive({
            shiny::req(colors)
            for (col in names(colors)) {
                lst_cols[[col]] <- input[[paste0("select_", col)]]
            }
            return(lst_cols)
        })

        return(col_select_list)
    })
}

#' @rdname color_picker
#' @export
#' @importFrom shiny fluidPage textOutput shinyApp
#' @importFrom shiny exportTestValues
color_picker_demo <- function() {
    ui <- shiny::fluidPage()
    server <- function(input, output, session) {}
    shiny::shinyApp(ui, server)
}
