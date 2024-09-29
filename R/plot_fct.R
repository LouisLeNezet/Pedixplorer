#' @importFrom graphics par strwidth strheight text lines
#' @importFrom graphics polygon frame segments
NULL

#' Subset a region of a Pedigree
#'
#' @param subreg A 4-element vector for (min x, max x, min depth, max depth),
#' used to edit away portions of the plot coordinates returned by
#' [ped_to_plotdf()].
#' This is useful for zooming in on a particular region of the Pedigree.
#' @param df A data frame with all the plot coordinates
#'
#' @return A subset of the plot coordinates
#' @keywords internal, Pedigree-plot
subregion <- function(df, subreg = NULL) {
    if (is.null(subreg)) {
        return(df)
    }

    if (length(subreg) != 4) {
        stop("subreg must be a 4-element vector")
    }

    if (any(!c("x0", "x1", "y0", "y1") %in% colnames(df))) {
        stop("df must have columns x0, x1, y0, y1")
    }

    valid_x0 <- df$x0 >= subreg[1] & df$x0 <= subreg[2]
    valid_y0 <- df$y0 >= subreg[3] & df$y0 <= subreg[4]
    valid_x1 <- df$x1 >= subreg[1] & df$x1 <= subreg[2]
    valid_y1 <- df$y1 >= subreg[3] & df$y1 <= subreg[4]

    valid_start <- valid_x0 & valid_y0
    valid_end <- (valid_x1 & valid_y1) | is.na(valid_x1) | is.na(valid_y1)

    valid_rows <- valid_start & valid_end

    df[valid_rows, ]
}


#' Circular element
#'
#' Create a list of x and y coordinates for a circle
#' with a given number of slices.
#'
#' @param nslice Number of slices in the circle
#' @param n Total number of points in the circle
#'
#' @return A list of x and y coordinates per slice.
#' @keywords internal, Pedigree-plot
#' @examples
#'
#' circfun(1)
#' circfun(1, 10)
#' circfun(4, 50)
#' @export
circfun <- function(nslice, n = 50) {
    nseg <- ceiling(n / nslice)  # segments of arc per slice

    theta <- -pi / 2 - seq(0, 2 * pi, length = nslice + 1)
    out <- vector("list", nslice)
    for (i in seq_len(nslice)) {
        theta2 <- seq(theta[i], theta[i + 1], length = nseg)
        out[[i]] <- list(x = c(0, cos(theta2) / 2),
            y = c(0, sin(theta2) / 2) + 0.5
        )
    }
    out
}


#' Polygonal element
#'
#' Create a list of x and y coordinates for a polygon
#' with a given number of slices and a list of coordinates
#' for the polygon.
#'
#' @param nslice Number of slices in the polygon
#' @param coor Element form which to generate the polygon
#' containing x and y coordinates and theta
#'
#' @return a list of x and y coordinates
#' @keywords internal, Pedigree-plot
#' @examples
#' polyfun(2, list(
#'     x = c(-0.5, -0.5, 0.5, 0.5),
#'     y = c(-0.5, 0.5, 0.5, -0.5),
#'     theta = -c(3, 5, 7, 9) * pi / 4
#' ))
#' @export
polyfun <- function(nslice, coor) {
    # make the indirect segments view
    zmat <- matrix(0, ncol = 4, nrow = length(coor$x))
    zmat[, 1] <- coor$x
    zmat[, 2] <- c(coor$x[-1], coor$x[1]) - coor$x
    zmat[, 3] <- coor$y
    zmat[, 4] <- c(coor$y[-1], coor$y[1]) - coor$y

    # Find the cutpoint for each angle Yes we could vectorize the loop, but
    # nslice is never bigger than about 10 (and usually <5), so why be
    # obscure?
    ns1 <- nslice + 1
    theta <- -pi / 2 - seq(0, 2 * pi, length = ns1)
    x <- y <- double(ns1)
    for (i in seq_len(ns1)) {
        z <- (tan(theta[i]) * zmat[, 1] - zmat[, 3]) /
            (zmat[, 4] - tan(theta[i]) * zmat[, 2])
        tx <- zmat[, 1] + z * zmat[, 2]
        ty <- zmat[, 3] + z * zmat[, 4]
        inner <- tx * cos(theta[i]) + ty * sin(theta[i])
        indx <- which(is.finite(z) & z >= 0 & z <= 1 & inner > 0)
        x[i] <- tx[indx]
        y[i] <- ty[indx]
    }
    nvertex <- length(coor$x)
    temp <- data.frame(
        indx = c(seq_len(ns1), rep(0, nvertex)),
        theta = c(theta, coor$theta),
        x = c(x, coor$x), y = c(y, coor$y)
    )
    temp <- temp[order(-temp$theta), ]
    out <- vector("list", nslice)
    for (i in seq_len(nslice)) {
        rows <- which(temp$indx == i):which(temp$indx == (i + 1))
        out[[i]] <- list(
            x = c(0, temp$x[rows]),
            y = c(0, temp$y[rows]) + 0.5
        )
    }
    out
}

