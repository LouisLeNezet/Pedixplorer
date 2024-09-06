#' @importFrom shiny NS column div h5 uiOutput tagList renderUI selectInput
#' @importFrom shiny selectInput textOutput renderTable renderText tableOutput

usethis::use_package("shiny")


#' Sketch of the family information table
#'
#' Simple function to create a sketch of the family information table.
#'
#' @param var_name the name of the health variable
#' @return an html sketch of the family information table
#' @keywords internal, ped_avaf_infos
sketch <- function(var_name) {
    tags$table(
        class = "display",
        tags$style(HTML(".cell-border-right{border-right: 1px solid #000}")),
        tags$thead(
            tags$tr(
                tags$th(
                    class = "dt-center cell-border-right",
                    colspan = 2, var_name
                ),
                tags$th(
                    class = "dt-center",
                    colspan = 3, "Availability"
                )
            ),
            tags$tr(
                tags$th("Affected"),
                tags$th("Modalities"),
                tags$th("Available"),
                tags$th("Unavailable"),
                tags$th("NA")
            )
        )
    )
}


#' Affection and availability information table
#'
#' This function creates a table with the affection and availability
#' information for all individuals in a pedigree object.
#'
#' @param pedi A pedigree object.
#' @param col_val The column name in the `fill` slot
#' of the pedigree object to use for the table.
#' @return A cross table dataframe with the affection and availability
#' information.
#' @examples
#' pedi <- Pedigree(Pedixplorer::sampleped)
#' pedi <- generate_colors(pedi, "num_child_tot", threshold = 2)
#' Pedixplorer:::family_infos_table(pedi, "num_child_tot")
#' Pedixplorer:::family_infos_table(pedi, "affection")
#' @keywords internal, ped_avaf_infos
family_infos_table <- function(pedi, col_val = NA) {
    if (!col_val %in% fill(pedi)$column_values) {
        error <- paste(
            "The column value", col_val,
            "is not in the available column values"
        )
        stop(error)
    }
    aff <- fill(pedi)[fill(pedi)$column_values == col_val, ]
    df <- base::table(
        factor(avail(ped(pedi)), c(TRUE, FALSE)),
        mcols(pedi)[[unique(aff$column_mods)]],
        useNA = "always",
        dnn = c("Availability", "Affected")
    ) %>%
        as.data.frame() %>%
        tidyr::spread("Availability", "Freq")
    colnames(df) <- c("Affected", "TRUE", "FALSE", "NA")
    df$mods <- aff$labels[match(
        df$Affected, aff$mods
    )]
    df$Affected <- as.character(df$Affected)
    cols <- c("Affected", "mods", "TRUE", "FALSE", "NA")
    df[cols] <- lapply(df[cols],
        function(x) {
            x <- replace(x, is.na(x), "NA")
        }
    )
    return(df[cols])
}


#' @rdname family_sel
ped_avaf_infos_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::column(12,
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

        df <- shiny::reactive({
            shiny::req(pedi())
            col_val <- unique(fill(pedi())$column_values)[1]
            family_infos_table(pedi(), col_val)
        })

        # Display the family information table --------------------------------
        output$family_info_table <- DT::renderDataTable({
            shiny::req(pedi())
            if (!is.null(pedi())) {
                DT::datatable(
                    df(),
                    container = sketch(stringr::str_to_title(
                        colnames(df())[1]
                    )), rownames = FALSE, selection = "none",
                    options = list(
                        columnDefs = list(
                            list(targets = 1, className = "cell-border-right"),
                            list(targets = "_all", className = "dt-center")
                        ), dom = "t"
                    ),
                    fillContainer = TRUE
                )
            } else {
                NULL
            }
        })
        # Display the title ---------------------------------------------------
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

        return(df)
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
        df <- ped_avaf_infos_server(
            "familysel",
            shiny::reactive({
                pedi
            })
        )
        shiny::exportTestValues(df = {
            df()
        })
    }
    shiny::shinyApp(ui, server)
}
