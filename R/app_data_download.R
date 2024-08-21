#' @importFrom shiny NS uiOutput tagList

usethis::use_package("shiny")

#' @rdname data_download
data_download_ui <- function(id) {
    ns <- shiny::NS(id)
    tagList(
        uiOutput(ns("title_data")),
        uiOutput(ns("data_text")),
        uiOutput(ns("btn_dwld"))
    )
}

#' Shiny modules to download a dataframe
#'
#' This function allows to download a dataframe as a csv file.
#' This generate a Shiny module that can be used in a Shiny app.
#' The function is composed of two parts: the UI and the server.
#' The UI is called with the function `data_download_ui()` and the server
#' with the function `data_download_server()`.
#'
#' @param id A string to identify the module.
#' @param df A reactive dataframe.
#' @param filename A string to name the file.
#' @param label A string to display in the download button.
#' @param helper A boolean to display a helper message.
#'
#' @examples
#' \dontrun{
#'   data_download_demo()
#' }
#' @rdname data_download
data_download_server <- function(
    id, df, filename,
    label = NULL, helper = TRUE, title = "Data download"
) {
    stopifnot(shiny::is.reactive(df))
    ns <- shiny::NS(id)
    shiny::moduleServer(id, function(input, output, session) {
        ## Create title
        output$title_data <- shiny::renderUI({
            h3(title)
        })

        ## Create download button
        output$data_dwld <- shiny::downloadHandler(filename = function() {
            paste(filename, ".csv", sep = "")
        }, content = function(file) {
            utils::write.csv2(df(), file)
        })

        shiny::observeEvent(df(), {
            if (nrow(df()) == 0) {
                output$data_text <- shiny::renderUI({
                    shiny::HTML(paste(label, "doesn't have any rows"))
                })
                output$btn_dwld <- shiny::renderUI({
                    NULL
                })
            } else {
                if (helper) {
                    output$data_text <- shiny::renderUI({
                        shiny::HTML(paste(
                            label, "with", nrow(df()),
                            "rows", "<br/>",
                            "(Data can only be export to Download folder)"
                        ))
                    })
                } else {
                    output$data_text <- shiny::renderUI({
                        NULL
                    })
                }

                output$btn_dwld <- shiny::renderUI({
                    shiny::downloadButton(ns("data_dwld"), label = label)
                })

            }
        })
    })
}

#' @rdname data_download
#' @export
data_download_demo <- function() {
    ui <- shiny::fluidPage(data_download_ui("datafile"))
    server <- function(input, output, session) {
        data_download_server(
            "datafile",
            shiny::reactive({
                datasets::mtcars
            }),
            "mtcars_data_file", "mtcars"
        )
    }
    shiny::shinyApp(ui, server)
}