#' List of polygonal elements
#'
#' Create a list of polygonal elements with x, y coordinates
#' and theta for the square, circle, diamond and triangle.
#' The number of slices in each element can be specified.
#'
#' @param nslice Number of slices in each element
#' If nslice > 1, the elements are created with [polyfun()].
#'
#' @return a list of polygonal elements with x, y coordinates
#' and theta by slice.
#' @keywords internal, Pedigree-plot
#' @examples
#' polygons()
#' polygons(4)
#' @export
polygons <- function(nslice = 1) {
    if (nslice == 1) {
        polylist <- list(
            square = list(list(
                x = c(-1, -1, 1, 1) / 2,
                y = c(0, 1, 1, 0)
            )),
            circle = list(list(
                x = 0.5 * cos(seq(0, 2 * pi, length = 50)),
                y = 0.5 * sin(seq(0, 2 * pi, length = 50)) + 0.5
            )),
            diamond = list(list(
                x = c(0, -0.5, 0, 0.5),
                y = c(0, 0.5, 1, 0.5)
            )),
            triangle = list(list(
                x = c(0, -0.56, 0.56),
                y = c(0, 1, 1)
            ))
        )
    } else {
        square <- polyfun(nslice, list(
            x = c(-0.5, -0.5, 0.5, 0.5),
            y = c(-0.5, 0.5, 0.5, -0.5),
            theta = -c(3, 5, 7, 9) * pi / 4
        ))
        circle <- circfun(nslice)
        diamond <- polyfun(nslice, list(
            x = c(0, -0.5, 0, 0.5),
            y = c(-0.5, 0, 0.5, 0),
            theta = -(seq_len(4)) * pi / 2
        ))
        triangle <- polyfun(nslice, list(
            x = c(-0.56, 0, 0.56),
            y = c(-0.5, 0.5, -0.5),
            theta = c(-2, -4, -6) * pi / 3
        ))
        polylist <- list(
            square = square, circle = circle,
            diamond = diamond, triangle = triangle
        )
    }  ## else
    polylist
}

#'@importFrom ggplot2 geom_polygon aes annotate
NULL

#' Draw segments
#'
#' @param x0 x coordinate of the first point
#' @param y0 y coordinate of the first point
#' @param x1 x coordinate of the second point
#' @param y1 y coordinate of the second point
#' @param p ggplot object
#' @param ggplot_gen If TRUE add the segments to the ggplot object
#' @param col Line color
#' @param lwd Line width
#' @param lty Line type
#'
#' @return Plot the segments to the current device
#' or add it to a ggplot object
#' @keywords internal, Pedigree-plot
draw_segment <- function(
    x0, y0, x1, y1,
    p = NULL, ggplot_gen = FALSE,
    col = par("fg"), lwd = par("lwd"), lty = par("lty")
) {
    segments(x0, y0, x1, y1, col = col, lty = lty, lwd = lwd)
    if (ggplot_gen) {
        p <- p + annotate("segment", x = x0, y = y0,
            xend = x1, yend = y1, colour = col, linetype = lty, linewidth = lwd
        )
    }
    p
}

#' Draw a polygon
#'
#' @param x x coordinates
#' @param y y coordinates
#' @param fill Fill color
#' @param border Border color
#' @param density Density of shading
#' @param angle Angle of shading
#' @inheritParams draw_segment
#'
#' @return Plot the polygon  to the current device
#' or add it to a ggplot object
#' @keywords internal, Pedigree-plot
draw_polygon <- function(
    x, y, p = NULL, ggplot_gen = FALSE,
    fill = "grey", border = "black", density = NULL, angle = 45
) {
    polygon(
        x, y, col = fill, border = border,
        density = density, angle = angle
    )
    if (ggplot_gen) {
        p <- p +
            geom_polygon(
                aes(x = x, y = y), fill = fill, color = border
            )
        # To add pattern stripes use ggpattern::geom_polygon_pattern
        # pattern_density = density[i], pattern_angle = angle[i]))
    }
    p
}

