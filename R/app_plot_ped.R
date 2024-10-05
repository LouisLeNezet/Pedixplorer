# This module was created during the
# St Jude Bio-Hackathon of May 2023 by the team 13.
# Author: Louis Le Nézet (louislenezet@gmail.com)

#### UI function of the module #### ----------
#' @rdname plot_ped
#' @importFrom shiny NS tagList uiOutput checkboxInput
plot_ped_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::tagList(
        shiny::uiOutput(ns("computebig")),
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
#' @param precision An integer to set the precision of the plot.
#' @param max_ind An integer to set the maximum number of individuals to plot.
#' @returns A reactive ggplot or the pedigree object.
#' @examples
#' if (interactive()) {
#'     data("sampleped")
#'     pedi <- shiny::reactive({
#'         Pedigree(sampleped[sampleped$famid == "1", ])
#'     })
#'     plot_ped_demo(pedi)
#' }
#' @rdname plot_ped
#' @keywords internal
#' @importFrom shiny is.reactive NS moduleServer reactive renderUI req
#' @importFrom shiny tagList checkboxInput plotOutput
#' @importFrom ggplot2 scale_y_reverse theme element_blank
#' @importFrom plotly ggplotly renderPlotly plotlyOutput
plot_ped_server <- function(
    id, pedi, title, precision = 2,
    max_ind = 500, lwd = par("lwd")
) {
    stopifnot(shiny::is.reactive(pedi))
    shiny::moduleServer(id, function(input, output, session) {

        ns <- shiny::NS(id)

        mytitle <- shiny::reactive({
            if (shiny::is.reactive(title)) {
                title <- title()
            }
            title
        })

        output$computebig <- shiny::renderUI({
            shiny::req(pedi())
            if (length(pedi()) > max_ind) {
                shiny::tagList(
                    shiny::checkboxInput(
                        ns("computebig"),
                        label = paste(
                            "There are too many individuals",
                            "to compute the plot.",
                            "Do you want to continue?"
                        ), value = FALSE
                    )
                )
            }
        })

        pedi_val <- shiny::reactive({
            shiny::req(pedi())
            if (length(pedi()) > max_ind) {
                if (is.null(input$computebig) || input$computebig == FALSE) {
                    return(NULL)
                }
            }
            pedi()
        })

        plotly_ped <- shiny::reactive({
            shiny::req(input$interactive)
            shiny::req(pedi_val())
            ped_plot_lst <- plot(
                pedi_val(),
                aff_mark = TRUE, label = NULL, ggplot_gen = input$interactive,
                cex = 1, symbolsize = 1, force = TRUE,
                mar = c(0.5, 0.5, 1.5, 0.5), title = mytitle(),
                precision = precision, lwd = lwd
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
                plotly::plotlyOutput(ns("ped_plotly"), height = "700px")
            } else {
                output$ped_plot <- shiny::renderPlot({
                    shiny::req(pedi_val())
                    plot(
                        pedi_val(),
                        aff_mark = TRUE, label = NULL,
                        cex = 1, symbolsize = 1, force = TRUE,
                        mar = c(0.5, 0.5, 1.5, 0.5), title = mytitle(),
                        precision = precision, lwd = lwd
                    )
                })
                shiny::plotOutput(ns("ped_plot"), height = "700px")
            }
        })

        plot_ped <- shiny::reactive({
            if (input$interactive) {
                return(plotly_ped())
            } else {
                return(pedi_val())
            }
        })
        return(plot_ped)
    })
}

#### Demo function of the module #### ----------
#' @rdname plot_ped
#' @export
#' @importFrom shiny shinyApp fluidPage
plot_ped_demo <- function(pedi, precision = 2, max_ind = 500) {
    ui <- shiny::fluidPage(
        plot_ped_ui("plot_ped"),
        plot_download_ui("saveped")
    )
    server <- function(input, output, session) {
        ped_plot <- plot_ped_server(
            "plot_ped", pedi,
            "My Pedigree", max_ind = max_ind,
            precision = precision
        )
        plot_download_server("saveped", ped_plot)
    }
    shiny::shinyApp(ui, server)
}
