# This module was created during the
# St Jude Bio-Hackathon of May 2023 by the team 13.
# author: Max Qiu (ytqiuhaowen@gmail.com)
# author: Louis Le Nézet (louislenezet@gmail.com)

#### Library needed #### ----------
usethis::use_package("ggplot2")
usethis::use_package("shiny")
usethis::use_package("htmlwidgets")
usethis::use_package("R3port")

#### UI function of the module #### ----------
#' Export plot ui module
#'
#' @description R Shiny module UI to export plot
#'
#' @details This module allow to export multiple type of plot.
#' The file type currently supported are png, pdf and html.
#' The UI ask the user for the file type to export to, the
#' width and the height of the plot to generate.
#' When the plot is generated with plotly, set is_plotly to TRUE
#' and export it to html.
#'
#' @param id A string.
#' @returns A Shiny UI.
#' @export
plot_download_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::tagList(shiny::uiOutput(ns("btn_dwld")))
}

#### Server function of the module #### ----------
#' Export plot server module
#'
#' @description R Shiny module server to export plot
#'
#' @details This module allow to export multiple type of plot.
#' The file type currently supported are png, pdf and html.
#' The UI ask the user for the file type to export to, the
#' width and the height of the plot to generate.
#' When the plot is generated with plotly, set is_plotly to TRUE
#' and export it to html.
#'
#' @param id A string.
#' @param my_plot Reactive object containing the plot.
#' @returns A Shiny UI.
#' @export
plot_download_server <- function(
    id, my_plot, filename = "saveplot",
    label = "Download", width = 500, height = 500, ext = "png"
) {
    stopifnot(shiny::is.reactive(my_plot))
    shiny::moduleServer(id, function(input, output, session) {
        ns <- shiny::NS(id)

        filename <- shiny::reactive({
            if (shiny::is.reactive(filename)) {
                filename()
            } else {
                filename
            }
        })

        ## Options rendering selection --------------------
        opt <- shiny::reactiveValues(width = width, height = height, ext = ext)

        output$btn_dwld <- shiny::renderUI({
            shiny::actionButton(
                ns("download"), label = label, icon("download"),
                style = "simple", size = "sm"
            )
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
                    shiny::actionButton(ns("close"), "Close", icon("close")),
                )
            ))
        })

        # Store the information if the user clicks close
        shiny::observeEvent(input$close, {
            shiny::removeModal()
            opt$width <- input$width
            opt$height <- input$height
            opt$ext <- input$ext
        })


        output$plot_dwld <- shiny::downloadHandler(filename = function() {
            paste(filename(), input$ext, sep = ".")
        }, content = function(file) {
            if (input$ext == "html") {
                if ("ggplot" %in% class(my_plot())) {
                    plot_html <- ggplotly(my_plot())
                } else if ("htmlwidget" %in% class(my_plot())) {
                    htmlwidgets::saveWidget(file = file, my_plot())
                } else {
                    showNotification(
                        "HTML file should be exported from ggplot or htmlwidget",
                        session = session
                    )
                    NULL
                }
            } else {
                
                if ("ggplot" %in% class(my_plot())) {
                    
                    ggplot2::ggsave(
                        filename = file, plot = my_plot(),
                        device = input$ext,
                        width = input$width, height = input$height
                    )
                } else if ("htmlwidget" %in% class(my_plot()) | "plotly" %in% class(my_plot())) {
                    showNotification(
                        "htmlwidgets should be exported as html",
                        session = session
                    )
                    NULL
                } else {
                    if (input$ext == "png") {
                        png(filename = file, width = input$width,
                            height = input$height)
                    } else if (input$ext == "pdf") {
                        pdf(file = file, width = input$width / 96,
                            height = input$height / 96)
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
                    dev.off()
                }
            }
        })
    })
}

plot_download_demo <- function() {
    plot_fct <- function() {
        data("sampleped")
        Pedigree(sampleped)
    }
    ui <- shiny::fluidPage(plotOutput("plt"), plot_download_ui("dwld"), )
    server <- function(input, output, session) {

        my_plot <- shiny::reactive({
            plot_fct()
        })

        plot_download_server("dwld", shiny::reactive({
            my_plot()
        }))
        output$plt <- shiny::renderPlot({
            plot(my_plot())
        })
    }
    shiny::shinyApp(ui, server)
}
