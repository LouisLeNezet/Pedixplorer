#' @rdname plot_ped
#' @importFrom shiny NS tagList uiOutput checkboxInput
plot_ped_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::tagList(
        shiny::uiOutput(ns("uiplot"))
    )
}

#' Internal function to generate the plot
#'
#' This function is used by the Shiny module to generate the plot.
#' If the `interactive` argument is set to TRUE, it generates an interactive
#' plot using `plotly`. If it is set to FALSE, it generates a static
#' plot function.
#'
#' @param pedi A pedigree object.
#' @param cex A numeric to set the size of the text.
#' @param plot_par A list of parameters to pass to the plot
#' function.
#' @param interactive A boolean to set if the plot is interactive.
#' @param mytitle A string to set the title of the plot.
#' @param precision An integer to set the precision of the plot.
#' @param lwd A numeric to set the line width of the plot.
#' @param aff_mark A boolean to set if the affected individuals
#' should be marked.
#' @param label A string to set the label of the plot.
#' @param symbolsize A numeric to set the size of the symbols.
#' @param force A boolean to set if the plot should be forced.
#' @param mytips A character vector of the column names of the data frame
#' to use as tooltips. If NULL, no tooltips are added.
#' @return A function or a plotly object.
#' @examples
#' data("sampleped")
#' pedi <- Pedigree(sampleped[sampleped$famid == "1", ])
#' app_plot_fct(
#'    pedi, cex = 1, plot_par = list(),
#'    interactive = FALSE,
#'    mytitle = "My Pedigree",
#'    precision = 2, lwd = 1
#' )
#' @rdname plot_ped
#' @keywords internal
#' @importFrom plotly ggplotly layout config
#' @importFrom ggplot2 theme
app_plot_fct <- function(
    pedi, cex = 1, plot_par = list(), interactive = FALSE,
    mytitle = "My Pedigree", precision = 2, lwd = 1,
    aff_mark = TRUE, label = NULL,
    symbolsize = 1, force = TRUE, mytips = NULL
) {
    if (interactive) {
        p <- plot(
            pedi, ggplot_gen = interactive,
            aff_mark = TRUE, label = NULL,
            cex = cex, symbolsize = symbolsize, force = force,
            ped_par = plot_par,
            title = mytitle, tips = mytips,
            precision = precision, lwd = lwd
        )$ggplot +
            ggplot2::theme(legend.position = "none")
        plotly::ggplotly(p, tooltip = "text") |>
            plotly::layout(hoverlabel = list(bgcolor = "darkgrey")) |>
            plotly::config(responsive = TRUE, autosizable = TRUE)
    } else {
        function() {
            plot(
                pedi, ggplot_gen = interactive,
                aff_mark = TRUE, label = NULL,
                cex = cex, symbolsize = symbolsize, force = force,
                ped_par = plot_par,
                title = mytitle, tips = mytips,
                precision = precision, lwd = lwd
            )
        }
    }
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
#' @param my_title A string to name the plot.
#' @param precision An integer to set the precision of the plot.
#' @param max_ind An integer to set the maximum number of individuals to plot.
#' @param my_tips A character vector of the column names of the data frame
#' to use as tooltips. If NULL, no tooltips are added.
#' @param plot_lwd A numeric to set the line width of the plot.
#' @param width A numeric to set the width of the plot.
#' @param height A numeric to set the height of the plot.
#' @param plot_cex A numeric to set the size of the text.
#' @param symbolsize A numeric to set the size of the symbols.
#' @param force A boolean to set if the plot should be forced.
#' @param plot_par A list of parameters to pass to the plot
#' function.
#' @param is_interactive A boolean to set if the plot is interactive.
#' @param aff_mark A boolean to set if the affected individuals
#' should be marked.
#' @param label A string to set the label of the plot.
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
    id, pedi, my_title = NA, precision = 2,
    my_tips = NULL, plot_lwd = 1,
    width = "80%", height = "400px", plot_cex = 1, symbolsize = 1,
    force = TRUE, plot_par = list(), is_interactive = FALSE,
    aff_mark = TRUE, label = NULL
) {
    stopifnot(shiny::is.reactive(pedi))
    shiny::moduleServer(id, function(input, output, session) {
        ns <- session$ns

        ## Plot parameters
        my_title <- makeReactive(my_title)
        my_tips <- makeReactive(my_tips)
        plot_cex <- makeReactive(plot_cex)
        plot_par <- makeReactive(plot_par)
        is_interactive <- makeReactive(is_interactive)
        symbolsize <- makeReactive(symbolsize)
        precision <- makeReactive(precision)
        aff_mark <- makeReactive(aff_mark)
        label <- makeReactive(label)
        plot_lwd <- makeReactive(plot_lwd)
        is_force <- makeReactive(force)

        ## Plot dimensions
        width <- makeReactive(width)
        height <- makeReactive(height)

        my_plot_fct <- shiny::reactive({
            shiny::req(pedi())
            shiny::req(symbolsize(), plot_cex(), plot_lwd())
            app_plot_fct(
                pedi = pedi(), mytitle = my_title(), mytips = my_tips(),
                cex = plot_cex(), plot_par = plot_par(),
                symbolsize = symbolsize(),
                interactive = is_interactive(),
                precision = precision(), lwd = plot_lwd(),
                aff_mark = aff_mark(), label = label(),
                force = is_force()
            )
        })

        is_ready <- reactive({
            !is.null(width()) && !is.null(height()) &&
                !is.na(width()) && !is.na(height()) &&
                width() > 0 && height() > 0
        })

        output$plotly_output <- plotly::renderPlotly({
            shiny::req(is_interactive(), is_ready())
            shiny::req(symbolsize())
            my_plot_fct()
        })

        output$plot_output <- shiny::renderPlot({
            shiny::req(my_plot_fct())
            shiny::req(is_ready())
            my_plot_fct()()
        })

        output$uiplot <- shiny::renderUI({
            shiny::req(is_ready())
            shiny::req(symbolsize(), plot_cex(), plot_lwd())
            print("Plotting")
            if (is_interactive()) {
                plotly::plotlyOutput(
                    ns("plotly_output"),
                    width = width(),
                    height = height()
                ) %>%
                    shinycssloaders::withSpinner(color = "#8aca25")
            } else {
                print("Static plotting")
                shiny::plotOutput(
                    ns("plot_output"),
                    width = width(),
                    height = height()
                ) %>%
                    shinycssloaders::withSpinner(color = "#8aca25")
            }
        })

        shiny::reactive({
            list(
                plot = my_plot_fct(),
                class = class(my_plot_fct())
            )
        })
    })
}

#' @rdname plot_ped
#' @export
#' @importFrom shiny shinyApp fluidPage
plot_ped_demo <- function(
    pedi = NULL, precision = 4,
    interactive = FALSE
) {
    ui <- shiny::fluidPage(
        useToastr(),
        plot_ped_ui("plotped"),
        plot_download_ui("saveped")
    )

    if (is.null(pedi)) {
        data_env <- new.env(parent = emptyenv())
        utils::data("sampleped", envir = data_env, package = "Pedixplorer")
        pedi <- shiny::reactive({
            Pedigree(data_env[["sampleped"]][
                data_env[["sampleped"]]$famid == "1",
            ])
        })
    }

    server <- function(input, output, session) {
        lst_ped_plot <- plot_ped_server(
            "plotped",
            pedi = pedi,
            my_title = "My Pedigree",
            precision = precision,
            is_interactive = interactive
        )
        plot_fct <- shiny::reactive({
            lst_ped_plot()$plot
        })
        class <- shiny::reactive({
            lst_ped_plot()$class
        })
        plot_download_server(
            "saveped", plot_fct, plot_class = class
        )
    }
    shiny::shinyApp(ui, server)
}
