# This module was created during the
# St Jude Bio-Hackathon of May 2023 by the team 13.
# Author: Louis Le Nézet (louislenezet@gmail.com)


#### Library needed #### ----------
#' @importFrom plotly ggplotly
usethis::use_package("dplyr")
usethis::use_package("shiny")
usethis::use_package("plotly")

#### UI function of the module #### ----------
#' @rdname plot_ped
plot_ped_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::tagList(
        shiny::uiOutput(ns("plotpedi")),
        shiny::checkboxInput(
            ns("interactive"),
            label = "Make the pedigree interactive", value = FALSE
        )
    )
}

#### Server function of the module #### ----------
#' Shiny module to generate pedigree graph.
#'
#' This module allows to plot a pedigree object. The plot can be interactive.
#' The function is composed of two parts: the UI and the server.
#' The UI is called with the function `plot_ped_ui()` and the server
#' with the function `plot_ped_server()`.
#'
#' @param id A string.
#' @param pedi A reactive pedigree object.
#' @param title A string to name the plot.
#' @returns A reactive ggplot or the pedigree object.
#' @examples
#' if (interactive()) {
#'     plot_ped_demo()
#' }
#' @rdname plot_ped
#' @keywords internal
plot_ped_server <- function(id, pedi, title) {
    stopifnot(shiny::is.reactive(pedi))
    shiny::moduleServer(id, function(input, output, session) {

        ns <- shiny::NS(id)

        mytitle <- shiny::reactive({
            if (is.reactive(title)) {
                title <- title()
            }
            title
        })

        plotly_ped <- shiny::reactive({
            shiny::req(input$interactive)
            shiny::req(pedi())
            ped_plot_lst <- plot(
                pedi(),
                aff_mark = TRUE, label = NULL, ggplot_gen = input$interactive,
                cex = 1, symbolsize = 1,
                mar = c(0.5, 0.5, 1.5, 0.5), title = mytitle()
            )

            ggp <- ped_plot_lst$ggplot + ggplot2::scale_y_reverse() +
                ggplot2::theme(
                    panel.grid.major =  ggplot2::element_blank(),
                    panel.grid.minor =  ggplot2::element_blank(),
                    axis.title.x =  ggplot2::element_blank(),
                    axis.text.x =  ggplot2::element_blank(),
                    axis.ticks.x =  ggplot2::element_blank(),
                    axis.ticks.y =  ggplot2::element_blank(),
                    axis.title.y =  ggplot2::element_blank(),
                    axis.text.y =  ggplot2::element_blank()
                )
            ## To make it interactive
            plotly::ggplotly(
                ggp +
                    ggplot2::theme(legend.position = "none"),
                tooltip = "text"
            )
        })
        output$plotpedi <- shiny::renderUI({
            if (is.null(input$interactive)) {
                return(NULL)
            }
            if (input$interactive) {
                output$ped_plotly <- plotly::renderPlotly({
                    plotly_ped()
                })
                plotly::plotlyOutput(ns("ped_plotly"))
            } else {
                output$ped_plot <- shiny::renderPlot({
                    shiny::req(pedi())
                    plot(
                        pedi(),
                        aff_mark = TRUE, label = NULL,
                        cex = 1, symbolsize = 1,
                        mar = c(0.5, 0.5, 1.5, 0.5), title = mytitle()
                    )
                })
                shiny::plotOutput(ns("ped_plot"))
            }
        })

        plot_ped <- shiny::reactive({
            if (input$interactive) {
                return(plotly_ped())
            } else {
                return(pedi())
            }
        })
        return(plot_ped)
    })
}

#### Demo function of the module #### ----------
#' @rdname plot_ped
#' @export
plot_ped_demo <- function() {
    pedi <- shiny::reactive({
        Pedigree(
            Pedixplorer::sampleped[Pedixplorer::sampleped$famid == 1, ]
        )
    })
    ui <- shiny::fluidPage(
        plot_ped_ui("ped"),
        plot_download_ui("saveped")
    )
    server <- function(input, output, session) {
        ped_plot <- plot_ped_server("ped", pedi, "My Pedigree")
        plot_download_server("saveped", ped_plot)
    }
    shiny::shinyApp(ui, server)
}
