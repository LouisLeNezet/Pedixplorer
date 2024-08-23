#' @importFrom shiny NS tagList h3 uiOutput numericInput
#' @importFrom shiny h5 strong checkboxInput selectInput
usethis::use_package("shiny")

#' @rdname inf_sel
inf_sel_ui <- function(id) {
    ns <- shiny::NS(id)
    tagList(
        ## Informative individuals selection ----------------------------------
        h3("Informative individuals"),
        uiOutput(ns("inf_var_selector")),
        uiOutput(ns("inf_custvar_selector")),
        uiOutput(ns("inf_custvar_textinput")),
        ## Filtering options --------------------------------------------------
        h3("Filtering options"),
        numericInput(
            ns("kin_max"),
            label = h5(strong("Max kinship")),
            value = 3, min = 1
        ),
        checkboxInput(
            ns("keep_parents"),
            label = "Keep informative parents (available or affected)",
            value = TRUE
        )
    )
}


#' Shiny module to select the informative individuals in a pedigree
#'
#' This module allows to select informative individuals in a pedigree object.
#' They will be used to subset the pedigree object with the function
#' `useful_inds()`. Further filtering options are available (max kinship and
#' keep parents).
#' The function is composed of two parts: the UI and the server.
#' The UI is called with the function `inf_sel_ui()` and the server
#' with the function `inf_sel_server()`.
#'
#' @param id A string to identify the module.
#' @param pedi A reactive pedigree object.
#' @return A reactive pedigree object subselected from the
#' informative individuals.
#' @examples
#' if (interactive()) {
#'     inf_sel_demo()
#' }
#' @rdname inf_sel
#' @keywords internal
inf_sel_server <- function(id, pedi) {
    stopifnot(shiny::is.reactive(pedi))
    ns <- shiny::NS(id)
    shiny::moduleServer(id, function(input, output, session) {

        # Informative individuals custom selection ----------------------------
        output$inf_var_selector <- renderUI({
            selectInput(
                ns("inf_selected"),
                label = h5(strong("Select informative individuals")),
                choices = list(
                    "All individuals" = "All",
                    "Available or Affected" = "AvOrAf",
                    "Available only" = "Av",
                    "Affected only" = "Af",
                    "Available and Affected" = "AvAf",
                    "Custom" = "Cust"
                ), selected = "All"
            )
        })

        # Custom variable selector --------------------------------------------
        output$inf_custvar_selector <- renderUI({
            shiny::req(pedi())
            shiny::req(input$inf_selected == "Cust")
            df <- as.data.frame(ped(pedi()))
            if (input$inf_selected == "Cust" & !is.null(df)) {
                col_present <- colnames(df)
                selectInput(
                    ns("inf_custvar_sel"),
                    label = paste(
                        "Select Variable to use",
                        "to select informative individuals"
                    ), choices = as.list(setNames(col_present, col_present))
                )
            } else {
                NULL
            }
        })

        # Custom variable text input ------------------------------------------
        output$inf_custvar_textinput <- renderUI({
            shiny::req(input$inf_selected == "Cust")
            if (input$inf_selected == "Cust") {
                shiny::textAreaInput(
                    ns("inf_custvar_val"), label = h5("Custom selection"),
                    placeholder = paste(
                        "Please enter individuals",
                        "values separate by a comma"
                    )
                )
            } else {
                NULL
            }
        })
        # Informative individuals selection -----------------------------------
        inf_inds_selected <- reactive({
            shiny::req(pedi())
            shiny::req(input$inf_selected)
            if (input$inf_selected != "Cust") {
                return(input$inf_selected)
            }
            shiny::req(input$inf_custvar_sel)
            shiny::req(input$inf_custvar_val)
            inf_custvar_sel <- input$inf_custvar_sel
            inf_custvar_val <- unlist(strsplit(input$inf_custvar_val, ","))
            df <- as.data.frame(ped(pedi()))
            val_sel <- as.character(df[, inf_custvar_sel])
            val_sel[is.na(val_sel)] <- "NA"
            val_pres <- match(inf_custvar_val, val_sel)
            index <- which(val_sel %in% inf_custvar_val)
            if (any(is.na(val_pres))) {
                showNotification(paste(
                    "Values",
                    paste0(inf_custvar_val[is.na(val_pres)], collapse = ", "),
                    "not present in", inf_custvar_sel
                ))
                NULL
            } else {
                df$id[index[!is.na(index)]]
            }
        })

        # Informative individuals selection text ------------------------------
        inf_inds_sel_txt <- function() {
            shiny::isolate({
                if (is.null(input$inf_selected)) {
                    return(NULL)
                }
                if (input$inf_selected == "Cust") {
                    paste(
                        "(id ",
                        paste(inf_inds_selected(), collapse = ", "),
                        ")", sep = ""
                    )
                } else {
                    inf_inds_selected()
                }
            })
        }

        # Informative individuals pedigree selection --------------------------
        lst_inf <- reactive({
            shiny::req(inf_inds_selected())
            list(
                inf_txt = inf_inds_sel_txt(),
                inf_sel = inf_inds_selected(),
                kin_max = input$kin_max,
                keep_parents = input$keep_parents
            )
        })

        return(lst_inf)
    })
}


#' @rdname inf_sel
#' @export
inf_sel_demo <- function() {
    pedi <- shiny::reactive({
        Pedigree(
            Pedixplorer::sampleped[Pedixplorer::sampleped$famid == "1", ]
        )
    })
    ui <- shiny::fluidPage(
        column(6,
            inf_sel_ui("infsel")
        ),
        column(6,
            uiOutput("inf")
        )
    )
    server <- function(input, output, session) {
        lst_inf <- inf_sel_server("infsel", pedi)
        output$inf <- renderUI({
            if (is.null(lst_inf())) {
                return(NULL)
            }
            txt <- ""
            for (i in names(lst_inf())) {
                txt <- paste(
                    txt, "<br/>", i, ":",
                    paste(lst_inf()[[i]], collapse = ",")
                )
            }
            HTML(txt)
        })
        shiny::exportTestValues(lst_inf = {
            lst_inf()
        })
    }
    shiny::shinyApp(ui, server)
}