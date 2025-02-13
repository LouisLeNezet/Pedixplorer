#' Subset a region of a Pedigree
#'
#' @param subreg A 4-element vector for (min x, max x, min depth, max depth),
#' used to edit away portions of the plot coordinates returned by
#' [ped_to_plotdf()].
#' This is useful for zooming in on a particular region of the Pedigree.
#' @param df A data frame with all the plot coordinates
#'
#' @return A subset of the plot coordinates
#' @keywords internal
#' @keywords Pedigree-plot
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
#' @keywords internal
#' @keywords Pedigree-plot
#' @examples
#'
#' circfun(1)
#' circfun(1, 10)
#' circfun(4, 50)
#' @export
circfun <- function(nslice, n = 50, start = 0) {

    if (nslice == 1) {
        return(list(list(
            x = 0.5 * cos(seq(0, 2 * pi, length = n)),
            y = 0.5 * sin(seq(0, 2 * pi, length = n))
        )))
    }

    # Compute the degree sequence, adding start to shift the slices
    degree <- (seq(0, 360, length.out = nslice + 1)[1:nslice] + start) %% 360
    theta <- degree * pi / 180  # Convert to radians

    nseg <- ceiling(n / nslice)  # Segments of arc per slice
    out <- vector("list", nslice)
    
    # Loop through each slice and create its coordinates
    for (i in seq_len(nslice)) {
        # Ensure that the final theta[i + 1] is within valid range
        theta_end <- if (i == nslice) theta[1] + 2 * pi else theta[i + 1]
        
        # Generate angles for this slice, making sure to handle finite values
        theta2 <- seq(theta[i], theta_end, length = nseg)
        
        # Store the coordinates for the slice (with a radius of 0.5)
        out[[i]] <- list(
            x = c(0, cos(theta2) / 2),
            y = c(0, sin(theta2) / 2)
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
#' @keywords internal
#' @keywords Pedigree-plot
#' @examples
#' polyfun(2, list(
#'     x = c(-0.5, -0.5, 0.5, 0.5),
#'     y = c(-0.5, 0.5, 0.5, -0.5),
#'     theta = -c(3, 5, 7, 9) * pi / 4
#' ))
#' @export
find_ray_intersections <- function(x0, y0, x1, y1, theta) {
    if (x0 == x1) {  # Vertical segment
        x_intersect <- x0  # Intersection occurs at x0
        y_intersect <- tan(theta) * x0  # Compute y based on the ray equation
        
        # Check if y_intersect is within the segment's vertical range
        within_segment <- (y_intersect >= min(y0, y1) && y_intersect <= max(y0, y1))
        
        # Ensure intersection is in the ray's forward direction
        t <- x0 / cos(theta)
        in_ray_direction <- (t >= 0)

        if (within_segment && in_ray_direction) {
            return(c(x_intersect, y_intersect))
        } else {
            return(c(NA, NA))
        }
    }

    # Ray slope (direction from origin)
    m_ray <- tan(theta)
    
    # Initialize an empty list to store intersections
    intersections <- list()
    
    # Loop over each segment
    # Compute the segment slope
    m_segment <- (y1 - y0) / (x1 - x0)

    # If slopes are equal, they are parallel (or collinear)
    if (m_segment == m_ray) {
        return(c(NA, NA))
    }
    
    # Compute the y-intercept of the segment
    b_segment <- y0 - m_segment * x0
    
    # Solve for intersection x where m_segment * x + b_segment = m_ray * x
    x_intersect <- b_segment / (m_ray - m_segment)
    y_intersect <- m_ray * x_intersect
    
    # Check if the intersection is within the segment bounds
    within_segment <- (x_intersect >= min(x0, x1) && x_intersect <= max(x0, x1) &&
                    y_intersect >= min(y0, y1) && y_intersect <= max(y0, y1))

    # Check if the intersection is in the direction of the ray (t >= 0)
    t <- x_intersect / cos(theta)  # Compute the ray parameter t
    in_ray_direction <- (t >= 0)
    
    if (within_segment && in_ray_direction) {
        return(c(x_intersect, y_intersect))
    } else {
        return(c(NA, NA))
    }
}


polyfun <- function(nslice, coor, start = 90){
    if (nslice == 1) {
        return(list(coor))
    }
    coor <- as.data.frame(coor)
    coor$id <- 1:nrow(coor)
    theta_rad <- atan2(coor$y, coor$x)
    coor$degree <- (theta_rad * 180 / pi) %% 360  # Ensure range [0, 360]

    df_seg <- data.frame(
        x0 = coor$x, y0 = coor$y,
        x1 = c(coor$x[-1], coor$x[1]), y1 = c(coor$y[-1], coor$y[1])
    )

    # Generate slicing angles
    degree <- (seq(0, 360, length.out = nslice + 1)[1:nslice] + start) %% 360
    df_expanded <- expand.grid(1:nrow(df_seg), degree)

    # Apply the function to each row
    results <- t(apply(df_expanded, 1, function(row) {
        seg_idx <- row[1]  # Get segment index
        theta <- row[2] * pi / 180  # Get theta in radians
        
        # Extract segment data
        x0 <- df_seg$x0[seg_idx]
        y0 <- df_seg$y0[seg_idx]
        x1 <- df_seg$x1[seg_idx]
        y1 <- df_seg$y1[seg_idx]

        # Call the existing function
        c(seg_idx, row[2], round(find_ray_intersections(x0, y0, x1, y1, theta), 6))
    })) %>%
        as.data.frame() %>%
        setNames(c("seg_idx", "degree", "x", "y"))

    results <- results[!is.na(results$x), ] %>%
        dplyr::distinct(degree, .keep_all = TRUE)
    results
    temp <- rbind.fill(coor, results)
    temp <- temp[order(temp$degree), ]
    idx1 <- which(!is.na(temp$seg_idx))[1]
    temp <- rbind(temp[idx1:nrow(temp), ], temp[0:(idx1 - 1), ])
    temp <- rbind(temp, temp[1,])
    rownames(temp) <- NULL

    # Create the resulting polygons
    i <- 1
    lapply(seq_len(nslice), function(i) {
        rows <- which(!is.na(temp$seg_idx))[i:(i + 1)]
        rows <- rows[1]:rows[2]
        list(x = c(0, temp$x[rows]), y = c(0, temp$y[rows]))
    })
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
#' @keywords internal
#' @keywords Pedigree-plot
#' @examples
#' polygons()
#' polygons(4)
#' @export
polygons <- function(nslice = 1, start = 90) {
    square <- polyfun(nslice, list(
        x = c(-0.5, -0.5, 0.5, 0.5),
        y = c(-0.5, 0.5, 0.5, -0.5)
    ), start = start)
    circle <- circfun(nslice, n = 50, start = start)
    diamond <- polyfun(nslice, list(
        x = c(0, -0.5, 0, 0.5),
        y = c(-0.5, 0, 0.5, 0)
    ), start = start)
    triangle <- polyfun(nslice, list(
        x = c(-0.5, 0, 0.5),
        y = -c(-0.25, 0.5, -0.25)
    ), start = start)
    list(
        square = square, circle = circle,
        diamond = diamond, triangle = triangle
    )
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
#' @keywords internal
#' @keywords Pedigree-plot
#' @importFrom ggplot2 annotate
#' @importFrom graphics segments
draw_segment <- function(
    x0, y0, x1, y1,
    p = NULL, ggplot_gen = FALSE,
    col = par("fg"), lwd = par("lwd"), lty = par("lty")
) {
    graphics::segments(x0, y0, x1, y1, col = col, lty = lty, lwd = lwd)
    if (ggplot_gen) {
        p <- p + ggplot2::annotate("segment", x = x0, y = y0,
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
#' @param tips Text to be displayed when hovering over the polygon
#' @inheritParams draw_segment
#'
#' @return Plot the polygon  to the current device
#' or add it to a ggplot object
#' @keywords internal
#' @keywords Pedigree-plot
#' @importFrom ggplot2 geom_polygon aes
#' @importFrom graphics polygon
draw_polygon <- function(
    x, y, p = NULL, ggplot_gen = FALSE,
    fill = "grey", border = "black",
    density = NULL, angle = 45,
    lwd = par("lwd"), tips = NULL
) {
    graphics::polygon(
        x, y, col = fill, border = border,
        density = density, angle = angle,
        lwd = lwd
    )
    if (ggplot_gen) {
        if (is.null(tips)) {
            tips <- "None"
        }
        p <- p +
            suppressWarnings(ggplot2::geom_polygon(
                ggplot2::aes(x = x, y = y, text = tips),
                fill = fill, color = border, linewidth = lwd
            ))
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
#' @param tips Text to be displayed when hovering over the text
#' @inheritParams draw_segment
#' @inheritParams draw_polygon
#'
#' @return Plot the text to the current device
#' or add it to a ggplot object
#' @keywords internal
#' @keywords Pedigree-plot
#' @importFrom ggplot2 annotate
#' @importFrom graphics text
draw_text <- function(x, y, label, p = NULL, ggplot_gen = FALSE,
    cex = 1, col = NULL, adjx = 0.5, adjy = 0.5, tips = NULL
) {
    graphics::text(x, y, label, cex = cex, col = col, adj = c(adjx, adjy))
    if (ggplot_gen) {
        if (is.null(tips)) {
            tips <- label
        }
        p <- p + suppressWarnings(ggplot2::geom_text(ggplot2::aes(
            x = x, y = y, label = label,
            text = tips
        ), size = cex / 0.3, colour = col))
    }
    p
}

#' Draw arcs
#'
#' @inheritParams draw_segment
#'
#' @return Plot the arcs to the current device
#' or add it to a ggplot object
#' @keywords internal
#' @keywords Pedigree-plot
#' @importFrom ggplot2 annotate
#' @importFrom graphics lines
draw_arc <- function(
    x0, y0, x1, y1,
    p = NULL, ggplot_gen = FALSE,
    lwd = par("lwd"), lty = 2, col = "black"
) {
    xx <- seq(x0, x1, length = 15)
    yy <- seq(y0, y1, length = 15) + (seq(-7, 7))^2 / 98 - 0.5
    graphics::lines(xx, yy, lty = lty, lwd = lwd, col = col)
    if (ggplot_gen) {
        p <- p + ggplot2::annotate(
            "line", xx, yy, linetype = "dashed", colour = col
        )
    }
    return(p)
}

#' Draw arrows
#'
#' @inheritParams draw_segment
#'
#' @return Plot the arrows to the current device
#' or add it to a ggplot object
#' @keywords internal
#' @keywords Pedigree-plot
#' @importFrom ggplot2 annotate
#' @importFrom graphics lines
draw_arrow <- function(
    x0, y0, x1, y1,
    p = NULL, ggplot_gen = FALSE,
    lwd = par("lwd"), lty = 1, col = "black"
) {
    graphics::arrows(
        x0 = x0, y0 = y0, x1 = x1, y1 = y1,
        lwd = lwd, lty = lty, col = col, length = 0.1, angle = 30
    )
    if (ggplot_gen) {
        p <- p + suppressWarnings(ggplot2::geom_segment(ggplot2::aes(
            x = x0, y = y0, xend = x1, yend = y1
        ), arrow = ggplot2::arrow(length = unit(0.1, "inches")),
        size = lwd, colour = col))
    }
    return(p)
}


#' Draw arrows
#'
#' @inheritParams draw_segment
#'
#' @return Plot the arrows to the current device
#' or add it to a ggplot object
#' @keywords internal
#' @keywords Pedigree-plot
#' @importFrom ggplot2 annotate
#' @importFrom graphics lines
draw_point <- function(
    x, y,
    p = NULL, ggplot_gen = FALSE,
    cex = par("lwd"), pch = 1, col = "black"
) {
    graphics::points(
        x = x, y = y,
        cex = cex, pch = pch, col = col
    )
    if (ggplot_gen) {
        p <- p + suppressWarnings(ggplot2::geom_point(ggplot2::aes(
            x = x, y = y
        ), size = cex, colour = col))
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
#' @keywords internal
#' @keywords Pedigree-plot
#' @importFrom graphics par strwidth strheight
set_plot_area <- function(
    cex, id, maxlev, xrange, symbolsize, precision = 3, ...
) {
    old_par <- graphics::par(xpd = TRUE, ...)  ## took out mar=mar
    psize <- signif(graphics::par("pin"), precision)  # plot region in inches
    stemp1 <- signif(graphics::strwidth(
        "ABC", units = "inches", cex = cex
    ), precision) * 2.5 / 3
    stemp2 <- signif(graphics::strheight(
        "1g", units = "inches", cex = cex
    ), precision)
    stemp3 <- max(signif(
        graphics::strheight(id, units = "inches", cex = cex),
        precision
    ))

    ht1 <- signif(psize[2] / maxlev - (stemp3 + 1.5 * stemp2), precision)
    if (ht1 <= 0) {
        stop("Labels leave no room for the graph, reduce cex")
    }
    ht2 <- signif(psize[2] / (maxlev + (maxlev - 1) / 2), precision)
    wd2 <- signif(0.8 * psize[1] / (0.8 + diff(xrange)), precision)

    # box size in inches
    boxsize <- signif(
        symbolsize * min(ht1, ht2, stemp1, wd2),
        precision
    )
    # horizontal scale in inches
    hscale <- signif((psize[1] - boxsize) / diff(xrange), precision)
    vscale <- signif(
        (psize[2] - (stemp3 + stemp2 + boxsize)) /
            max(1, maxlev - 1), precision
    )
    # box width in user units
    boxw <- signif(boxsize / hscale, precision)
    # box height in user units
    boxh <- signif(boxsize / vscale, precision)
    # height of a text string
    labh <- signif(stemp2 / vscale, precision)
    # how tall are the 'legs' up from a child
    legh <- signif(min(1 / 4, boxh * 1.5), precision)

    usr <- c(xrange[1] - boxw / 2, xrange[2] + boxw / 2,
        maxlev + boxh + stemp3 / vscale + stemp2 / vscale, 1
    )
    list(usr = usr, old_par = old_par, boxw = boxw,
        boxh = boxh, labh = labh, legh = legh
    )
}
