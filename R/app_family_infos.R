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
family_infos_ui <- function(id) {
    ns <- shiny::NS(id)
    tagList(
        h3("Family information"),
        textOutput(ns("family_infos_title")),
        DT::dataTableOutput(ns("family_info_table"))
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
family_infos_server <- function(id, pedi) {
    stopifnot(shiny::is.reactive(pedi))
    ns <- shiny::NS(id)
    shiny::moduleServer(id, function(input, output, session) {
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
                    tidyr::spread(Availability, Freq)
                colnames(df) <- c("Affected", "TRUE", "FALSE", "NA")
                df$mods <- fill(pedi())$labels[match(
                    df$Affected, fill(pedi())$mods
                )]
                df$Affected <- as.character(df$Affected)
                DT::datatable(
                    df[c("Affected", "mods", "TRUE", "FALSE", "NA")] %>%
                        replace(is.na(.), "NA"),
                    container = sketch(unique(fill(pedi())$column_values)),
                    rownames = FALSE,
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
        output$family_infos_title <- renderText({
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

#' Demo function of selecting columns module
#' @examples
#' family_sel_demo()
family_infos_demo <- function() {
    data("sampleped")
    pedi <- Pedigree(sampleped[sampleped$famid == 1, ])
    ui <- shiny::fluidPage(
        column(6,
            family_infos_ui("familysel")
        ), column(6,
            shiny::tableOutput("selected_fam")
        )
    )
    server <- function(input, output, session) {
        family_infos_server(
            "familysel",
            shiny::reactive({
                pedi
            })
        )
    }
    shiny::shinyApp(ui, server)
}