#' Draw texts
#'
#' @param label Text to be displayed
#' @param cex Character expansion of the text
#' @param col Text color
#' @param adjx x adjustment
#' @param adjy y adjustment
#' @inheritParams draw_segment
#' @inheritParams draw_polygon
#'
#' @return Plot the text to the current device
#' or add it to a ggplot object
#' @keywords internal, Pedigree-plot
draw_text <- function(x, y, label, p = NULL, ggplot_gen = FALSE,
    cex = 1, col = NULL, adjx = 0, adjy = 0
) {
    text(x, y, label, cex = cex, col = col, adj = c(adjx, adjy))
    if (ggplot_gen) {
        p <- p + annotate(
            "text", x = x, y = y, label = label,
            size = cex / 0.3, colour = col
        )
    }
    p
}

#' Draw arcs
#'
#' @inheritParams draw_segment
#'
#' @return Plot the arcs to the current device
#' or add it to a ggplot object
#' @keywords internal, Pedigree-plot
draw_arc <- function(
    x0, y0, x1, y1,
    p = NULL, ggplot_gen = FALSE,
    lwd = 1, lty = 2, col = "black"
) {
    xx <- seq(x0, x1, length = 15)
    yy <- seq(y0, y1, length = 15) + (seq(-7, 7))^2 / 98 - 0.5
    lines(xx, yy, lty = lty, lwd = lwd, col = col)
    if (ggplot_gen) {
        p <- p + annotate(
            "line", xx, yy, linetype = "dashed", colour = col
        )
    }
    return(p)
}

#' Set plotting area
#'
#' @param id A character vector with the identifiers of each individuals
#' @param cex Character expansion of the text
#' @param maxlev Maximum level
#' @param xrange Range of x values
#' @param symbolsize Size of the symbols
#' @param precision The number of significant digits to round the solution to.
#' @param ... Other arguments passed to [par()]
#'
#' @return List of user coordinates, old par, box width, box height,
#' label height and leg height
#'
#' @keywords internal, Pedigree-plot
set_plot_area <- function(
    cex, id, maxlev, xrange, symbolsize, precision = 3, ...
) {
    old_par <- par(xpd = TRUE, ...)  ## took out mar=mar
    psize <- signif(par("pin"), precision)  # plot region in inches
    stemp1 <- signif(strwidth(
        "ABC", units = "inches", cex = cex
    ), precision) * 2.5 / 3
    stemp2 <- signif(strheight(
        "1g", units = "inches", cex = cex
    ), precision)
    stemp3 <- max(signif(
        strheight(id, units = "inches", cex = cex), precision
    ))

    ht1 <- psize[2] / maxlev - (stemp3 + 1.5 * stemp2)
    if (ht1 <= 0) {
        stop("Labels leave no room for the graph, reduce cex")
    }
    ht2 <- psize[2] / (maxlev + (maxlev - 1) / 2)
    wd2 <- 0.8 * psize[1] / (0.8 + diff(xrange))

    boxsize <- symbolsize * min(ht1, ht2, stemp1, wd2)  # box size in inches
    # horizontal scale in inches
    hscale <- (psize[1] - boxsize) / diff(xrange)
    vscale <- (psize[2] - (stemp3 + stemp2 / 2 + boxsize)) /
        max(1, maxlev - 1)
    boxw <- boxsize / hscale  # box width in user units
    boxh <- boxsize / vscale  # box height in user units
    labh <- stemp2 / vscale  # height of a text string
    # how tall are the 'legs' up from a child
    legh <- min(1 / 4, boxh * 1.5)
    usr <- c(xrange[1] - boxw / 2, xrange[2] + boxw / 2,
        maxlev + boxh + stemp3 + stemp2 / 2, 1
    )
    list(usr = usr, old_par = old_par, boxw = boxw,
        boxh = boxh, labh = labh, legh = legh
    )
}
