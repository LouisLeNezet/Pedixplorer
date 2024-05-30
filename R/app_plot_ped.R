# This module was created during the
# St Jude Bio-Hackathon of May 2023 by the team 13.
# Author: Louis Le Nézet (louislenezet@gmail.com)


#### Library needed #### ----------
usethis::use_package("dplyr")
usethis::use_package("shiny")

#### Function to plot pedigree #### ----------
ped_plot <- function(
    ped, cex_plot = 1, mar = rep(0.5, 4), psize = par("pin"),
    tips_names = NA, to_plotly = FALSE,
    aff_mark = TRUE, label = NULL, title = NULL
) {

    if (class(ped) != "Pedigree") {
        return(NULL)
    }
    ped_plot_lst <- plot(
        ped,
        aff_mark = aff_mark, label = label, ggplot_gen = to_plotly,
        cex = cex_plot, symbolsize = 1,
        mar = mar, title = title
    ) # General Pedigree

    if (to_plotly) {
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
        p <- plotly::ggplotly(
            ggp +
                ggplot2::theme(legend.position = "none"),
            tooltip = "text"
        )
        return(p)
    } else {
        return(ped)
    }
}


#### UI function of the module #### ----------
# Documentation
#' R Shiny module to generate pedigree graph
#'
#' @param id A string.
#' @param df A dataframe containing the information about the individual to plot
#' @returns A Shiny module.
#' @examples
#' Pedigree_demo()
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
plot_ped_server <- function(id, ped, title) {
    stopifnot(shiny::is.reactive(ped))
    stopifnot(shiny::is.reactive(title))
    shiny::moduleServer(id, function(input, output, session) {

        ns <- shiny::NS(id)
        plot_ped <- shiny::reactive({
            if (is.null(ped()) | is.null(input$interactive)) {
                return(NULL)
            }
            return(
                ped_plot(
                    ped(), to_plotly = input$interactive, title = title(),
                    mar = c(0.5, 1, 0.5, 0.5)
                )
            )
        })
        output$plotpedi <- shiny::renderUI({
            if (is.null(input$interactive)) {
                return(NULL)
            }
            if (input$interactive) {
                output$ped_plotly <- plotly::renderPlotly({
                    plot_ped()
                })
                plotly::plotlyOutput(ns("ped_plotly"))
            } else {
                output$ped_plot <- shiny::renderPlot({
                    plot_ped()
                })
                shiny::plotOutput(ns("ped_plot"))
            }
        })

        return(plot_ped)
    })
}

#### Demo function of the module #### ----------
plot_ped_demo <- function() {
    data(sampleped)
    pedi <- Pedigree(sampleped[sampleped$famid == 1, ])
    ui <- shiny::fluidPage(
        plot_ped_ui("ped"),
        plot_download_ui("saveped")
    )
    server <- function(input, output, session) {
        plot_ped <- plot_ped_server("ped", shiny::reactive({
            pedi
        }), "My Pedigree")
        plot_download_server("saveped", plot_ped)
    }
    shiny::shinyApp(ui, server)
}
