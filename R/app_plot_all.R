#' @include app_plot_ped.R
#' @rdname app_plot_all
#' @importFrom shiny tagList tags NS HTML uiOutput
#' @importFrom shiny fluidRow column checkboxInput sliderInput
plot_all_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::tagList(
        shiny::tags$style(shiny::HTML(sprintf(
            "#%s.modified {
                background-color: #8aca25 !important;
                color: black;
                font-weight: bold;
            }
            ",
            ns("updateBtn")
        ))),
        tags$script(shiny::HTML(sprintf(
            "
            Shiny.addCustomMessageHandler('toggleBtnClass', function(message) {
                const btn = document.getElementById('%s');
                if (btn) {
                    btn.className = 'btn btn-default action-button ' +
                        message.class;
                }
            });
            ", ns("updateBtn")
        ))),
        shiny::fluidRow(
            shiny::column(3, align = "left",
                shiny::uiOutput(ns("computebig")),
                shiny::checkboxInput(
                    ns("computebest"),
                    label = "Improve alignment (takes time to compute)",
                    value = FALSE
                ),
                shiny::uiOutput(ns("uiTolerancebest")),
                shiny::uiOutput(ns("uiTimeoutbest")),
                shiny::checkboxInput(
                    ns("alignparents"),
                    label = "Both parents at same depth (not always possibe)",
                    value = TRUE
                ),
            ),
        ),
        shiny::fluidRow(
            shiny::column(12, align = "center",
                shiny::uiOutput(ns("uiUpdateBtn")),
                plot_resize_ui(ns("resize_plot")),
            )
        ),
        shiny::fluidRow(
            shiny::column(3, align = "left",
                shiny::checkboxInput(
                    ns("interactive"),
                    label = "Make the pedigree interactive", value = FALSE
                ),
                shiny::uiOutput(ns("col_sel_tips")),
                shiny::sliderInput(
                    ns("symbolsize"),
                    "Symbole size:", min = 0.2, max = 2, value = 1, step = 0.2,
                    ticks = FALSE
                ),
                shiny::sliderInput(
                    ns("plot_lwd"),
                    "Line width:", min = 0.2, max = 2, value = 1, step = 0.2,
                    ticks = FALSE
                )
            ),
            shiny::column(3, align = "center",
                plot_download_ui(ns("saveped")),
                data_download_ui(ns("plot_data_dwnl"))
            ),
            shiny::column(6, align = "center",
                plot_legend_ui(ns("legend"), "350px")
            )
        ),
    )
}

