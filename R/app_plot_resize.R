#' @rdname app_resize_plot
#' @importFrom shinyjs useShinyjs
#' @importFrom shiny tagList tags NS HTML uiOutput
plot_resize_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::tagList(
        shinyjs::useShinyjs(),
        shiny::tags$head(
            shiny::tags$script(shiny::HTML("
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
        shiny::uiOutput(ns("resized_plot"))
    )
}

#' Render a resizable plot in a Shiny app
#'
#' This function render a Shiny module into a resizable one.
#' It uses the `shinyjqui` package to make the plot resizable.
#'
#' @param id A string to identify the module.
#' @param plot_ui_fn A function to generate the UI of the plot.
#' @param init_width A string to set the initial width of the plot.
#' @param init_height A string to set the initial height of the plot.
#' @param interactive A boolean to indicate if the plot is interactive.
#' @return A reactive list containing the width and height of the plot.
#' @examples
#' if (interactive()) {
#'    plot_resize_demo(interactive = FALSE)
#' }
#' @export
#' @importFrom shiny debounce
#' @importFrom shinyjqui jqui_resizable
#' @rdname app_resize_plot
plot_resize_server <- function(
    id, plot_ui_fn, init_width = "80%", init_height = "400px"
) {
    shiny::moduleServer(id, function(input, output, session) {
        ns <- session$ns

        init_height <- make_reactive(init_height)
        init_width <- make_reactive(init_width)

        dims <- reactiveValues(width = NULL, height = NULL)

        shiny::observe({
            shiny::req(init_width(), init_height())
            dims$width <- init_width()
            dims$height <- init_height()
        })

        debounced_dims <- shiny::debounce(
            reactive(input$resizable_plot_size),
            millis = 300
        )

        observe({
            session$sendCustomMessage(
                "track_size", list(id = ns("resizable_plot"))
            )
        })

        observeEvent(debounced_dims(), {
            dims$width <- paste0(debounced_dims()$width, "px")
            dims$height <- paste0(debounced_dims()$height, "px")
        })

        output$resized_plot <- shiny::renderUI({
            shiny::req(dims$width, dims$height)
            shinyjqui::jqui_resizable(
                tags$div(
                    id = ns("resizable_plot"),
                    style = paste0(
                        "width:", dims$width,
                        "; height:", dims$height,
                        "; overflow: hidden;"
                    ),
                    plot_ui_fn(ns("inner_plot"))
                )
            )
        })

        shiny::reactive({
            list(
                width = debounced_dims()$width,
                height = debounced_dims()$height
            )
        })
    })
}

#' @rdname app_resize_plot
plot_resize_demo <- function(interactive = FALSE) {
    ui <- shiny::fluidPage(
        plot_resize_ui("resize_plot"),
        plot_download_ui("saveped"),
        shiny::verbatimTextOutput("dims")
    )

    data_env <- new.env(parent = emptyenv())
    utils::data("sampleped", envir = data_env, package = "Pedixplorer")
    pedi <- shiny::reactive({
        Pedigree(data_env[["sampleped"]][
            data_env[["sampleped"]]$famid == "1",
        ])
    })

    server <- function(input, output, session) {
        # Launch the resizing wrapper
        dims <- plot_resize_server(
            "resize_plot",
            plot_ui_fn = plot_ped_ui,
            init_width = 800,
            init_height = 400
        )

        width <- shiny::reactive({
            dims()$width
        })
        height <- shiny::reactive({
            dims()$height
        })

        # Use those dimensions inside your plot
        lst_plot <- plot_ped_server(
            "resize_plot-inner_plot",
            pedi = pedi,
            plot_cex = 2,
            width = width,
            height = height,
            is_interactive = interactive
        )

        plot_fct <- shiny::reactive({
            lst_plot()$plot
        })
        class <- shiny::reactive({
            lst_plot()$class
        })
        plot_download_server(
            "saveped", my_plot = plot_fct, plot_class = class,
            width = width, height = height
        )

        output$dims <- shiny::renderPrint({
            dims()
        })
    }

    shiny::shinyApp(ui, server)
}
