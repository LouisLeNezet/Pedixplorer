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

#' @param input The Shiny input object from the server function.
#' @param session The Shiny session object from the server function.
#' @param r_objects A reactive list of values generated in the
#' \code{\link{ped_shiny}} app.
.create_app_observer <- function(opt, r_objects, input, session) {
    shiny::observeEvent(opt, {
        for (i in r_objects()) {
            val[[i]] <- opt[[i]]
        }
    })
    invisible(NULL)
}
