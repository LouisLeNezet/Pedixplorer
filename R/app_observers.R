# Functions that create observers for both
# observers reacting to the Shiny server input object
# and reactive values stored in lists of reactive values

#' Create Error download observers
#' @param id The id of the Shiny module
#' @param df A reactive value containing the data to check for errors
#' @param title The title of the download button
error_observer <- function(id, df, title) {
    shiny::observeEvent(
        df, {
            data_download_server(id,
                shiny::reactive({
                    df[!is.na(df$error), ]
                }), title
            )
        }
    )
}
