#' @rdname data_download
#' @importFrom shiny NS uiOutput tagList
data_download_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::tagList(
        shiny::uiOutput(ns("title_data")),
        shiny::uiOutput(ns("data_text")),
        shiny::downloadButton(ns("data_dwld"))
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
#' @return A shiny module to export a dataframe.
#' @examples
#' if (interactive()) {
#'     data_download_demo()
#' }
#' @rdname data_download
#' @keywords internal
#' @importFrom shiny is.reactive reactive NS moduleServer
#' @importFrom shiny downloadHandler observeEvent renderUI
#' @importFrom shiny HTML downloadButton
#' @importFrom utils write.csv2
data_download_server <- function(
    id, df, filename,
    label = NULL, helper = TRUE, title = "Data download"
) {
    stopifnot(shiny::is.reactive(df))

    myfilename <- shiny::reactive({
        if (shiny::is.reactive(filename)) {
            filename <- filename()
        }
        filename
    })

    shiny::moduleServer(id, function(input, output, session) {
        ## Create title
        output$title_data <- shiny::renderUI({
            h3(title)
        })

        ## Create download button
        shiny::observeEvent(df(), {
            if (nrow(df()) == 0) {
                output$data_text <- shiny::renderUI({
                    shiny::HTML(paste(label, "doesn't have any rows"))
                })
                output$data_dwld <- NULL
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
                output$data_dwld <- shiny::downloadHandler(
                    filename = function() {
                        paste(myfilename(), ".csv", sep = "")
                    },
                    content = function(file) {
                        utils::write.csv2(df(), file)
                    }
                )

            }
        })
    })
}

#' @rdname data_download
#' @export
#' @importFrom shiny fluidPage shinyApp reactive
data_download_demo <- function() {
    ui <- shiny::fluidPage(
        data_download_ui("data_download")
    )
    server <- function(input, output, session) {
        data_download_server(
            "data_download",
            shiny::reactive({
                datasets::mtcars
            }),
            "mtcars_data_file", "mtcars"
        )
    }
    shiny::shinyApp(ui, server)
}
