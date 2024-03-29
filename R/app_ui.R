usethis::use_package("shiny")
usethis::use_package("bootstrap")

#' @importFrom shiny tags fluidRow column titlePanel hr HTML h3 h5 pre NS
#' @importFrom shiny strong uiOutput textOutput tableOutput dataTableOutput
#' @importFrom shiny numericInput checkboxInput plotOutput
NULL

#' Define UI for the Pedigree exploration application
#' @return A shiny UI object
#' @export
#' @include app_data_import.R
#' @include app_data_col_sel.R
#' @include app_data_download.R
#' @include app_family_infos.R
#' @include app_family_sel.R
#' @include app_health_sel.R
#' @include app_inf_sel.R
#' @include app_plot_ped.R
#' @include app_plot_download.R
ped_ui <- shiny::shinyUI(shiny::fluidPage(
    ## Configuration -------------------------------
    shinyjs::useShinyjs(),
    tags$head(
        tags$style(HTML("hr {border-top: 1px solid #000000;}
                        .navigationBar{background-color:#0001;height:300px}
                        #console{max-height: 500px;overflow-y:auto;}
                        #legendToPlot{max-height:150px};")),
        tags$script(
            'Shiny.addCustomMessageHandler("scrollCallback",
                function(color) {
                var objDiv = document.getElementById("console");
                objDiv.scrollTop = objDiv.scrollHeight;
                }
        );
        var dimension = [0, 0];
        $(document).on("shiny:connected", function(e) {
            dimension[0] = window.innerWidth;
            dimension[1] = window.innerHeight;
            Shiny.onInputChange("dimension", dimension);
        });
        $(window).resize(function(e) {
            dimension[0] = window.innerWidth;
            dimension[1] = window.innerHeight;
            Shiny.onInputChange("dimension", dimension);
        });
        '
        )
    ),
    ## Application title --------------------------
    fluidRow(
        column(12, align = "center",
            titlePanel("Pedigree creation")
        )
    ),
    ## Navigation bar -----------------------------
    fluidRow(title = "Navigation", class = "navigationBar",
        ## ___Data and Family selection -------------
        column(2, data_import_ui(id = "data_ped_import")),
        column(6, data_col_sel_ui(id = "data_ped_col_sel")),
        column(2, data_import_ui(id = "data_rel_import")),
        column(2, data_col_sel_ui(id = "data_rel_col_sel"))
    ),
    hr(),
    ## Errors download ----------------------------
    fluidRow(title = "Errors download",
        align = "center",
        h3("Download errors"),
        column(6,
            h5(strong("Pedigree data errors")),
            data_download_ui(id = "ped_errors")
        ),
        column(6, align = "center",
            h5(strong("Relationship data errors")),
            data_download_ui(id = "rel_errors")
        )
    ),
    hr(),
    ## Family and Health selection ---------------------------
    fluidRow(title = "Family and Health selection",
        h2("Family and Health selection"),
        column(
            4, align = "center",
            family_sel_ui("family_sel")
        ),
        column(
            4, align = "center",
            health_sel_ui("health_sel"),
            uiOutput("health_full_scale_box")
        ),
        column(
            4, align = "center",
            family_infos_ui("family_infos")
        )
    ),
    hr(),
    ## Informative and subfamily selection ----------------------
    fluidRow(
        h2("Informative and subfamily selection"),
        column(4, align = "center",
            inf_sel_ui("inf_sel")
        ),
        ## Subfamily selection -------------------------
        column(4, align = "center",
            family_sel_ui("subfamily_sel")
        ),
        ## Subfamily information -----------------------
        column(4, align = "center",
            family_infos_ui("subfamily_infos")
        )
    ),
    hr(),
    ## Plotting pedigree ----------------------------
    fluidRow(
        plot_ped_ui("ped"),
        plot_download_ui("saveped"),
        plotOutput("legend_plot", height = "50px"),
        data_download_ui("plot_data_dwnl")
    ),

    ## Console ------------------------------------------------
    fluidRow(
        pre(id = "console")
    )

))