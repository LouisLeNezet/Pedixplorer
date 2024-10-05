#### UI function of the module #### ----------
#' @rdname plot_legend
#' @export
#' @importFrom shiny NS column plotOutput
plot_legend_ui <- function(id, height = "200px") {
    ns <- shiny::NS(id)
    shiny::column(12,
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
#' @importFrom shiny moduleServer is.reactive renderPlot req
plot_legend_server <- function(
    id, pedi, leg_loc = c(0.2, 1, 0, 1),
    lwd = par("lwd"), boxw = 1, boxh = 1,
    adjx = 0, adjy = 0
) {
    stopifnot(shiny::is.reactive(pedi))
    shiny::moduleServer(id, function(input, output, session) {
        output$plotlegend <- shiny::renderPlot({
            shiny::req(pedi())
            old_mai <- graphics::par()$mai
            graphics::par(mai = c(0, 0, 0, 0))
            plot_legend(
                pedi(), adjx = adjx, adjy = adjy,
                boxw = boxw, boxh = boxh,
                leg_loc = leg_loc, lwd = lwd
            )
            graphics::par(mai = old_mai)
        })
    })
}

#### Demo function of the module #### ----------
#' @rdname plot_legend
#' @export
#' @importFrom utils data
#' @importFrom shiny shinyApp fluidPage reactive
plot_legend_demo <- function(height = "200px", leg_loc = c(0.2, 1, 0, 1)) {
    data_env <- new.env(parent = emptyenv())
    utils::data("sampleped", envir = data_env, package = "Pedixplorer")
    pedi <- shiny::reactive({
        Pedigree(
            data_env[["sampleped"]][data_env[["sampleped"]]$famid == "1", ]
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
