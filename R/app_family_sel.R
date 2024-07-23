#' @importFrom shiny NS column div h5 uiOutput tagList renderUI selectInput
#' @importFrom shiny selectInput textOutput renderTable renderText tableOutput
#' @importFrom shiny numericInput showNotification reactive

usethis::use_package("shiny")

#' @rdname family_sel
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

#' Shiny module to select a family in a pedigree
#'
#' This module allows to select a family in a pedigree object.
#' The function is composed of two parts: the UI and the server.
#' The UI is called with the function `family_sel_ui()` and the server
#' with the function `family_sel_server()`.
#'
#' @param id A string to identify the module.
#' @param pedi A reactive pedigree object.
#' @return A reactive list with the subselected pedigree object and the
#' selected family id.
#' @examples
#' \dontrun{
#'     family_sel_demo()
#' }
#' @include app_utils.R
#' @rdname family_sel
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
        ), rownames = FALSE, filter = "top",
        selection = "single", server = TRUE)

        # Family selector -----------------------------------------------------
        #TODO : Set selection as DT row selection
        output$family_selector <- renderUI({
            if (is.null(families_df())) {
                return(NULL)
            }
            fam_nb <- as.numeric(families_df()$famid)
            if (all(is.na(fam_nb))) {
                showNotification("No family present (only unconnected individuals)")
                return(NULL)
            }
            if (max(fam_nb, na.rm = TRUE) > 0) {
                numericInput(
                    ns("family_sel"),
                    label = h5(strong("Select family to use")),
                    value = max(min(fam_nb, na.rm = TRUE), 1),
                    min = max(min(fam_nb, na.rm = TRUE), 1),
                    max = max(fam_nb, na.rm = TRUE)
                )
            } else {
                textOutput(
                    "No family present (only unconnected individuals)"
                )
            }
        })

        lst_fam <- reactive({
            print(input$families_table_rows_selected)
            if (is.null(input$family_sel)) {
                return(NULL)
            }
            if (input$family_sel > 0) {
                list(
                    ped_fam = suppressWarnings(
                        pedi()[famid(ped(pedi())) == input$family_sel]
                    ), famid = input$family_sel
                )
            } else {
                NULL
            }
        })
        return(lst_fam)
    })
}

#' @rdname family_sel
#' @export
family_sel_demo <- function() {
    pedi <- Pedigree(Pedixplorer::sampleped)
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
            if (is.null(lst_fam())) {
                return(NULL)
            }
            ped(lst_fam()$ped_fam)
        })
    }
    shiny::shinyApp(ui, server)
}
