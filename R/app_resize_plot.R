resize_plot_ui <- function(id) {
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
        shiny::uiOutput(ns("resized_plot"))
    )
}

resize_plot_server <- function(
    id, plot_ui_fn, init_width = 600, init_height = 400
) {
    shiny::moduleServer(id, function(input, output, session) {
        ns <- session$ns
        dims <- reactiveValues(width = init_width, height = init_height)

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
            dims$width <- debounced_dims()$width
            dims$height <- debounced_dims()$height
        })

        output$resized_plot <- shiny::renderUI({
            shinyjqui::jqui_resizable(
                tags$div(
                    id = ns("resizable_plot"),
                    style = paste0(
                        "width:", dims$width, "px; height:",
                        dims$height, "px; overflow: hidden;"
                    ),
                    plot_ui_fn(ns("inner_plot"))
                )
            )
        })

        reactive({
            list(
                width = debounced_dims()$width,
                height = debounced_dims()$height
            )
        })
    })
}

resize_plot_demo <- function(interactive = FALSE) {
    ui <- shiny::fluidPage(
        useToastr(),
        resize_plot_ui("resize_plot"),
        plot_download_ui("saveped"),
        shiny::verbatimTextOutput("dims")
    )

    mydf <- data.frame(x = rnorm(100), y = rnorm(100))

    server <- function(input, output, session) {
        # Launch the resizing wrapper
        dims <- resize_plot_server(
            "resize_plot",
            plot_ui_fn = plot_ui,
            init_width = 800,
            init_height = 400
        )

        width <- shiny::reactive({
            dims()$width
        })
        height <- shiny::reactive({
            print("Changed dimension")
            print(dims()$height)
            dims()$height
        })

        # Use those dimensions inside your plot
        lst_plot <- plot_server(
            "resize_plot-inner_plot",
            my_data = mydf,
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

        output$dims <- renderPrint({
            dims()
        })
    }

    shiny::shinyApp(ui, server)
}
