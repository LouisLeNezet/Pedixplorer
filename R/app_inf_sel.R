
#' User interface of selecting health module
#'
#' @param id A string to identify the module.
#' @return A Shiny module UI.
#' @examples
#' inf_sel_demo()
#' @export
inf_sel_ui <- function(id) {
    ns <- shiny::NS(id)
    tagList(
        ## Informative individuals selection -----------------------------------
        h3("Informative individuals"),
        uiOutput(ns("inf_var_selector")),
        uiOutput(ns("inf_custvar_selector")),
        uiOutput(ns("inf_custvar_textinput")),
        ## Filtering options ---------------------------------------------------
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


#' Server function of selecting informative module
#'
#' @param id A string to identify the module.
#' @param df A reactive dataframe.
#' @return A reactive dataframe with the selected affection
#' @examples
#' inf_sel_demo()
#' @export
inf_sel_server <- function(id, pedi) {
    stopifnot(shiny::is.reactive(pedi))
    ns <- shiny::NS(id)
    shiny::moduleServer(id, function(input, output, session) {

        # Informative individuals custom selection -----------------------------
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

        # Custom variable selector ---------------------------------------------
        output$inf_custvar_selector <- renderUI({
            shiny::req(pedi())
            shiny::req(input$inf_selected == "Cust")
            df <- as.data.frame(ped(pedi()))
            if (input$inf_selected == "Cust" & !is.null(df)) {
                col_present <- colnames(df)
                selectInput(
                    ns("inf_custvar_sel"),
                    label = "Select Variable to use to select informative individuals",
                    choices = as.list(setNames(col_present, col_present))
                )
            } else {
                NULL
            }
        })

        # Custom variable text input -------------------------------------------
        output$inf_custvar_textinput <- renderUI({
            shiny::req(input$inf_selected == "Cust")
            if (input$inf_selected == "Cust") {
                textAreaInput(
                    ns("inf_custvar_val"), label = h5("Custom selection"),
                    placeholder = "Please enter individuals values separate by a comma"
                )
            } else {
                NULL
            }
        })
        # Informative individuals selection ------------------------------------
        inf_inds_selected <- reactive({
            shiny::req(pedi())
            shiny::req(input$inf_selected)
            if (input$inf_selected != "Cust") {
                return(input$inf_selected)
            }
            shiny::req(input$inf_custvar_val)

            if (!identical(input$inf_custvar_val, "")) {
                inf_custvar_sel <- input$inf_custvar_sel
                inf_custvar_val <- unlist(strsplit(input$inf_custvar_val, ","))

                df <- as.data.frame(ped(pedi()))
                index <- which(df[, inf_custvar_sel] %in% inf_custvar_val)
                if (any(is.na(index))) {
                    showNotification(paste(
                        "Values", inf_custvar_val[is.na(index)],
                        "not present in", inf_custvar_sel
                    ))
                    NULL
                } else {
                    df$id[index[!is.na(index)]]
                }
            } else {
                showNotification(
                    "Custom option selected but no individual id given"
                )
                NULL
            }
        })

        # Informative individuals selection text -------------------------------
        inf_inds_sel_txt <- function() {
            isolate({
                if (is.null(input$inf_selected)) {
                    return(NULL)
                }
                if (input$inf_selected == "Cust") {
                    paste(
                        input$InfCustVariable, "(id ",
                        paste(inf_inds_selected(), collapse = ","),
                        ")"
                    )
                } else {
                    inf_inds_selected()
                }
            })
        }

        # Informative individuals pedigree selection ---------------------------
        ped_inf <- reactive({
            shiny::req(inf_inds_selected())
            shiny::req(pedi())
            if (is.null(pedi()) | is.null(inf_inds_selected())) {
                return(NULL)
            }

            tryCatch({
                pedi_inf <- useful_inds(
                    pedi(), inf_inds_selected(),
                    input$keep_parents, reset = TRUE,
                    input$kin_max
                )
                list(
                    ped_inf = subset(
                        pedi_inf, useful(ped(pedi_inf)), del_parents = "both"
                    ),
                    inf_sel = inf_inds_sel_txt(),
                    kin_max = input$kin_max,
                    keep_parents = input$keep_parents
                )
            },
            error = function(e) {
                message(paste(
                    "Error when computing the filtered pedigree", e
                ))
                NULL
            })
        })

        return(ped_inf)
    })
}


#' Demo function of selecting health module
#' @examples
#' inf_sel_demo()
inf_sel_demo <- function() {
    data("sampleped")
    pedi <- Pedigree(sampleped[sampleped$famid == "1", ])
    ui <- shiny::fluidPage(
        column(6,
            inf_sel_ui("infsel")
        ),
        column(6,
            textOutput("inf"),
            tableOutput("ped_inf")
        )
    )
    server <- function(input, output, session) {
        ped_inf <- inf_sel_server(
            "infsel",
            shiny::reactive({
                pedi
            })
        )
        output$inf <- renderText({
            if (is.null(ped_inf())) {
                return(NULL)
            }
            paste(
                "Informative individuals are:",
                ped_inf()[["inf_sel"]]
            )
        })

        output$ped_inf <- renderTable({
            if (is.null(ped_inf())) {
                return(NULL)
            }
            pedi2 <- ped(ped_inf()[["ped_inf"]])
            pedi2 <- subset(pedi2, useful(pedi2), del_parents = "both")
            cols <- c(
                "id", "dadid", "momid",
                "avail", "affected",
                "kin", "isinf", "num_child_tot",
                "useful"
            )
            df <- as.data.frame(pedi2)[cols]
            df[order(-df$useful, df$kin), ]

        })
    }
    shiny::shinyApp(ui, server)
}