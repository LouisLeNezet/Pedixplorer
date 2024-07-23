usethis::use_package("shiny")

#' Run Pedixplorer Shiny application
#'
#' This function creates a shiny application to manage and visualize
#' pedigree data using the `ped_ui()` and `ped_server()` functions.
#'
#' The application is composed of several modules:
#' - Data import
#' - Data column selection
#' - Data download
#' - Family selection
#' - Health selection
#' - Informative selection
#' - Subfamily selection
#' - Plotting pedigree
#' - Family information
#'
#' @return Running Shiny Application
#'
#' @param launch_app One of TRUE or FALSE indicating whether or not to run
#' application. Default is TRUE.
#' @param port (optional) Specify port the application should list to.
#' @param host (optional) The IPv4 address that the application should
#' listen on.
#' @examples
#' \dontrun{
#' ## To run app set launch_app=TRUE
#' ped_shiny(launch_app=FALSE)
#' }
#' @export
ped_shiny <- function(
    launch_app = TRUE, port = getOption("shiny.port"),
    host = getOption("shiny.host", "127.0.0.1")
) {
    if (launch_app) {
        shiny::shinyApp(
            ped_ui, ped_server,
            options = list(host = host, port = port)
        )
    } else {
        warning("App not launched. Set launch_app=TRUE to run app.")
        return(NULL)
    }
}
