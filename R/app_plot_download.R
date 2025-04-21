#' @rdname plot_download
#' @importFrom shiny NS uiOutput
plot_download_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::uiOutput(ns("btn_dwld"))
}

#' Shiny module to export plot
#'
#' This module allow to export multiple type of plot from a reactive object.
#' The file type currently supported are png, pdf and html.
#' The function is composed of two parts: the UI and the server.
#' The UI is called with the function `plot_download_ui()` and the server
#' with the function `plot_download_server()`.
#'
#' @param id A string.
#' @param my_plot Reactive object containing the plot or the plot function.
#' @param plot_class A string to define the class of the plot
#' ("ggplot", "htmlwidget", "plotly", "grob" or "function").
#' @param filename A string to name the file.
#' @param label A string to name the download button.
#' @param width A numeric to set the width of the plot.
#' @param height A numeric to set the height of the plot.
#' @return A shiny module to export a plot.
#' @examples
#' if (interactive()) {
#'     plot_download_demo()
#' }
#' @rdname plot_download
#' @keywords internal
#' @importFrom shiny is.reactive NS moduleServer reactive reactiveValues
#' @importFrom shiny renderUI actionButton observeEvent showModal removeModal
#' @importFrom shiny modalDialog tags numericInput radioButtons tagList
#' @importFrom shiny downloadButton downloadHandler icon
#' @importFrom plotly ggplotly
#' @importFrom htmlwidgets saveWidget
#' @importFrom shinytoastr toastr_error
#' @importFrom ggplot2 ggsave
#' @importFrom grDevices png pdf dev.off
#' @importFrom gridExtra grid.arrange
plot_download_server <- function(
    id, my_plot, plot_class, filename = "saveplot",
    label = "Download", width = 500, height = 500
) {
    shiny::moduleServer(id, function(input, output, session) {
        ns <- session$ns

        my_plot <- make_reactive(my_plot)
        filename <- make_reactive(filename)
        width <- make_reactive(width)
        height <- make_reactive(height)
        plot_class <- make_reactive(plot_class)

        ## Options rendering selection --------------------
        opt <- shiny::reactiveValues(
            width = NULL,
            height = NULL,
            class = NULL
        )

        observe({
            opt$width <- width()
            opt$height <- height()
            opt$class <- plot_class()
        })

        output$btn_dwld <- shiny::renderUI({
            shiny::actionButton(
                ns("download"), label = label, shiny::icon("download"),
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
            if (
                "htmlwidget" %in% opt$class |
                    "plotly" %in% opt$class
            ) {
                ext_list <- c("html")
            } else if ("ggplot" %in% opt$class) {
                ext_list <- c("html", "png", "pdf", "svg")
            } else {
                ext_list <- c("png", "pdf", "svg")
            }
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
                    choices = ext_list, selected = ext_list[1]
                ),
                footer = shiny::tagList(
                    shiny::downloadButton(ns("plot_dwld"), label = label),
                    shiny::actionButton(ns("close"), "Close", icon("close"))
                )
            ))
        })

        output$plot_dwld <- shiny::downloadHandler(
            filename = function() {
                paste(filename(), input$ext, sep = ".")
            }, content = function(file) {
                if (input$ext == "html") {
                    if ("htmlwidget" %in% opt$class) {
                        htmlwidgets::saveWidget(file = file, my_plot())
                    } else if ("ggplot" %in% opt$class) {
                        plot_html <- plotly::ggplotly(my_plot())
                        htmlwidgets::saveWidget(file = file, plot_html)
                    } else {
                        shinytoastr::toastr_error(
                            title = "Error in plot type selected",
                            paste(
                                "HTML file should be exported",
                                "from ggplot or htmlwidget"
                            )
                        )
                    }
                } else {
                    if ("ggplot" %in% opt$class) {
                        ggplot2::ggsave(
                            filename = file, plot = my_plot(),
                            device = input$ext, units = "px",
                            width = input$width, height = input$height
                        )
                    } else if (
                        "htmlwidget" %in% opt$class |
                            "plotly" %in% opt$class
                    ) {
                        shinytoastr::toastr_error(
                            title = "Error in plot type selected",
                            "htmlwidgets should be exported as html"
                        )
                        NULL
                    } else {
                        if (input$ext == "png") {
                            grDevices::png(filename = file, width = input$width,
                                height = input$height, units = "px"
                            )
                        } else if (input$ext == "pdf") {
                            grDevices::pdf(
                                file = file, width = input$width / 72,
                                height = input$height / 72
                            )
                        }  else if (input$ext == "svg") {
                            grDevices::svg(
                                file = file, width = input$width / 96,
                                height = input$height / 96
                            )
                        } else {
                            shinytoastr::toastr_error(
                                title = "Error in plot type selected",
                                paste(
                                    "Other type of plot should be",
                                    "exported as pdf or png"
                                )
                            )
                            NULL
                        }
                        if ("grob" %in% opt$class) {
                            gridExtra::grid.arrange(my_plot())
                        } else if ("function" %in% opt$class) {
                            my_plot()()
                        } else {
                            my_plot()
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
#' @importFrom utils data
#' @importFrom shiny fluidPage fluidRow plotOutput reactive renderPlot
#' @importFrom shiny shinyApp
plot_download_demo <- function() {
    data_env <- new.env(parent = emptyenv())
    utils::data("sampleped", envir = data_env, package = "Pedixplorer")
    plot_fct_sp <- function() {
        c(1, 2, 3, 4, 5)
    }
    plot_fct_ped <- function() {
        Pedigree(data_env[["sampleped"]])
    }
    ui <- shiny::fluidPage(
        shiny::fluidRow(
            shiny::plotOutput("plt_sp"),
            plot_download_ui("dwld_sp")
        ),
        shiny::fluidRow(
            shiny::plotOutput("plt_ped"),
            plot_download_ui("dwld_ped")
        ),
        shiny::fluidRow(
            shiny::plotOutput("plt_ggplot"),
            plot_download_ui("dwld_ggplot")
        )
    )
    server <- function(input, output, session) {
        plot_ggplot <- shiny::reactive({
            plot(plot_fct_ped(), ggplot_gen = TRUE)$ggplot
        })

        output$plt_sp <- shiny::renderPlot({
            plot(plot_fct_sp())
        })

        output$plt_ped <- shiny::renderPlot({
            plot(plot_fct_ped())
        })

        output$plt_ggplot <- shiny::renderPlot({
            plot(plot_ggplot())
        })

        plot_download_server(
            "dwld_sp", plot_fct_sp, plot_class = "function"
        )
        plot_download_server(
            "dwld_ped", plot_fct_ped, plot_class = "function"
        )
        plot_download_server(
            "dwld_ggplot", plot_ggplot, plot_class = "ggplot"
        )
    }
    shiny::shinyApp(ui, server)
}
