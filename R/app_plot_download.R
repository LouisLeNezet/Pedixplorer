# This module was created during the
# St Jude Bio-Hackathon of May 2023 by the team 13.
# author: Max Qiu (ytqiuhaowen@gmail.com)
# author: Louis Le Nézet (louislenezet@gmail.com)

#### Library needed #### ----------
#' @importFrom shiny NS icon
#' @importFrom plotly ggplotly
usethis::use_package("ggplot2")
usethis::use_package("shiny")
usethis::use_package("plotly")
usethis::use_package("htmlwidgets")
usethis::use_package("gridExtra")
usethis::use_package("grDevices")

#### UI function of the module #### ----------
#' @rdname plot_download
plot_download_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::tagList(shiny::uiOutput(ns("btn_dwld")))
}

#### Server function of the module #### ----------
#' Shiny module to export plot
#'
#' This module allow to export multiple type of plot from a reactive object.
#' The file type currently supported are png, pdf and html.
#' The function is composed of two parts: the UI and the server.
#' The UI is called with the function `plot_download_ui()` and the server
#' with the function `plot_download_server()`.
#'
#' @param id A string.
#' @param my_plot Reactive object containing the plot.
#' @param filename A string to name the file.
#' @param label A string to name the download button.
#' @param width A numeric to set the width of the plot.
#' @param height A numeric to set the height of the plot.
#' @param ext A string to set the extension of the file.
#' @examples
#' if (interactive()) {
#'     plot_download_demo()
#' }
#' @rdname plot_download
#' @keywords internal
plot_download_server <- function(
    id, my_plot, filename = "saveplot",
    label = "Download", width = 500, height = 500, ext = "png"
) {
    stopifnot(shiny::is.reactive(my_plot))
    shiny::moduleServer(id, function(input, output, session) {
        ns <- shiny::NS(id)

        ## Options rendering selection --------------------
        opt <- shiny::reactiveValues(width = width, height = height, ext = ext)

        output$btn_dwld <- shiny::renderUI({
            shiny::actionButton(
                ns("download"), label = label, icon("download"),
                style = "simple", size = "sm"
            )
        })

        # Store the information if the user clicks close
        shiny::observeEvent(input$close, {
            shiny::removeModal()
            opt$width <- input$width
            opt$height <- input$height
            opt$ext <- input$ext
        })

        shiny::observeEvent(input$download, {
            # display a modal dialog with a header, textinput and action buttons
            shiny::showModal(shiny::modalDialog(
                shiny::tags$h2("Select your options"),
                shiny::numericInput(
                    ns("width"), "Figure width (px)",
                    value = opt$width, min = 0, max = 20000
                ),
                shiny::numericInput(
                    ns("height"), "Figure height (px)",
                    value = opt$height, min = 0, max = 20000
                ),
                shiny::radioButtons(
                    ns("ext"), label = "Select the file type",
                    choices = list("png", "pdf", "html"), selected = opt$ext
                ),
                footer = shiny::tagList(
                    shiny::downloadButton(ns("plot_dwld"), label = label),
                    shiny::actionButton(ns("close"), "Close", icon("close"))
                )
            ))
        })

        output$plot_dwld <- shiny::downloadHandler(
            filename = function(){
                paste(filename, input$ext, sep = ".")
            }, content = function(file) {
                if (input$ext == "html") {
                    if ("ggplot" %in% class(my_plot())) {
                        plot_html <- plotly::ggplotly(my_plot())
                        htmlwidgets::saveWidget(file = file, plot_html)
                    } else if ("htmlwidget" %in% class(my_plot())) {
                        htmlwidgets::saveWidget(file = file, my_plot())
                    } else {
                        showNotification(
                            "HTML file should be exported from ggplot or htmlwidget",
                            session = session
                        )
                        
                    }
                } else {
                    if ("ggplot" %in% class(my_plot())) {
                        ggplot2::ggsave(
                            filename = file, plot = my_plot(),
                            device = input$ext, units = "px",
                            width = input$width, height = input$height
                        )
                    } else if (
                        "htmlwidget" %in% class(my_plot()) |
                            "plotly" %in% class(my_plot())
                    ) {
                        showNotification(
                            "htmlwidgets should be exported as html",
                            session = session
                        )
                        NULL
                    } else {
                        if (input$ext == "png") {
                            grDevices::png(filename = file, width = input$width,
                                height = input$height, units = "px"
                            )
                        } else if (input$ext == "pdf") {
                            grDevices::pdf(file = file, width = input$width / 96,
                                height = input$height / 96
                            )
                        } else {
                            showNotification(paste(
                                "Other type of plot should be",
                                "exported as pdf or png", session = session
                            ))
                            NULL
                        }
                        if ("grob" %in% class(my_plot())) {
                            gridExtra::grid.arrange(my_plot())
                        } else {
                            plot(my_plot())
                        }
                        grDevices::dev.off()
                    }
                }
            }
        )
    })
}

#' @rdname plot_download
#' @export
plot_download_demo <- function() {
    plot_fct_sp <- function() {
        c(1, 2, 3, 4, 5)
    }
    plot_fct_ped <- function() {
        Pedigree(Pedixplorer::sampleped)
    }
    ui <- shiny::fluidPage(
        fluidRow(
            plotOutput("plt_sp"),
            plot_download_ui("dwld_sp")
        ),
        fluidRow(
            plotOutput("plt_ped"),
            plot_download_ui("dwld_ped")
        ),
        fluidRow(
            plotOutput("plt_ggplot"),
            plot_download_ui("dwld_ggplot")
        )
    )
    server <- function(input, output, session) {

        plot_sp <- shiny::reactive({
            plot_fct_sp()
        })

        plot_ped <- shiny::reactive({
            plot_fct_ped()
        })

        plot_ggplot <- shiny::reactive({
            plot(plot_fct_ped(), ggplot_gen = TRUE)$ggplot
        })

        output$plt_sp <- shiny::renderPlot({
            plot(plot_sp())
        })

        output$plt_ped <- shiny::renderPlot({
            plot(plot_ped())
        })

        output$plt_ggplot <- shiny::renderPlot({
            plot(plot_ggplot())
        })

        plot_download_server("dwld_sp", plot_sp)
        plot_download_server("dwld_ped", plot_ped)
        plot_download_server("dwld_ggplot", plot_ggplot)
    }
    shiny::shinyApp(ui, server)
}
