#' @importFrom shiny tags
usethis::use_package("shiny")

#' Sketch of the family information table
#'
#' Simple function to create a sketch of the family information table.
#'
#' @param var_name the name of the health variable
#' @return an html sketch of the family information table
#' @keywords internal
sketch <- function(var_name) {
    tags$table(
        class = "display",
        tags$thead(
            tags$tr(
                tags$th(class = 'dt-center', colspan = 2, var_name),
                tags$th(class = 'dt-center', colspan = 3, "Availability")
            ),
            tags$tr(
                tags$th("Affected"),
                tags$th("Modalities"),
                tags$th("Available"),
                tags$th("Unavailable"),
                tags$th("NA")
            )
        )
    )
}


#' Print to console
#'
#' This function prints the result of an expression to the console.
#' Allow easy debugging of the application.
#'
#' @param expr expression to evaluate
#' @param session the shiny session
#' @return the result of the expression
#' @export
print_console <- function(expr, session) {
    withCallingHandlers(
        results <- expr,
        message = function(m) {
            shinyjs::html("console", m$message, TRUE)
        }, error = function(e) {
            shinyjs::html("console", e$message, TRUE)
        }, warning = function(w) {
            shinyjs::html("console", w$message, TRUE)
        }
    )
    session$sendCustomMessage(type = "scrollCallback", 1)
    results
}

usethis::use_package("dplyr")

#' Summarise the families information for a given variable in a data frame
#'
#' This function summarises the families information for a given variable in a
#' data frame. It returns the most numerous modality for each family and the
#' number of individuals in the family.
#'
#' @param df a data frame
#' @param var the variable to summarise
#' @return a data frame with the family information
#' @examples
#' df <- data.frame(
#'    famid = c(1, 1, 2, 2, 3, 3),
#'    health = c("A", "B", "A", "A", "B", "B")
#' )
#' get_families_table(df, "health")
#' @export
get_families_table <- function(df, var) {
    if (!var %in% colnames(df) || !("famid" %in% colnames(df))) {
        return(NULL)
    }
    var_num <- is.numeric(df[[var]])

    families_table <- df %>%
        group_by(famid) %>%
        summarise(
            "Major mod" = names(which.max(table(!!dplyr::sym(var)))),
            "Nb Ind" = dplyr::n()
        )
    if (var_num) {
        families_table$`Major mod` <- as.numeric(families_table$`Major mod`)
    }
    return(families_table)
}

#' @importFrom ggpubr get_legend
usethis::use_package("ggpubr")

#' Get the title of the family information table
#'
#' This function generates the title of the family information table
#' depending on the selected family and subfamily and other parameters.
#'
#' @param family_sel the selected family
#' @param subfamily_sel the selected subfamily
#' @param family_var the selected family variable
#' @param mod the selected affected modality
#' @param inf_selected the selected informative individuals
#' @param kin_max the maximum kinship
#' @param keep_parents the keep parents option
#' @param nb_rows the number of individuals
#' @param short_title a boolean to generate a short title
#' @return a string with the title
#' @examples
#' get_title(1, 1, "health", "A", "All", 3, TRUE, 10, FALSE)
#' get_title(1, 1, "health", "A", "All", 3, TRUE, 10, TRUE)
#' get_title(1, 1, "health", "A", "All", 3, FALSE, 10, FALSE)
#' @export
get_title <- function(
    family_sel, subfamily_sel, family_var, mod, inf_selected,
    kin_max, keep_parents, nb_rows, short_title = FALSE
) {
    if (subfamily_sel == "0") {
        "Subfamily containing individuals not linked to any"
    } else {
        if (short_title) {
            keep_text <- ifelse(keep_parents, "-T", "")
            title <- paste0(c(
                "Ped", family_var, mod, "-K", kin_max,
                keep_text, "-I", inf_selected, "_SF", subfamily_sel
            ), collapse = "")
            title <- stringr::str_replace(title, "/", "-")
            stringr::str_replace(title, " ", "-")
        } else {
            keep_text <- ifelse(keep_parents, "trimmed", "")
            paste0(c(
                "Pedigree", keep_text, "of", family_var, mod, "family N\u176",
                family_sel, "sub-family N\u176", subfamily_sel,
                "( N=", nb_rows, ") from",
                inf_selected, "individuals"
            ), collapse = " ")
        }
    }
}
