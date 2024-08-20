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
#' @param fam_var The default family variable to use as family indicator.
#' @param fam_sel The default family to select.
#' @return A reactive list with the subselected pedigree object and the
#' selected family id.
#' @examples
#' \dontrun{
#'     family_sel_demo()
#' }
#' @include app_utils.R
#' @rdname family_sel
family_sel_server <- function(id, pedi, fam_var = NULL, fam_sel = NULL) {
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
            shiny::req(all_cols())
            selectInput(ns("families_var_sel"),
                label = h5("Select Variable to use as families indicator"),
                choices = all_cols(),
                selected = ifelse(is.null(fam_var), all_cols()[1], fam_var)
            )
        })

        # Families table rendering --------------------------------------------
        output$families_table <- DT::renderDataTable({
            families_df()
        }, options = list(
            paging = FALSE, scrollX = TRUE,
            scrollY = "200px", scrollCollapse = TRUE,
            dom = "t"
        ), rownames = FALSE, filter = "top",
        selection = list(
            mode = "single",
            selected = fam_sel
        ), server = TRUE
        )

        lst_fam <- reactive({
            shiny::req(input$families_var_sel)
            shiny::req(input$families_table_rows_selected)
            if (is.null(input$families_table_rows_selected)) {
                return(NULL)
            }
            if (input$families_table_rows_selected > 0) {
                family_sel <- families_df()$famid[
                    input$families_table_rows_selected
                ]
                list(
                    ped_fam = suppressWarnings(
                        pedi()[famid(ped(pedi())) == family_sel]
                    ),
                    famid = family_sel,
                    fam_sel = input$families_table_rows_selected,
                    fam_var = input$families_var_sel
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
family_sel_demo <- function(fam_var = NULL, fam_sel = NULL) {
    pedi <- Pedigree(Pedixplorer::sampleped)
    ui <- shiny::fluidPage(
        column(6,
            family_sel_ui("familysel")
        ), column(6,
            shiny::tableOutput("selected_fam")
        )
    )
    server <- function(input, output, session) {
        lst_fam1 <- family_sel_server(
            "familysel",
            shiny::reactive({
                pedi
            }),
            fam_var, fam_sel
        )
        output$selected_fam <- shiny::renderTable({
            if (is.null(lst_fam1())) {
                return(NULL)
            }
            ped(lst_fam1()$ped_fam)
        })
    }
    shiny::shinyApp(ui, server)
}
