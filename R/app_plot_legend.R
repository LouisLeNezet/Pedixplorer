#### Library needed #### ----------
usethis::use_package("shiny")

#### UI function of the module #### ----------
#' @rdname plot_legend
#' @export
plot_legend_ui <- function(id, height = "200px") {
    ns <- shiny::NS(id)
    column(12,
        style = "background-color:#4d3a7d;",
        shiny::plotOutput(ns("plotlegend"), height = height)
    )
}

#### Server function of the module #### ----------
#' Shiny module to generate pedigree graph legend.
#'
#' This module allows to plot the legend of a pedigree object.
#' The function is composed of two parts: the UI and the server.
#' The UI is called with the function `plot_legend_ui()` and the server
#' with the function `plot_legend_server()`.
#'
#' @param id A string.
#' @param pedi A reactive pedigree object.
#' @returns A static UI with the legend.
#' @examples
#' if (interactive()) {
#'     plot_legend_demo()
#' }
#' @rdname plot_legend
#' @keywords internal
#' @export
plot_legend_server <- function(id, pedi, leg_loc = c(0.2, 1, 0, 1)) {
    stopifnot(shiny::is.reactive(pedi))
    shiny::moduleServer(id, function(input, output, session) {

        ns <- shiny::NS(id)

        output$plotlegend <- shiny::renderPlot({
            shiny::req(pedi())
            old_mai <- par()$mai
            par(mai = c(0, 0, 0, 0))
            plot_legend(
                pedi(), adjx = 0.7, adjy = -0.02,
                leg_loc = leg_loc
            )
            par(mai = old_mai)
        })
    })
}

#### Demo function of the module #### ----------
#' @rdname plot_legend
#' @export
plot_legend_demo <- function(height = "200px", leg_loc = c(0.2, 1, 0, 1)) {
    pedi <- shiny::reactive({
        Pedigree(
            Pedixplorer::sampleped[Pedixplorer::sampleped$famid == 1, ]
        )
    })
    ui <- shiny::fluidPage(
        plot_legend_ui("ped", height)
    )
    server <- function(input, output, session) {
        plot_legend_server("ped", pedi, leg_loc = leg_loc)
    }
    shiny::shinyApp(ui, server)
}
