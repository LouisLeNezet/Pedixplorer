#' @importFrom shiny NS column div h5 uiOutput tagList renderUI selectInput
#' @importFrom shiny selectInput textOutput renderTable renderText tableOutput
NULL
usethis::use_package("shiny")

#' User interface of selecting family module
#'
#' @param id A string to identify the module.
#' @return A Shiny module UI.
#' @examples
#' family_sel_demo()
#' @export
family_sel_ui <- function(id) {
    ns <- shiny::NS(id)
    tagList(
        h3("Family selection"),
        uiOutput(ns("families_var_selector")),
        fluidRow(
            DT::dataTableOutput(ns("families_table"), width = "500px")
        ),
        uiOutput(ns("family_selector"))
    )
}

#' Server function of selecting columns module
#'
#' @param id A string to identify the module.
#' @param df A reactive dataframe.
#' @param cols_needed A character vector of the mandatory columns.
#' @param cols_supl A character vector of the optional columns.
#' @param title A string to display in the selectInput.
#' @param na_omit A boolean to allow or not the selection of NA.
#' @return A reactive dataframe with the selected columns renamed
#' to the names of cols_needed and cols_supl.
#' @examples
#' family_sel_demo()
#' @export
#' @include app_utils.R
family_sel_server <- function(id, pedi) {
    stopifnot(shiny::is.reactive(pedi))
    ns <- shiny::NS(id)
    shiny::moduleServer(id, function(input, output, session) {
        # Get all columns for family identification ---------------------------
        all_cols <- reactive({
            if (is.null(pedi())) {
                return(NULL)
            }
            col_no <- c(
                "id", "dadid", "momid",
                "fatherid", "motherid"
            )
            col_all <- colnames(mcols(pedi()))
            col_av <- setdiff(col_all, col_no)
            col_sel <- c()
            for (col in col_av) {
                if (any(!is.na(mcols(pedi())[col]))) {
                    col_sel <- c(col_sel, col)
                }
            }
            col_sel
            setNames(col_sel, col_sel)
        })

        # Get families table --------------------------------------------------
        families_df <- reactive({
            shiny::req(input$families_var_sel)
            if (is.null(pedi())) {
                return(NULL)
            }
            get_families_table(
                as.data.frame(ped(pedi())),
                input$families_var_sel
            )
        })

        # Output section ------------------------------------------------------
        # Family variable mod selection ---------------------------------------
        output$families_var_selector <- renderUI({
            selectInput(ns("families_var_sel"),
                label = h5("Select Variable to use as families indicator"),
                choices = all_cols(),
                selected = all_cols()[1]
            )
        })

        # Families table rendering --------------------------------------------
        output$families_table <- DT::renderDataTable({
            families_df()
        }, options = list(
            paging = FALSE, scrollX = TRUE,
            scrollY = "200px", scrollCollapse = TRUE
        ), rownames = FALSE, filter = "top")

        # Family selector -----------------------------------------------------
        output$family_selector <- renderUI({
            if (is.null(families_df())) {
                return(NULL)
            }
            fam_nb <- as.numeric(families_df()$famid)
            if (max(fam_nb) > 0) {
                if (max(fam_nb) == 0) {
                    showNotification(
                        "No family present (only unconnected individuals)"
                    )
                    return(NULL)
                }
                numericInput(
                    ns("family_sel"),
                    label = h5(strong("Select family to use")),
                    value = max(min(fam_nb), 1),
                    min = max(min(fam_nb), 1),
                    max = max(fam_nb)
                )
            } else {
                textOutput(
                    "No family present (only unconnected individuals)"
                )
            }
        })

        lst_fam <- reactive({
            if (is.null(input$family_sel)) {
                return(NULL)
            }
            if (input$family_sel > 0) {
                list(
                    ped_fam = pedi()[famid(ped(pedi())) == input$family_sel],
                    famid = input$family_sel
                )
            } else {
                NULL
            }
        })
        return(lst_fam)
    })
}

#' Demo function of selecting columns module
#' @examples
#' family_sel_demo()
family_sel_demo <- function() {
    data("sampleped")
    pedi <- Pedigree(sampleped)
    ui <- shiny::fluidPage(
        column(6,
            family_sel_ui("familysel")
        ), column(6,
            shiny::tableOutput("selected_fam")
        )
    )
    server <- function(input, output, session) {
        lst_fam <- family_sel_server(
            "familysel",
            shiny::reactive({
                pedi
            })
        )
        output$selected_fam <- shiny::renderTable({
            if (is.null(ped_fam())) {
                return(NULL)
            }
            ped(lst_fam$ped_fam())
        })
    }
    shiny::shinyApp(ui, server)
}
