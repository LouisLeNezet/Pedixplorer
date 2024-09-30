#' Create the user interface for the ped_shiny application
#' @importFrom shiny shinyUI fluidPage tags fluidRow column
#' @importFrom shiny titlePanel uiOutput hr h2
#' @include app_data_import.R
#' @include app_data_col_sel.R
#' @include app_data_download.R
#' @include app_ped_avaf_infos.R
#' @include app_family_sel.R
#' @include app_health_sel.R
#' @include app_color_picker.R
#' @include app_inf_sel.R
#' @include app_plot_ped.R
#' @include app_plot_download.R
#' @include app_utils.R
#' @include app_server.R
#' @include app_plot_legend.R
#' @usage NULL
#' @returns `shiny::shinyUI()`
#' @examples
#' if (interactive()) {
#'     ped_shiny()
#' }
#' @keywords internal
ped_ui <- function() {
    shiny::shinyUI(shiny::fluidPage(
        ## Configuration -------------------------------
        shiny::tags$head(
            shiny::tags$style(shiny::HTML(
                "hr {border-top: 1px solid #000000;}
                .navigationBar{background-color:#0001}"
            ))
        ),
        ## Application title --------------------------
        shiny::fluidRow(
            shiny::column(12, align = "center",
                shiny::titlePanel("Pedigree creation")
            )
        ),
        ## Navigation bar -----------------------------
        shiny::fluidRow(title = "Navigation", class = "navigationBar",
            ## ___Data and Family selection -------------
            shiny::column(2, data_import_ui(id = "data_ped_import")),
            shiny::column(6, data_col_sel_ui(id = "data_ped_col_sel")),
            shiny::column(2, data_import_ui(id = "data_rel_import")),
            shiny::column(2, data_col_sel_ui(id = "data_rel_col_sel"))
        ),
        ## Errors download ----------------------------
        shiny::fluidRow(title = "Errors download",
            align = "center",
            shiny::uiOutput("download_errors")
        ),
        shiny::hr(),
        ## Family and Health selection ---------------------------
        shiny::fluidRow(title = "Health and Family selection",
            shiny::h2("Health and Family selection"),
            shiny::column(
                2, align = "center",
                shiny::uiOutput("health_full_scale_box"),
                color_picker_ui("col_aff"),
                color_picker_ui("col_unaff"),
                color_picker_ui("col_avail")
            ),
            shiny::column(
                2, align = "center",
                health_sel_ui("health_sel")
            ),
            shiny::column(
                4, align = "center",
                family_sel_ui("family_sel")
            ),
            shiny::column(
                4, align = "center",
                ped_avaf_infos_ui("ped_avaf_infos")
            )
        ),
        shiny::hr(),
        ## Informative and subfamily selection ----------------------
        shiny::fluidRow(
            shiny::h2("Informative and subfamily selection"),
            shiny::column(4, align = "center",
                inf_sel_ui("inf_sel")
            ),
            ## Subfamily selection -------------------------
            shiny::column(4, align = "center",
                family_sel_ui("subfamily_sel")
            ),
            ## Subfamily information -----------------------
            shiny::column(4, align = "center",
                ped_avaf_infos_ui("subped_avaf_infos")
            )
        ),
        shiny::hr(),
        ## Plotting pedigree ----------------------------
        shiny::fluidRow(
            plot_ped_ui("ped"),
        ),
        shiny::fluidRow(
            shiny::column(4,
                plot_download_ui("saveped"),
                data_download_ui("plot_data_dwnl")
            ),
            shiny::column(8,
                plot_legend_ui("legend", "300px")
            )
        )
    ))
}
