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
#' @include app_utils.R
#' @include app_server.R
#' @include app_plot_all.R
#' @usage NULL
#' @returns `shiny::shinyUI()`
#' @examples
#' if (interactive()) {
#'     ped_shiny()
#' }
#' @export
ped_ui <- function() {
    logo  <- paste0(
        "https://github.com/LouisLeNezet/Pedixplorer/",
        "raw/devel/inst/figures/"
    )
    shiny::shinyUI(shiny::fluidPage(
        ## Configuration -------------------------------
        shiny::tags$head(
            shiny::tags$style(shiny::HTML(
                "hr {border-top: 2px solid #3792ad;}
                .navigationBar{background-color:#0001; margin-top: 10px;}
                .title {margin-top: 85px; font-style: italic; font-size: 50px;}
                .titlehr {border-top: 4px solid #8aca25; margin-top: 100px}
                .title2 {margin-left: 30px; font-size: 20px;}"
            )),
        ),
        ## Application title --------------------------
        shiny::fluidRow(
            tags$a(
                href = "https://github.com/LouisLeNezet/Pedixplorer",
                target = "_blank",
                tags$img(
                    src = paste0(logo, "icon_github.png"),
                    title = "Github repository",
                    alt = "Github repository",
                    width = "50px", height = "50px"
                )
            ),
            tags$a(
                href = "https://doi.org/doi:10.18129/B9.bioc.Pedixplorer",
                target = "_blank",
                tags$img(
                    src = paste0(logo, "icon_bioconductor.png"),
                    title = "Bioconductor page",
                    alt = "Bioconductor page",
                    width = "50px", height = "50px"
                )
            ),
            tags$a(
                href = "https://louislenezet.github.io/Pedixplorer/",
                target = "_blank",
                tags$img(
                    src = paste0(logo, "icon_documentation.png"),
                    title = "Package documentation",
                    alt = "Package documentation",
                    width = "50px", height = "50px"
                )
            ),
            tags$a(
                href = "https://doi.org/10.1093/bioinformatics/btaf329",
                target = "_blank",
                tags$img(
                    src = paste0(logo, "icon_doi.png"),
                    title = "Pedixplorer article",
                    alt = "Pedixplorer article",
                    width = "50px", height = "50px"
                )
            ),
            tags$div(
                style = paste0(
                    "position: absolute; top: 10px; ",
                    "right: 20px; z-index: 9999;"
                ),
                uiOutput("help_main"),
            )
        ),
        shiny::fluidRow(
            shiny::column(2, align = "center",
                shiny::tags$div(class = "titlehr")
            ),
            shiny::column(6, align = "center",
                shiny::tags$div(class = "title", shiny::titlePanel(
                    "Pedigree creation, filtering and plotting",
                    windowTitle = "Pedixplorer"
                ))
            ),
            shiny::column(2, align = "center",
                shiny::tags$figure(
                    class = "centerFigure",
                    shiny::tags$img(
                        src = paste0(logo, "icon_Pedixplorer.png"),
                        height = 200,
                        alt = "Pedixplorer logo"
                    ),
                )
            ),
            shiny::column(2,
                shiny::tags$div(class = "titlehr")
            )
        ),
        ## Navigation bar -----------------------------
        shiny::fluidRow(title = "Navigation", class = "navigationBar",
            shiny::br(),
            ## ___Data and Family selection -------------
            shiny::column(2, data_import_ui(id = "data_ped_import")),
            shiny::column(6, data_col_sel_ui(
                id = "data_ped_col_sel", ui_col_nb = 3
            )),
            shiny::column(2, data_import_ui(id = "data_rel_import")),
            shiny::column(2, data_col_sel_ui(
                id = "data_rel_col_sel", ui_col_nb = 1
            ))
        ),
        ## Errors download ----------------------------
        shiny::fluidRow(title = "Errors download",
            align = "center",
            shiny::uiOutput("download_errors")
        ),
        shiny::hr(),
        ## Family and Health selection ---------------------------
        shiny::fluidRow(title = "Health and Family selection",
            shiny::tags$div(
                class = "title2",
                shiny::h2("Health and Family selection")
            ), shiny::column(
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
            shiny::tags$div(
                class = "title2",
                shiny::h2("Informative and subfamily selection")
            ),
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
        ## Plotting pedigree ----------------------------
        shiny::hr(),
        shiny::fluidRow(
            plot_all_ui("all_plot_ped")
        )
    ))
}
