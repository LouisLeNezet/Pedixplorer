usethis::use_package("shiny")

#' Run Pedixplorer Shiny application
#'
#' Main function to run Pedixplorer Shiny application.
#'
#' @export
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
ped_shiny <- function(
    launch_app = TRUE, port = getOption("shiny.port"),
    host = getOption("shiny.host", "127.0.0.1")
) {
    
    shiny::shinyApp(
        ped_ui, ped_server,
        options = list(host = host, port = port)
    )
}
