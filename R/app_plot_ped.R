#' @rdname plot_ped
#' @importFrom shiny NS tagList uiOutput checkboxInput
plot_ped_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::tagList(
        shinyjs::useShinyjs(),
        tags$head(
            tags$script(HTML("
                Shiny.addCustomMessageHandler('track_size', function(message) {
                    const el = document.getElementById(message.id);
                    if (!el) return;
                    const resizeObserver = new ResizeObserver(entries => {
                        for (let entry of entries) {
                        const { width, height } = entry.contentRect;
                        Shiny.setInputValue(message.id + '_size', {
                            width: Math.round(width),
                            height: Math.round(height)
                        }, { priority: 'event' });
                        }
                    });
                    resizeObserver.observe(el);
                });
            "))
        ),
        shiny::uiOutput(ns("computebig")),
        shiny::uiOutput(ns("plotpedi")),
        shiny::checkboxInput(
            ns("interactive"),
            label = "Make the pedigree interactive", value = FALSE
        )
    )
}

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
#' @param tips A character vector of the column names of the data frame to use
#' as tooltips. If NULL, no tooltips are added.
#' @param lwd A numeric to set the line width of the plot.
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
#' @importFrom shinycssloaders withSpinner
plot_ped_server <- function(
    id, pedi, title = NA, precision = 2,
    max_ind = 500, tips = NULL, lwd = par("lwd"),
    width = 600, height = 400
) {
    stopifnot(shiny::is.reactive(pedi))
    shiny::moduleServer(id, function(input, output, session) {
        ns <- shiny::NS(id)
        cex <- 1
        symbolsize <- 1
        force <- TRUE
        ped_par <- list(mar = c(1, 1, 2, 1))

        dims <- reactiveValues(width = width, height = height)

        debounced_dims <- shiny::debounce(
            reactive(input$resizable_plot_size),
            millis = 300
        )

        observe({
            session$sendCustomMessage(
                "track_size",
                list(id = ns("resizable_plot"))
            )
        })

        observeEvent(debounced_dims(), {
            dims$width <- debounced_dims()$width
            dims$height <- debounced_dims()$height
        })

        mytips <- shiny::reactive({
            if (shiny::is.reactive(tips)) {
                tips <- tips()
            }
            tips
        })

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
            shiny::req(length(ped(pedi())) > 0)
            print("pedi_val")
            if (length(pedi()) > max_ind) {
                if (is.null(input$computebig) || input$computebig == FALSE) {
                    return(NULL)
                }
            }
            pedi()
        })

        plot_fct <- shiny::reactive({
            shiny::req(pedi_val())
            if (is.null(input$interactive)) {
                return(NULL)
            }
            shiny::req(length(ped(pedi())) > 0)
            function() {
                plot(
                    pedi_val(), ggplot_gen = input$interactive,
                    aff_mark = TRUE, label = NULL,
                    cex = cex, symbolsize = symbolsize, force = force,
                    ped_par = ped_par,
                    title = mytitle(), tips = mytips(),
                    precision = precision, lwd = lwd / 3
                )
            }
        })

        plotly_fct <- shiny::reactive({
            shiny::req(input$interactive)
            function() {
                plotly::ggplotly(
                    plot_fct()()$ggplot +
                        ggplot2::theme(legend.position = "none"),
                    tooltip = "text"
                ) %>%
                    plotly::layout(hoverlabel = list(bgcolor = "darkgrey"))
            }
        })

        output$ped_plotly <- renderPlotly({
            req(input$interactive)
            req(dims$width, dims$height)
            plotly_fct()()
        })

        output$ped_plot <- shiny::renderPlot({
            shiny::req(!input$interactive)
            shiny::req(dims$width, dims$height)
            plot_fct()()
        })

        output$plotpedi <- shiny::renderUI({
            shiny::req(dims)
            if (is.null(input$interactive)) {
                return(NULL)
            }
            if (input$interactive) {
                shinyjqui::jqui_resizable(
                    tags$div(
                        id = ns("resizable_plot"),
                        style = paste0(
                            "width:", dims$width, "px;",
                            "height:", dims$height, "px;"
                        ),
                        plotly::plotlyOutput(
                            ns("ped_plotly"),
                            width = dims$width,
                            height = dims$height
                        ) %>%
                            shinycssloaders::withSpinner(color = "#8aca25")
                    )
                )
            } else {
                shinyjqui::jqui_resizable(
                    tags$div(
                        id = ns("resizable_plot"),
                        style = paste0(
                            "width:", dims$width, "px;",
                            "height:", dims$height, "px;"
                        ),
                        shiny::plotOutput(
                            ns("ped_plot"),
                            width = dims$width,
                            height = dims$height
                        ) %>%
                            shinycssloaders::withSpinner(color = "#8aca25")
                    )
                )
            }
        }) |>
            shiny::bindEvent(
                input$interactive, debounced_dims(), ignoreNULL = TRUE
            )

        shiny::reactive({
            if (input$interactive) {
                myplot <- plotly_fct()
            } else {
                myplot <- plot_fct()
            }
            list(
                plot = myplot,
                width = dims$width,
                height = dims$height,
                class = class(myplot())
            )
        })
    })
}

#' @rdname plot_ped
#' @export
#' @importFrom shiny shinyApp fluidPage
plot_ped_demo <- function(
    pedi, precision = 4, max_ind = 500, tips = NULL
) {
    ui <- shiny::fluidPage(
        useToastr(),
        plot_ped_ui("plotped"),
        plot_download_ui("saveped"),
        shiny::verbatimTextOutput("dims")
    )

    server <- function(input, output, session) {
        lst_ped_plot <- plot_ped_server(
            "plotped",
            pedi = pedi, tips = tips,
            title = "My Pedigree", max_ind = max_ind,
            precision = precision
        )
        output$dims <- shiny::renderPrint({
            paste(
                "Width:", lst_ped_plot()$width,
                "| Height:", lst_ped_plot()$height
            )
        })
        ped_plot <- shiny::reactive({
            lst_ped_plot()$plot
        })
        width <- shiny::reactive({
            lst_ped_plot()$width
        })
        height <- shiny::reactive({
            lst_ped_plot()$height
        })
        class <- shiny::reactive({
            lst_ped_plot()$class
        })
        plot_download_server(
            "saveped", ped_plot, plot_class = class,
            width = width, height = height
        )
    }
    shiny::shinyApp(ui, server)
}
