#' @importFrom ggplot2 ggplot ggtitle theme element_blank element_rect
#' @importFrom ggplot2 scale_y_reverse unit
#' @importFrom stringr str_split_fixed str_split_i
NULL

#' Create a plot from a data.frame
#'
#' @description
#' This function is used to create a plot from a data.frame.
#'
#' If `ggplot_gen = TRUE`, the plot will be generated with ggplot2 and
#' will be returned invisibly.
#'
#' @param df A data.frame with the following columns:
#' - `type`: The type of element to plot. Can be `text`,
#' `segments`, `arc` or other polygons.
#' For polygons, the name of the polygon must be in the form
#' `poly_*_*` where poly is one of the type given by
#' [polygons()], the first `*` is the number
#' of slice in the polygon and the second `*` is the
#' position of the division of the polygon.
#' - `x0`: The x coordinate of the center of the element.
#' - `y0`: The y coordinate of the center of the element.
#' - `x1`: The x coordinate of the end of the element.
#' Only used for `segments` and `arc`.
#' - `y1`: The y coordinate of the end of the element.
#' Only used for `segments` and `arc`.
#' - `fill`: The fill color of the element.
#' - `border`: The border color of the element.
#' - `density`: The density of the element.
#' - `angle`: The angle of the element.
#' - `label`: The label of the element. Only used for `text`.
#' - `cex`: The size of the element.
#' - `adjx`: The x adjustment of the element. Only used for `text`.
#' - `adjy`: The y adjustment of the element. Only used for `text`.
#' @param usr The user coordinates of the plot.
#' @param title The title of the plot.
#' @param add_to_existing If `TRUE`, the plot will be added to the current
#' plot.
#' @param boxh Height of the polygons elements
#' @param boxw Width of the polygons elements
#' @param title_cex The size of the title.
#' @inheritParams draw_segment
#' @inheritParams ped_to_plotdf
#' @include plot_fct.R
#'
#' @examples
#' data(sampleped)
#' ped1 <- Pedigree(sampleped[sampleped$famid == 1,])
#' lst <- ped_to_plotdf(ped1)
#' if (interactive()) {
#'     plot_fromdf(lst$df, lst$par_usr$usr,
#'         boxw = lst$par_usr$boxw, boxh = lst$par_usr$boxh
#'     )
#' }
#' @return an invisible ggplot object and a plot on the current plotting device
#' @keywords internal, Pedigree-plot
#' @importFrom graphics frame par
#' @importFrom ggplot2 ggplot theme element_blank element_rect
#' @importFrom ggplot2 unit scale_y_reverse ggtitle
#' @importFrom stringr str_split_i
#' @export
plot_fromdf <- function(
    df, usr = NULL, title = NULL, ggplot_gen = FALSE, boxw = 1,
    boxh = 1, add_to_existing = FALSE, title_cex = 2
) {
    if (!add_to_existing) {
        graphics::frame()
    }
    op <- par(no.readonly = TRUE)
    if (!is.null(usr)) {
        graphics::par(usr = usr)
    }
    p <- ggplot2::ggplot() +
        ggplot2::theme(
            plot.margin = ggplot2::unit(c(0, 0, 0, 0), "cm"),
            panel.background = ggplot2::element_rect(
                fill = "transparent", color = NA
            ), panel.grid.major = ggplot2::element_blank(),
            panel.grid.minor = ggplot2::element_blank(),
            axis.ticks = ggplot2::element_blank(),
            axis.text = ggplot2::element_blank(),
            axis.title = ggplot2::element_blank()
        ) +
        ggplot2::scale_y_reverse()

    ## Add title if exists
    if (!is.null(title)) {
        title(title, cex.main = title_cex)
        p <- p + ggplot2::ggtitle(title)
    }

    aff <- as.numeric(stringr::str_split_i(df$type, "_", 2))
    if (all(is.na(aff))) {
        max_aff <- 1
    } else {
        max_aff <- max(aff, na.rm = TRUE)
    }

    ## Add boxes
    poly_n <- lapply(seq_len(max_aff), polygons)
    all_types <- apply(expand.grid(
        names(polygons(1)), seq_len(max_aff), seq_len(max_aff)
    ), 1, paste, collapse = "_")

    seg_forward <- c("dead", "ECT-TOP", "asymptomatic", "adoption")
    seg <- df[df$type == "segments" & ! (df$id %in% seg_forward), ]
    if (!is.null(seg) && nrow(seg) > 0) {
        p <- draw_segment(
            seg$x0, seg$y0, seg$x1, seg$y1,
            p, ggplot_gen, col = seg$fill, lwd = seg$cex
        )
    }

    boxes <- df[df$type %in% all_types, ]
    if (!is.null(boxes) && nrow(boxes) > 0) {
        boxes[c("poly", "polydiv", "naff")] <- str_split_fixed(
            boxes$type, "_", 3
        )
        boxes$angle[boxes$angle == "NA"] <- 45
        for (i in seq_len(dim(boxes)[1])){
            poly <- poly_n[[as.numeric(boxes$polydiv[i])]][[boxes$poly[i]]][[
                as.numeric(boxes$naff[i])
            ]]
            p <- draw_polygon(
                boxes$x0[i] + poly$x * boxw,
                boxes$y0[i] + (poly$y + 0.5) * boxh,
                p, ggplot_gen,
                fill = boxes$fill[i], border = boxes$border[i],
                density = boxes$density[i], angle = boxes$angle[i],
                lwd = boxes$cex[i], tips = boxes$tips[i]
            )
        }
    }

    seg <- df[df$type == "segments" & df$id %in% seg_forward, ]
    if (!is.null(seg) && nrow(seg) > 0) {
        p <- draw_segment(
            seg$x0, seg$y0, seg$x1, seg$y1,
            p, ggplot_gen, col = seg$fill, lwd = seg$cex
        )
    }

    arcs <- df[df$type == "arc", ]
    if (!is.null(arcs) && nrow(arcs) > 0) {
        for (it in seq_len(nrow(arcs))){
            arc <- arcs[it, ]
            p <- draw_arc(arc$x0, arc$y0, arc$x1, arc$y1,
                p, ggplot_gen, lwd = arc$cex, col = arc$fill
            )
        }
    }

    arrows_df <- df[df$type == "arrows", ]
    if (!is.null(arrows_df) && nrow(arrows_df) > 0) {
        for (it in seq_len(nrow(arrows_df))){
            arrow <- arrows_df[it, ]
            p <- draw_arrow(
                x0 = arrow$x0, y0 = arrow$y0,
                x1 = arrow$x1, y1 = arrow$y1,
                p, ggplot_gen, lwd = arrow$cex, col = arrow$fill
            )
        }
    }

    txt_df <- df[df$type == "text" & !is.na(df$label), ]
    if (!is.null(txt_df) && nrow(txt_df) > 0) {
        for (adjx in unique(txt_df$adjx)) {
            txt_x <- txt_df[txt_df$adjx == adjx, ]
            for (adjy in unique(txt_x$adjy)) {
                txt_xy <- txt_x[txt_x$adjy == adjy, ]
                p <- draw_text(
                    txt_xy$x0, txt_xy$y0, txt_xy$label,
                    p, ggplot_gen, txt_xy$cex, txt_xy$fill,
                    adjx, adjy, tips = txt_xy$tips
                )
            }
        }
    }

    points_df <- df[df$type == "points", ]
    if (!is.null(points_df) && nrow(points_df) > 0) {
        p <- draw_point(
            x = points_df$x0, y = points_df$y0,
            p = p, ggplot_gen = ggplot_gen, cex = points_df$cex,
            col = points_df$fill, pch = points_df$lty
        )
    }
    par(op)
    invisible(p)
}
