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
#' @param port (optional) Specify port the application should list to.
#' @param host (optional) The IPv4 address that the application should
#' listen on.
#' @returns Running Shiny Application
#' @examples
#' if (interactive()) {
#'     ped_shiny()
#' }
#' @rdname ped_shiny
#' @export
#' @importFrom shiny shinyApp
ped_shiny <- function(
    port = getOption("shiny.port"),
    host = getOption("shiny.host", "127.0.0.1"),
    precision = 2
) {
    shiny::shinyApp(
        ped_ui, ped_server(precision),
        options = list(host = host, port = port)
    )
}
