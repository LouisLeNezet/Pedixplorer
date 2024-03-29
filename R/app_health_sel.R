#' @importFrom shiny NS column div h5 uiOutput tagList renderUI selectInput
#' @importFrom shiny selectInput textOutput renderTable renderText tableOutput
NULL
usethis::use_package("shiny")

#' User interface of selecting health module
#'
#' @param id A string to identify the module.
#' @return A Shiny module UI.
#' @examples
#' health_sel_demo()
#' @export
health_sel_ui <- function(id) {
    ns <- shiny::NS(id)
    tagList(
        h3("Health selection"),
        uiOutput(ns("health_var_selector")),
        uiOutput(ns("health_num_box")),
        uiOutput(ns("health_threshold_box")),
        uiOutput(ns("health_aff_selector"))
    )
}

#' Server function of selecting health module
#'
#' @param id A string to identify the module.
#' @param df A reactive dataframe.
#' @return A reactive dataframe with the selected affection
#' @examples
#' health_sel_demo()
#' @export
#' @include app_utils.R
health_sel_server <- function(id, pedi) {
    stopifnot(shiny::is.reactive(pedi))
    ns <- shiny::NS(id)
    shiny::moduleServer(id, function(input, output, session) {

        # Health variable selector --------------------------------------------
        output$health_var_selector <- renderUI({
            if (is.null(pedi())) {
                return(NULL)
            }
            cols_all <- colnames(mcols(pedi()))
            selectInput(
                ns("health_var_sel"),
                label = h5("Select Variable to use as health indicator"),
                choices = as.list(setNames(cols_all, cols_all))
            )
        })

        # As numeric values ---------------------------------------------------
        output$health_num_box <- renderUI({
            shiny::req(input$health_var_sel)
            shiny::req(pedi())
            if (is.null(input$health_var_sel)) {
                return(NULL)
            }
            val_num <- ifelse(
                is.numeric(mcols(pedi())[[input$health_var_sel]]),
                TRUE, FALSE
            )
            checkboxInput(
                ns("health_num"),
                label = "Should the health variable be treated as numeric?",
                value = val_num
            )
        })

        # Values of the health variable ---------------------------------------
        val_aff <- shiny::reactive({
            shiny::req(pedi())
            shiny::req(input$health_var_sel)
            if (is.null(input$health_var_sel) | is.null(input$health_num)) {
                return(NULL)
            }
            health_df <- mcols(pedi())[[input$health_var_sel]]
            if (input$health_num) {
                health_df <- as.numeric(health_df)
            } else {
                health_df <- as.character(health_df)
            }
            health_df
        })

        # Threshold selection for numeric values ------------------------------
        output$health_threshold_box <- renderUI({
            shiny::req(input$health_num)
            if (input$health_num) {
                checkboxInput(
                    ns("health_threshold_sup"),
                    label = "Affected are strickly superior to threshold",
                    value = TRUE
                )
            } else {
                NULL
            }
        })

        # Affected individuals selection --------------------------------------
        output$health_aff_selector <- renderUI({
            if (is.null(input$health_num)) {
                return(NULL)
            }
            if (input$health_num) {
                min_h <- min(val_aff(), na.rm = TRUE)
                max_h <- max(val_aff(), na.rm = TRUE)
                if (any(is.na(c(min_h, max_h))) |
                        any(is.infinite(c(min_h, max_h)))) {
                    h5(paste(
                        "No value found for", input$health_var_sel
                    ))
                } else {
                    sliderInput(
                        ns("health_threshold_val"),
                        label = h5(paste(
                            "Threshold of",
                            input$health_var_sel,
                            "to determine affected individuals"
                        )),
                        sep = "'",
                        min = min_h,
                        max = max_h,
                        value = (max_h + min_h) / 2
                    )
                }
            } else {
                health_var_lev <- levels(as.factor(val_aff()))
                if (length(health_var_lev) == 0) {
                    h5(paste(
                        "No value found for", input$health_var_sel
                    ))
                }
                var_to_use <- as.list(setNames(
                    health_var_lev, health_var_lev
                ))
                shinyWidgets::pickerInput(
                    ns("health_aff_mods"),
                    label = "Selection of affected modalities",
                    choices = var_to_use,
                    options = list(`actions-box` = TRUE),
                    multiple = TRUE, selected = health_var_lev
                )
            }
        })

        # Return the selected health variable ---------------------------------
        lst_health <- shiny::reactive({
            if (is.null(input$health_var_sel) | is.null(input$health_num)) {
                return(NULL)
            }
            if (input$health_num) {
                threshold <- input$health_threshold_val
                threshold_sup <- input$health_threshold_sup
                mods_aff <- NULL
            } else {
                threshold <- NULL
                threshold_sup <- NULL
                mods_aff <- input$health_aff_mods
            }
            list(
                health_var = input$health_var_sel,
                to_num = input$health_num,
                mods_aff = mods_aff,
                threshold = threshold,
                threshold_sup = threshold_sup
            )
        })

        return(lst_health)
    })
}

#' Demo function of selecting health module
#' @examples
#' health_sel_demo()
health_sel_demo <- function() {
    data("sampleped")
    pedi <- Pedigree(sampleped)
    ui <- shiny::fluidPage(
        column(6,
            health_sel_ui("healthsel")
        ),
        column(6,
            htmlOutput("text")
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
            str1 <- paste("Selected health variable:", lst_health()$health_var)
            str2 <- paste("Is numeric:", lst_health()$to_num)
            str3 <- paste(
                "Affected modalities:",
                paste0(lst_health()$mods_aff, collapse = ", ")
            )
            str4 <- paste("Threshold:", lst_health()$threshold)
            str5 <- paste("Threshold strict:", lst_health()$threshold_sup)
            HTML(paste(str1, str2, str3, str4, str5, sep = '<br/>'))

        })
    }
    shiny::shinyApp(ui, server)
}
