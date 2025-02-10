#' Create plotting legend data frame from a Pedigree
#'
#' @description
#' Convert a Pedigree to a legend data frame for it to
#' be plotted afterwards with [plot_fromdf()].
#'
#' @details The data frame contains the following columns:
#' - `x0`, `y0`, `x1`, `y1`: coordinates of the elements
#' - `type`: type of the elements
#' - `fill`: fill color of the elements
#' - `border`: border color of the elements
#' - `angle`: angle of the shading of the elements
#' - `density`: density of the shading of the elements
#' - `cex`: size of the elements
#' - `label`: label of the elements
#' - `tips`: tips of the elements (used for the tooltips)
#' - `adjx`: horizontal text adjustment of the labels
#' - `adjy`: vertical text adjustment of the labels
#'
#' All those columns are used by
#' [plot_fromdf()] to plot the graph.
#' @param obj A Pedigree object
#' @param cex Character expansion of the text
#' @inheritParams plot_fromdf
#' @param adjx default=0.  Controls the horizontal text adjustment of
#' the labels in the legend.
#' @param adjy default=0.  Controls the vertical text adjustment
#' of the labels in the legend.
#' @param lwd default=par("lwd").  Controls the bordering line width of the
#' elements in the legend.
#'
#' @return
#' A list containing the legend data frame and the user coordinates.
#'
#' @examples
#' data("sampleped")
#' ped <- Pedigree(sampleped)
#' leg_df <- ped_to_legdf(ped)
#' summary(leg_df$df)
#' plot_fromdf(leg_df$df, usr = c(-1,15,0,7))
#' @keywords internal, Pedigree-plot
#' @export
#' @usage NULL
setGeneric(
    "ped_to_legdf", signature = "obj",
    function(obj, ...) {
        standardGeneric("ped_to_legdf")
    }
)

#' @rdname ped_to_legdf
#' @export
#' @importFrom graphics strwidth
setMethod("ped_to_legdf", "Pedigree", function(
    obj, boxh = 1, boxw = 1,
    cex = 1, adjx = 0, adjy = 0, lwd = par("lwd")
) {
    par_usr <- list(boxh = boxh, boxw = boxw, cex = cex)
    plot_df <- data.frame(
        id = character(),
        x0 = numeric(), y0 = numeric(), x1 = numeric(), y1 = numeric(),
        type = character(), fill = character(), border = character(),
        angle = numeric(), density = numeric(), cex = numeric(),
        label = character(), tips = character(), adjx = numeric(),
        adjy = numeric()
    )
    sex_equiv <- c("Male", "Female", "Unknown")
    all_lab <- list(sex_equiv, border(obj)$labels)
    all_aff <- lapply(unique(fill(obj)$order), function(x) {
        fill(obj)$labels[fill(obj)$order == x]
    })

    all_lab <- c(all_lab, all_aff)
    max_lab <- lapply(lapply(
        all_lab, graphics::strwidth,
        units = "figure", cex = cex
    ), max)

    posx_all <- cumsum(unlist(max_lab) + boxw * 2)
    posx <- c(0, posx_all[seq_len((length(posx_all) - 1))])

    n_max <- max(unlist(lapply(all_lab, function(x) {
        length(x)
    })))

    posy <- rep(c(boxh, boxh / 3), n_max)
    posy <- cumsum(posy)
    posy <- posy[seq_along(posy) %% 2 == 0]

    all_aff <- fill(obj)
    n_aff <- length(unique(all_aff$order))

    # Categories titles
    lab_title <- c("Sex", "Border", unique(all_aff$column_values))
    titles <- data.frame(
        x0 = posx, y0  = 0,
        type = "text", label = lab_title, adjx = 0.5, adjy = 0,
        fill = "black", cex = cex * 1.5,
        id = "titles"
    )
    plot_df <- rbind.fill(plot_df, titles)

    ## Get ped_df
    ped_df <- as.data.frame(ped(obj))

    # Sex
    poly1 <- polygons(1)
    all_sex <- unique(as.numeric(ped_df$sex))
    sex <- data.frame(
        x0 = posx[1], y0 = posy[all_sex] - boxh / 2,
        type = paste(names(poly1)[all_sex], 1, 1, sep = "_"),
        fill = "white",
        border = "black",
        id = "sex", cex = lwd
    )

    sex_label <- data.frame(
        x0 = posx[1] + boxw + adjx,
        y0 = posy[all_sex] + adjy,
        label = sex_equiv[all_sex], cex = cex,
        type = "text", adjx = 0, adjy = 0.5,
        fill = "black",
        id = "sex_label"
    )

    plot_df <- rbind.fill(plot_df, sex, sex_label)

    # Border
    border_mods <- unique(ped_df[, unique(border(obj)$column_mods)])
    border <- data.frame(
        x0 = posx[2],
        y0 = posy[seq_along(border_mods)] - boxh / 2,
        type = rep("square_1_1", length(border_mods)),
        border = border(obj)$border[match(border_mods, border(obj)$mods)],
        fill = "white",
        id = "border", cex = lwd
    )
    lab <- border(obj)$labels[match(border_mods, border(obj)$mods)]
    lab[is.na(lab)] <- "NA"
    border_label <- data.frame(
        x0 = posx[2] + boxw + adjx,
        y0 = posy[seq_along(border_mods)] + adjy,
        label = lab, cex = cex, adjx = 0, adjy = 0.5,
        type = "text",
        fill = "black",
        id = "border_label"
    )

    plot_df <- rbind.fill(plot_df, border, border_label)

    ## Affected
    for (aff in seq_len(n_aff)) {
        aff_df <- all_aff[all_aff$order == aff, ]
        aff_mods <- aff_df$mods
        aff_bkg <- data.frame(
            x0 = posx[2 + aff],
            y0 = posy[seq_along(aff_mods)] - boxh / 2,
            type = rep(paste("square", 1, 1, sep = "_"),
                length(aff_mods)
            ),
            border = "black", fill = "white", cex = lwd,
            id = paste("aff_bkg", aff, aff_mods, sep = "_")
        )

        affected <- data.frame(
            x0 = posx[2 + aff],
            y0 = posy[seq_along(aff_mods)] - boxh / 2,
            type = rep(paste("square", n_aff, aff, sep = "_"),
                length(aff_mods)
            ),
            border = "black", cex = lwd,
            fill = aff_df$fill,
            id = paste("affected", aff, aff_mods, sep = "_")
        )

        lab <- aff_df$labels
        lab[is.na(lab)] <- "NA"

        affected_label <- data.frame(
            x0 = posx[2 + aff] + boxw + adjx,
            y0 = posy[seq_along(aff_mods)] + adjy,
            label = lab, cex = cex, adjx = 0, adjy = 0.5,
            type = "text",
            fill = "black",
            id = paste("affected_label", aff, aff_mods, sep = "_")
        )
        plot_df <- rbind.fill(plot_df, aff_bkg, affected, affected_label)
    }

    ## Max limit
    max_lim <- data.frame(
        x0 = c(0, max(posx)), y0 = c(0, max(posy)),
        type = "text",
        border = "black",
        label = NA,
        id = "max_lim"
    )
    plot_df <- rbind.fill(plot_df, max_lim)

    plot_df[plot_df$type == "text", "adjx"] <- 0
    plot_df[plot_df$type == "text", "adjy"] <- 1
    par_usr$usr <- c(
        min(plot_df$x0), max(plot_df$x0),
        min(plot_df$y0), max(plot_df$y0)
    )
    list(df = plot_df, par_usr = par_usr)
}
)