#' Shiny module with all the components to plot a pedigree
#'
#' This module plots a Pedigree object and allows to download
#' the plot and the data. Different options are available to
#' customize the plot.
#'
#' @param id A string to identify the module.
#' @param pedi A reactive pedigree object.
#' @param max_ind An integer to define the maximum number of individuals
#' to plot. If the number of individuals is greater than this value,
#' the user will be asked to confirm the plot.
#' @param my_title_l A string to define the title of the plot.
#' @param my_title_s A string to define the title of the plot for
#' the download.
#' @param init_width A string to define the initial width of the plot.
#' @param precision An integer to define the precision of the plot.
#' @return A reactive list with the plot and the class of the plot.
#' @examples
#' if (interactive()) {
#'    app_plot_all_demo()
#' }
#' @rdname app_plot_all
#' @include app_plot_ped.R
#' @include app_plot_legend.R
#' @include app_plot_download.R
#' @include app_plot_resize.R
#' @include app_plot_download.R
#' @importFrom shiny moduleServer reactiveValues renderUI
#' @importFrom shiny req actionButton observe bindEvent
#' @importFrom shiny eventReactive
#' @importFrom shiny renderPrint
#' @keywords internal
plot_all_server <- function(
    id, pedi, max_ind = 100, my_title_l = "My Pedigree",
    my_title_s = "ped_1", init_width = "100%",
    precision = 4
) {
    shiny::moduleServer(id, function(input, output, session) {
        ns <- session$ns

        my_title_l <- make_reactive(my_title_l)
        my_title_s <- make_reactive(my_title_s)

        opt <- shiny::reactiveValues(
            pedi = NULL,
            my_tips = NULL,
            symbolsize = NULL,
            is_interactive = NULL,
            width = NULL,
            height = NULL,
            plot_lwd = NULL,
            my_title_l = NULL,
            computebest = NULL,
            tolerancebest = NULL,
            alignparents = NULL,
            timeoutbest = NULL
        )

        reset_opt <- function(opt) {
            opt$pedi <- NULL
            opt$my_tips <- NULL
            opt$symbolsize <- NULL
            opt$is_interactive <- NULL
            opt$width <- NULL
            opt$height <- NULL
            opt$plot_lwd <- NULL
            opt$plot_cex <- NULL
            opt$my_title_l <- NULL
            opt$computebest <- NULL
            opt$tolerancebest <- NULL
            opt$alignparents <- NULL
            opt$timeoutbest <- NULL
        }

        max_err <- shiny::reactive({
            shiny::req(pedi())
            round(compute_stress(
                pedi(),
                NULL,
                wt = c(1000, 10, 1),
                align_parents = input$alignparents,
                force = TRUE
            ))
        })

        output$uiTolerancebest <- shiny::renderUI({
            shiny::req(pedi())
            if (input$computebest) {
                shiny::sliderInput(
                    ns("tolerancebest"),
                    "Tolerance for best alignment:",
                    min = 0, max = max_err()[1],
                    value = 5, step = 1, ticks = FALSE
                ) |>
                    shinyhelper::helper(
                        type = "markdown",
                        content = "app_plot_tolerance",
                        size = "m",
                        colour = "#3792ad"
                    )
            }
        })

        output$uiTimeoutbest <- shiny::renderUI({
            shiny::req(pedi())
            if (input$computebest) {
                shiny::sliderInput(
                    ns("timeoutbest"),
                    "Maximum bext_hint time (sec)",
                    min = 10, max = 200, value = 60,
                    ticks = FALSE
                ) |>
                    shinyhelper::helper(
                        type = "markdown",
                        content = "app_plot_timeout",
                        size = "m",
                        colour = "#3792ad"
                    )
            }
        })

        ## Update button -----------------------------
        output$uiUpdateBtn <- shiny::renderUI({
            shiny::actionButton(
                ns("updateBtn"), "Update Plot"
            )
        })
        shiny::observe({
            session$sendCustomMessage(
                "toggleBtnClass",
                list(class = "modified")
            )
        }) |>
            shiny::bindEvent(
                pedi(), width(), height(),
                input$interactive, input$symbolsize,
                input$plot_lwd, input$plot_cex,
                input$computebig, input$computebest,
                input$tips_col, input$plot_par,
                input$tolerancebest, input$alignparents,
                my_title_l(), input$timeoutbest
            )

        init_height <- shiny::reactive({
            shiny::req(pedi())
            paste0(max(kindepth(pedi())) * 200 + 20, "px")
        })

        dims <- plot_resize_server(
            "resize_plot",
            plot_ui_fn = plot_ped_ui,
            init_width = init_width,
            init_height = init_height
        )

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

        pedi_compute <- shiny::reactive({
            shiny::req(pedi())
            shiny::req(length(ped(pedi())) > 0)
            if (length(pedi()) > max_ind) {
                if (is.null(input$computebig) || input$computebig == FALSE) {
                    reset_opt(opt)
                    return(NULL)
                }
            }
            pedi()
        })

        pedi_val <- shiny::reactive({
            shiny::req(pedi_compute())
            shiny::req(length(ped(pedi_compute())) > 0)
            session$sendCustomMessage(
                "toggleBtnClass",
                list(class = "")
            )
            pedi()
        }) |>
            shiny::bindEvent(input$updateBtn)

        data_subfam <- shiny::reactive({
            shiny::req(pedi_val())
            Pedixplorer::as.data.frame(ped(pedi_val()))
        })

        output$col_sel_tips <- renderUI({
            shiny::req(data_subfam())
            all_cols <- colnames(data_subfam())
            select <- c("affected", "avail", "status")
            select <- select[select %in% all_cols]

            if (!is.null(opt$my_tips)) {
                select <- opt$my_tips[opt$my_tips %in% all_cols]
            }

            shiny::selectInput(
                ns("tips_col"),
                label = "Select columns for tips",
                choices = all_cols, selected = select,
                multiple = TRUE
            ) |>
                shinyhelper::helper(
                    type = "markdown",
                    content = "app_plot_tips",
                    size = "m",
                    colour = "#3792ad"
                )
        })

        ## Plot pedigree -----------------------------------
        shiny::observe({
            opt$pedi <- pedi_val()
            opt$my_tips <- input$tips_col
            opt$symbolsize <- input$symbolsize
            opt$is_interactive <- input$interactive
            opt$width <- width()
            opt$height <- height()
            opt$plot_lwd <- input$plot_lwd
            opt$my_title_l <- my_title_l()
            opt$computebest <- input$computebest
            opt$tolerancebest <- input$tolerancebest
            opt$alignparents <- input$alignparents
            opt$timeoutbest <- input$timeoutbest
        }) |>
            shiny::bindEvent(input$updateBtn)

        lst_ped_plot <- plot_ped_server(
            "resize_plot-inner_plot",
            pedi = reactive(opt$pedi),
            my_title = reactive(opt$my_title_l),
            my_tips = reactive(opt$my_tips),
            symbolsize = reactive(opt$symbolsize),
            is_interactive = reactive(opt$is_interactive),
            width = reactive(opt$width),
            height = reactive(opt$height),
            precision = precision,
            plot_lwd = reactive(opt$plot_lwd),
            computebest = reactive(opt$computebest),
            tolerance = reactive(opt$tolerancebest),
            align_parents = reactive(opt$alignparents),
            force = TRUE, timeout = reactive(opt$timeoutbest)
        )

        ## Plot legend ------------------------------------------------
        plot_legend_server(
            "legend", reactive(opt$pedi),
            boxw = 0.02, boxh = 0.08, adjx = 0, adjy = 0,
            leg_loc = c(0.1, 0.7, 0.1, 0.8), lwd = 1.5
        )

        plot_fct <- shiny::reactive({
            shiny::req(pedi_val())
            lst_ped_plot()$plot
        })
        class <- shiny::reactive({
            lst_ped_plot()$class
        })
        plot_download_server(
            "saveped", plot_fct, plot_class = class,
            width = width, height = height,
            label = "Download plot", filename = my_title_s
        )

        ## Download data and plot ---------------------------------------------
        data_download_server("plot_data_dwnl",
            data_subfam, label = "Download data",
            filename = my_title_s,
            helper = FALSE, title = NULL
        )

        shiny::reactive({
            list(
                df = data_subfam()
            )
        })

    })
}

#' @rdname app_plot_all
app_plot_all_demo <- function() {
    ui <- fluidPage(
        titlePanel("Nested Module Plot Demo"),
        plot_all_ui("allplotped")
    )

    data_env <- new.env(parent = emptyenv())
    utils::data("sampleped", envir = data_env, package = "Pedixplorer")
    pedi <- shiny::reactive({
        Pedigree(data_env[["sampleped"]][
            data_env[["sampleped"]]$famid == "1",
        ])
    })

    server <- function(input, output, session) {
        plot_all_server("allplotped", pedi, max_ind = 10)
    }

    shinyApp(ui, server)
}
