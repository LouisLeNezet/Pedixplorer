#' @importFrom shiny NS column div h5 uiOutput tagList renderUI selectInput
#' @importFrom shiny selectInput textOutput renderTable renderText tableOutput

usethis::use_package("shiny")

#' @rdname family_sel
ped_avaf_infos_ui <- function(id) {
    ns <- shiny::NS(id)
    tagList(
        uiOutput(ns("title_infos")),
        textOutput(ns("ped_avaf_infos_title")),
        DT::dataTableOutput(ns("family_info_table"))
    )
}

#' Shiny modules to display family information
#'
#' This module allows to display the health and availability data
#' for all individuals in a pedigree object.
#' The output is a datatable.
#' The function is composed of two parts: the UI and the server.
#' The UI is called with the function `ped_avaf_infos_ui()` and the server
#' with the function `ped_avaf_infos_server()`.
#'
#' @param id A string to identify the module.
#' @param pedi A reactive pedigree object.
#' @param title The title of the module.
#' @return A reactive dataframe with the selected columns renamed
#' to the names of cols_needed and cols_supl.
#' @examples
#' if (interactive()) {
#'     ped_avaf_infos_demo()
#' }
#' @include app_utils.R
#' @rdname ped_avaf_infos
#' @keywords internal
ped_avaf_infos_server <- function(id, pedi, title = "Family informations") {
    stopifnot(shiny::is.reactive(pedi))
    shiny::moduleServer(id, function(input, output, session) {
        # Create the title ----------------------------------------------------
        output$title_infos <- renderUI({
            h3(title)
        })

        # Display the family information table --------------------------------
        output$family_info_table <- DT::renderDataTable({
            shiny::req(pedi())
            if (!is.null(pedi())) {
                df <- base::table(
                    factor(avail(ped(pedi())), c(TRUE, FALSE)),
                    mcols(pedi())[[unique(fill(pedi())$column_mods)]],
                    useNA = "always",
                    dnn = c("Availability", "Affected")
                ) %>%
                    as.data.frame() %>%
                    tidyr::spread("Availability", "Freq")
                colnames(df) <- c("Affected", "TRUE", "FALSE", "NA")
                df$mods <- fill(pedi())$labels[match(
                    df$Affected, fill(pedi())$mods
                )]
                df$Affected <- as.character(df$Affected)
                cols <- c("Affected", "mods", "TRUE", "FALSE", "NA")
                df[cols] <- lapply(df[cols],
                    function(x) {
                        x <- replace(x, is.na(x), "NA")
                    }
                )
                DT::datatable(
                    df[cols],
                    container = sketch(unique(fill(pedi())$column_values)),
                    rownames = FALSE, selection = "none",
                    options = list(
                        columnDefs = list(
                            list(targets = "_all", className = "dt-center")
                        ), dom = "t"
                    )
                )
            } else {
                NULL
            }
        })
        # Display the title ----------------------------------------------------
        output$ped_avaf_infos_title <- renderText({
            if (!is.null(pedi())) {
                paste(
                    "Health & Availability data representation for family",
                    unique(famid(ped(pedi())))
                )
            } else {
                NULL
            }
        })
    })
}

#' @rdname ped_avaf_infos
#' @export
ped_avaf_infos_demo <- function() {
    pedi <- Pedigree(
        Pedixplorer::sampleped[Pedixplorer::sampleped$famid == 1, ]
    )
    ui <- shiny::fluidPage(
        ped_avaf_infos_ui("familysel")
    )
    server <- function(input, output, session) {
        ped_avaf_infos_server(
            "familysel",
            shiny::reactive({
                pedi
            })
        )
    }
    shiny::shinyApp(ui, server)
}
