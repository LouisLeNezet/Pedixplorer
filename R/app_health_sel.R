#' @rdname health_sel
#' @importFrom shiny NS uiOutput tagList
health_sel_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::tagList(
        shiny::h3("Health selection"),
        shiny::uiOutput(ns("health_var_selector")),
        shiny::uiOutput(ns("health_num_box")),
        shiny::uiOutput(ns("health_threshold_box")),
        shiny::uiOutput(ns("health_aff_selector"))
    )
}

#' Shiny module to select a health variable in a pedigree
#'
#' This module allows to select health variables in a pedigree object.
#' The function is composed of two parts: the UI and the server.
#' The UI is called with the function `health_sel_ui()` and the server
#' with the function `health_sel_server()`.
#'
#' @param id A string to identify the module.
#' @param pedi A reactive pedigree object.
#' @return A reactive list with the following informations:`actions-box`
#' - health_var: the selected health variable,
#' - to_num: a boolean to know if the health variable needs to be considered as
#' numeric,
#' - mods_aff: a character vector of the affected modalities,
#' - threshold: a numeric threshold to determine affected individuals,
#' - sup_threshold: a boolean to know if the affected individuals are strickly
#' superior to the threshold.
#' @examples
#' if (interactive()) {
#'     health_sel_demo()
#' }
#' @include app_utils.R
#' @rdname health_sel
#' @keywords internal
#' @importFrom shiny is.reactive NS moduleServer req reactive sliderInput
#' @importFrom shiny h5 checkboxInput selectInput htmlOutput renderUI
#' @importFrom shinyWidgets pickerInput
#' @importFrom stats setNames
health_sel_server <- function(
    id, pedi, var = NULL, as_num = NULL, mods_aff = NULL,
    threshold = NULL, sup_threshold = NULL
) {
    stopifnot(shiny::is.reactive(pedi))
    ns <- shiny::NS(id)
    shiny::moduleServer(id, function(input, output, session) {

        # Health variable selector --------------------------------------------
        output$health_var_selector <- shiny::renderUI({
            if (is.null(pedi())) {
                return(NULL)
            }
            cols_all <- colnames(mcols(pedi()))
            cols_all <- as.list(stats::setNames(cols_all, cols_all))
            shiny::selectInput(
                ns("health_var_sel"),
                label = h5("Select Variable to use as health indicator"),
                choices = cols_all,
                selected = var
            )
        })

        # As numeric values ---------------------------------------------------
        output$health_num_box <- shiny::renderUI({
            shiny::req(input$health_var_sel)
            shiny::req(pedi())
            if (is.null(input$health_var_sel)) {
                return(NULL)
            }
            val_num <- ifelse(
                is.numeric(mcols(pedi())[[input$health_var_sel]]),
                TRUE, FALSE
            )
            shiny::checkboxInput(
                ns("health_as_num"),
                label = "Should the health variable be treated as numeric?",
                value = ifelse(is.null(as_num), val_num, as_num)
            )
        })

        # Values of the health variable ---------------------------------------
        val_aff <- shiny::reactive({
            shiny::req(pedi())
            shiny::req(input$health_var_sel)
            if (is.null(input$health_var_sel) | is.null(input$health_as_num)) {
                return(NULL)
            }
            health_df <- mcols(pedi())[[input$health_var_sel]]
            if (input$health_as_num) {
                health_df <- as.numeric(health_df)
            } else {
                health_df <- as.character(health_df)
            }
            health_df
        })

        # Threshold selection for numeric values ------------------------------
        output$health_threshold_box <- renderUI({
            shiny::req(input$health_as_num)
            if (input$health_as_num) {
                shiny::checkboxInput(
                    ns("health_threshold_sup"),
                    label = "Affected are strickly superior to threshold",
                    value = ifelse(is.null(sup_threshold), TRUE, sup_threshold)
                )
            } else {
                NULL
            }
        })

        # Affected individuals selection --------------------------------------
        output$health_aff_selector <- renderUI({
            if (is.null(input$health_as_num)) {
                return(NULL)
            }
            if (input$health_as_num) {
                min_h <- min(val_aff(), na.rm = TRUE)
                max_h <- max(val_aff(), na.rm = TRUE)
                if (any(is.na(c(min_h, max_h))) |
                        any(is.infinite(c(min_h, max_h)))) {
                    shiny::h5(paste(
                        "No value found for", input$health_var_sel
                    ))
                } else {
                    shiny::sliderInput(
                        ns("health_threshold_val"),
                        label = shiny::h5(paste(
                            "Threshold of",
                            input$health_var_sel,
                            "to determine affected individuals"
                        )),
                        sep = "'",
                        min = min_h,
                        max = max_h,
                        value = ifelse(
                            is.null(threshold),
                            (max_h + min_h) / 2,
                            threshold
                        )
                    )
                }
            } else {
                health_var_lev <- levels(as.factor(val_aff()))
                if (length(health_var_lev) == 0) {
                    h5(paste(
                        "No value found for", input$health_var_sel
                    ))
                }
                var_to_use <- as.list(stats::setNames(
                    health_var_lev, health_var_lev
                ))
                shinyWidgets::pickerInput(
                    ns("health_aff_mods"),
                    label = "Selection of affected modalities",
                    choices = var_to_use,
                    options = list(`actions-box` = TRUE),
                    multiple = TRUE, selected = ifelse(
                        is.null(mods_aff), health_var_lev, mods_aff
                    )
                )
            }
        })

        # Return the selected health variable ---------------------------------
        lst_health <- shiny::reactive({
            if (is.null(input$health_var_sel) | is.null(input$health_as_num)) {
                return(NULL)
            }
            if (input$health_as_num) {
                threshold <- input$health_threshold_val
                sup_threshold <- input$health_threshold_sup
                mods_aff <- NULL
            } else {
                threshold <- NULL
                sup_threshold <- NULL
                mods_aff <- input$health_aff_mods
            }
            list(
                var = input$health_var_sel,
                as_num = input$health_as_num,
                mods_aff = mods_aff,
                threshold = threshold,
                sup_threshold = sup_threshold
            )
        })

        return(lst_health)
    })
}

#' @rdname health_sel
#' @export
#' @importFrom shiny fluidPage column htmlOutput renderUI
#' @importFrom shiny shinyApp exportTestValues HTML
#' @importFrom utils data
health_sel_demo <- function() {
    data_env <- new.env(parent = emptyenv())
    utils::data("sampleped", envir = data_env, package = "Pedixplorer")
    pedi <- Pedigree(data_env[["sampleped"]])
    ui <- shiny::fluidPage(
        shiny::column(6,
            health_sel_ui("healthsel")
        ),
        shiny::column(6,
            shiny::htmlOutput("text")
        )
    )
    server <- function(input, output, session) {
        lst_health <- health_sel_server(
            "healthsel",
            shiny::reactive({
                pedi
            })
        )

        output$text <- renderUI({
            if (is.null(lst_health())) {
                return(NULL)
            }
            str1 <- paste("Selected health variable:", lst_health()$var)
            str2 <- paste("As numeric:", lst_health()$as_num)
            str3 <- paste(
                "Affected modalities:",
                paste0(lst_health()$mods_aff, collapse = ", ")
            )
            str4 <- paste("Threshold:", lst_health()$threshold)
            str5 <- paste("Threshold strict:", lst_health()$sup_threshold)
            shiny::HTML(paste(str1, str2, str3, str4, str5, sep = "<br/>"))
        })

        shiny::exportTestValues(lst_health = {
            lst_health()
        })
    }
    shiny::shinyApp(ui, server)
}
