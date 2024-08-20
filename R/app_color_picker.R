#' @importFrom shiny NS div uiOutput tagList

usethis::use_package("shiny")
usethis::use_package("colourpicker")
usethis::use_package("bslib")

#' @rdname color_picker
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
#' \dontrun{
#'     color_picker_demo()
#' }
#' @rdname color_picker
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
color_picker_demo <- function() {
    ui <- shiny::fluidPage(
        color_picker_ui("colors"),
        shiny::textOutput("selected_colors")
    )
    server <- function(input, output, session) {
        col_sel <- color_picker_server(
            "colors",
            list("Val1" = "red", "Val2" = "blue")
        )
        output$selected_colors <- shiny::renderText({
            paste0(col_sel())
        })
    }
    shiny::shinyApp(ui, server)
}
