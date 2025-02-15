#' @rdname family_sel
#' @importFrom shiny NS column uiOutput fluidRow
#' @importFrom DT dataTableOutput
family_sel_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::column(12,
        shiny::uiOutput(ns("title_fam")),
        shiny::uiOutput(ns("families_var_selector")),
        shiny::fluidRow(
            DT::dataTableOutput(ns("families_table"))
        ),
        shiny::uiOutput(ns("family_selector"))
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
#' @param title The title of the module.
#' @return A reactive list with the subselected pedigree object and the
#' selected family id.
#' @examples
#' if (interactive()) {
#'     family_sel_demo()
#' }
#' @include app_utils.R
#' @rdname family_sel
#' @keywords internal
#' @importFrom shiny is.reactive NS moduleServer req
#' @importFrom DT renderDataTable
#' @importFrom stats setNames
family_sel_server <- function(
    id, pedi,
    fam_var = NULL, fam_sel = NULL, title = "Family selection"
) {
    stopifnot(shiny::is.reactive(pedi))
    ns <- shiny::NS(id)
    shiny::moduleServer(id, function(input, output, session) {
        # Create the title ----------------------------------------------------
        output$title_fam <- renderUI({
            h3(title)
        })

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
            stats::setNames(col_sel, col_sel)
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

        reactive({
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
                    ped_fam = pedi()[famid(ped(pedi())) == family_sel],
                    famid = family_sel,
                    fam_sel = input$families_table_rows_selected,
                    fam_var = input$families_var_sel
                )
            } else {
                NULL
            }
        })
    })
}

#' @rdname family_sel
#' @export
#' @importFrom utils data
#' @importFrom shiny fluidPage column tableOutput reactive
#' @importFrom shiny renderTable exportTestValues shinyApp
family_sel_demo <- function(
    fam_var = NULL, fam_sel = NULL,
    title = "Family selection"
) {
    data_env <- new.env(parent = emptyenv())
    utils::data("sampleped", envir = data_env, package = "Pedixplorer")
    pedi <- Pedigree(data_env[["sampleped"]])
    ui <- shiny::fluidPage(
        shiny::column(6,
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
            }),
            fam_var, fam_sel, title
        )
        output$selected_fam <- shiny::renderTable({
            if (is.null(lst_fam())) {
                return(NULL)
            }
            ped(lst_fam()$ped_fam)
        })
        shiny::exportTestValues(lst_fam = {
            lst_fam()
        })
    }
    shiny::shinyApp(ui, server)
}
