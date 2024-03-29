#' Sketch of the family information table
sketch <- function(var_name) {
    htmltools::withTags({
        table(
            class = "display",
            thead(
                tr(
                    th(class = 'dt-center', colspan = 2, var_name),
                    th(class = 'dt-center', colspan = 3, "Availability")
                ),
                tr(
                    th("Affected"),
                    th("Modalities"),
                    th("Available"),
                    th("Unavailable"),
                    th("NA")
                )
            )
        )
    })
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
## Choose family to plot the name used will be the most numerous race
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

create_legend <- function(lgd_list, nb_col_many = 2, size = 1) {
    legend <- list()
    it1 <- 1
    for (it1 in seq_along(lgd_list)) {
        i <- names(lgd_list)[[it1]]
        legend_labels <- names(lgd_list[[i]])
        nb_mod <- length(lgd_list[[i]])
        if (i == "Availability") {
            fill_color <- rep("white", length(lgd_list[[i]]))
            border_color <- lgd_list[[i]]
        } else {
            fill_color <- lgd_list[[i]]
            border_color <- rep("black", length(lgd_list[[i]]))
        }

        data <- data.frame(
            X = rep(1, nb_mod), Y = 1:nb_mod,
            Aff = as.character(1:nb_mod)
        )
        if (nb_mod > 5) {
            nbcol <- nb_col_many
        } else {
            nbcol <- 1
        }

        grob <- ggplot(data, aes(X, Y)) +
            geom_point(aes(fill = Aff), shape = 21, size = 10, stroke = 1.5) +
            scale_fill_manual(
                values = setNames(fill_color, 1:nb_mod), name = i,
                labels = setNames(legend_labels, 1:nb_mod),
                drop = FALSE, guide = TRUE
            ) +
            guides(fill = guide_legend(override.aes = list(
                col = border_color,
                fill = fill_color, size = size * 10
            ), ncol = nbcol)) +
            theme(
                legend.margin = margin(0, 0, 0, 0, "in"),
                legend.title = element_text(size = 20 * size),
                legend.text = element_text(size = 18 * size),
                legend.justification = "top",
                plot.background = element_rect(fill = "red"),
            )

        legend[[LETTERS[it1]]] <- ggpubr::get_legend(grob)
    }
    return(legend)
}

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
                "Pedigree", keep_text, "of", family_var, mod, "family N°",
                family_sel, "sub-family N°", subfamily_sel,
                "( N=", nb_rows, ") from",
                inf_selected, "individuals"
            ), collapse = " ")
        }
    }
}
