#' @include app_plot_ped.R
app_plot_all_ui <- function(id) {
    ns <- shiny::NS(id)
    tagList(
        # Use ns() HERE (UI)
        shiny::uiOutput(ns("computebig")),
        resize_plot_ui(ns("resize_plot")),
        shiny::checkboxInput(
            ns("interactive"),
            label = "Make the pedigree interactive", value = FALSE
        ),
        plot_download_ui(ns("saveped")),
        shiny::verbatimTextOutput(ns("dims"))
    )
}

app_plot_all_server <- function(
    id, pedi, max_ind = 10,
    init_width = 800, init_height = 600
) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns
        # Use plain string HERE (SERVER)

        dims <- resize_plot_server(
            "resize_plot",
            plot_ui_fn = plot_ped_ui,
            init_width = init_width,
            init_height = init_height
        )

        output$dims <- renderPrint({
            dims()
        })

        width <- shiny::reactive({
            dims()$width
        })
        height <- shiny::reactive({
            dims()$height
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

        interactive <- reactive(input$interactive)
        lst_ped_plot <- plot_ped_server(
            "resize_plot-inner_plot",
            pedi = pedi_val, my_title = "Pedigree Plot",
            precision = 4,
            is_interactive = interactive,
            width = width,
            height = height
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
    })
}

app_plot_all_demo <- function() {
    ui <- fluidPage(
        titlePanel("Nested Module Plot Demo"),
        app_plot_all_ui("allplotped")  # 👈 module id
    )

    data_env <- new.env(parent = emptyenv())
    utils::data("sampleped", envir = data_env, package = "Pedixplorer")
    pedi <- shiny::reactive({
        Pedigree(data_env[["sampleped"]][
            data_env[["sampleped"]]$famid == "1",
        ])
    })

    server <- function(input, output, session) {
        app_plot_all_server("allplotped", pedi)
    }

    shinyApp(ui, server)
}
