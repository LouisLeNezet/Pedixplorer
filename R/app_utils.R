#' @importFrom shiny tags
usethis::use_package("shiny")
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
#'     famid = c(1, 1, 2, 2, 3, 3),
#'     health = c("A", "B", "A", "A", "B", "B")
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
            "Major mod" = names(which.max(table(
                !!dplyr::sym(var), useNA = "always"
            ))), "Nb Ind" = dplyr::n()
        )
    if (var_num) {
        families_table$`Major mod` <- as.numeric(families_table$`Major mod`)
    }
    return(families_table)
}

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
            keep_text <- ifelse(keep_parents, "_T", "")
            title <- paste0(c(
                "Ped_F", family_sel, "_K", kin_max,
                keep_text, "_I", paste0(inf_selected, collaspe = "-"),
                "_SF", subfamily_sel
            ), collapse = "")
            stringr::str_replace_all(title, "[ /]", "")
        } else {
            keep_text <- ifelse(keep_parents, "trimmed ", "")
            paste0(c(
                "Pedigree ", keep_text, "of family N*",
                family_sel, " sub-family N*", subfamily_sel,
                " (N=", nb_rows, ") from ",
                paste0(inf_selected, collapse = ", "), " individuals."
            ), collapse = "")
        }
    }
}
