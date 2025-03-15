#' @importFrom plyr rbind.fill
NULL

#' Create plotting data frame from a Pedigree
#'
#' @description
#' Convert a Pedigree to a data frame with all the elements and their
#' characteristic for them to be plotted afterwards with
#' [plot_fromdf()].
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
#'
#' @inheritParams align
#' @param pconnect When connecting parent to children the program will try to
#' make the connecting line as close to vertical as possible, subject to it
#' lying inside the endpoints of the line that connects the children by at
#' least `pconnect` people.  Setting this option to a large number will
#' force the line to connect at the midpoint of the children.
#' @param branch defines how much angle is used to connect various levels of
#' nuclear families.
#' @param aff_mark If `TRUE`, add a aff_mark to each box corresponding to the
#' value of the affection column for each filling scale.
#' @param id_lab The column name of the id for each individuals.
#' @param label If not `NULL`, add a label to each box under the id
#' corresponding to the value of the column given.
#' @param lwd default=par("lwd"). Controls the line width of the
#' segments, arcs and polygons.
#' @param tips A character vector of the column names of the data frame to
#' use as tooltips. If `NULL`, no tooltips are added.
#' @param ... Other arguments passed to [par()]
#' @inheritParams set_plot_area
#' @inheritParams kindepth
#'
#' @return A list containing the data frame and the user coordinates.
#'
#' @examples
#'
#' data(sampleped)
#' ped1 <- Pedigree(sampleped[sampleped$famid == 1,])
#' plot_df <- ped_to_plotdf(ped1)
#' summary(plot_df$df)
#' plot_fromdf(plot_df$df, usr = plot_df$par_usr$usr,
#'     boxh = plot_df$par_usr$boxh, boxw = plot_df$par_usr$boxw
#' )
#' @importFrom plyr rbind.fill
#' @seealso
#' [plot_fromdf()]
#' [ped_to_legdf()]
#' @keywords internal, Pedigree-plot
#' @export
#' @usage NULL
setGeneric(
    "ped_to_plotdf", signature = "obj",
    function(obj, ...) {
        standardGeneric("ped_to_plotdf")
    }
)

#' @rdname ped_to_plotdf
#' @export
#' @importFrom plyr rbind.fill
setMethod("ped_to_plotdf", "Pedigree", function(
    obj, packed = TRUE, width = 6,
    align = c(1.5, 2), align_parents = TRUE, force = FALSE,
    cex = 1, symbolsize = cex, pconnect = 0.5, branch = 0.6,
    aff_mark = TRUE, id_lab = "id", label = NULL, precision = 4,
    lwd = par("lwd"), tips = NULL, ...
) {

    famlist <- unique(famid(ped(obj)))
    famlist <- famlist[!is.na(famlist)]
    if (length(famlist) > 1) {
        message("Multiple families present, computing each family separately")
        all_df <- list()
        for (i_fam in famlist) {
            ped_fam <- obj[famid(ped(obj)) == i_fam]
            all_df[[i_fam]] <- ped_to_plotdf(ped_fam, packed, width, align,
                align_parents, force,
                cex, symbolsize, ...
            )
        }
        return(all_df)
    }

    plot_df <- data.frame(
        id = character(),
        x0 = numeric(), y0 = numeric(), x1 = numeric(), y1 = numeric(),
        type = character(), fill = character(), border = character(),
        angle = numeric(), density = numeric(), cex = numeric(),
        label = character(), tips = character(),
        adjx = numeric(), adjy = numeric(), lty = numeric()
    )
    plist <- align(
        obj, packed = packed, width = width,
        align = align, align_parents = align_parents,
        force = force, precision = precision
    )

    xrange <- range(plist$pos[plist$nid > 0])
    maxlev <- nrow(plist$pos)

    labels <- unname(unlist(as.data.frame(ped(obj))[c(id_lab, label)]))

    params_plot <- set_plot_area(
        cex, labels, maxlev, xrange, symbolsize, precision, ...
    )

    boxw <- params_plot$boxw
    boxh <- params_plot$boxh
    labh <- params_plot$labh
    legh <- params_plot$legh

    #### Get all boxes to plot ####
    # idx is the index of the boxes in the alignment
    idx <- which(plist$nid > 0)
    # index value in the ped of each box
    id <- plist$nid
    # x position
    pos <- plist$pos
    # y position
    i <- (seq_len(length(plist$nid)) - 1) %% length(plist$n) + 1

    all_aff <- fill(obj)
    n_aff <- length(unique(fill(obj)$order))
    polylist <- polygons(max(1, n_aff))

    ped_df <- as.data.frame(ped(obj))
    ped_df$tips <- create_text_column(ped_df, id_lab, c(label, tips))

    for (aff in seq_len(n_aff)) {
        aff_df <- all_aff[all_aff$order == aff, ]
        aff_mods <- ped_df[id[idx], unique(aff_df[["column_mods"]])]
        aff_norm <- match(aff_mods, aff_df[["mods"]])

        # border mods of each box
        border_mods <- ped_df[id[idx], unique(border(obj)$column_mods)]
        border_idx <- match(border_mods, border(obj)$mods)

        # Set sex and miscarriage symbols
        ped_df$sex <- as.numeric(ped_df$sex)
        ped_df$sex[ped_df$miscarriage != "FALSE"] <- 4
        sex <- ped_df$sex[id[idx]]

        # mean range of each box for each polygon for each subreg
        poly_aff <- lapply(polylist, "[[", aff)
        poly_aff_x <- lapply(poly_aff, "[[", "x")

        poly_aff_x_mr <- vapply(poly_aff_x,
            function(x) mean(range(x * boxw)),
            1
        )

        ind <- data.frame(
            x0 = pos[idx], y0 = i[idx],
            type = paste(names(polylist)[sex], n_aff, aff, sep = "_"),
            fill = aff_df[aff_norm, "fill"],
            density = aff_df[aff_norm, "density"],
            angle = aff_df[aff_norm, "angle"],
            border = border(obj)$border[border_idx],
            cex = lwd, tips = ped_df[id[idx], "tips"],
            id = "polygon"
        )
        plot_df <- plyr::rbind.fill(plot_df, ind)
        if (aff_mark) {
            aff_mark_df <- data.frame(
                x0 = pos[idx] + poly_aff_x_mr[sex],
                y0 = i[idx] + boxh / 2,
                label = ped_df[id[idx], unique(aff_df[["column_values"]])],
                fill = "black", adjx = 0.5, adjy = 0.5,
                type = "text", cex = cex, tips = ped_df[id[idx], "tips"],
                id = "aff_mark"
            )
            plot_df <- plyr::rbind.fill(plot_df, aff_mark_df)
        }
    }

    #### Add infertility status ####
    infertile <- ped_df[id[idx], "fertility"]
    idx_iftl_all <- idx[infertile != "fertile"]
    idx_iftl <- idx[infertile == "infertile"]

    if (length(idx_iftl_all) > 0) {
        iftl_df_vert <- data.frame(
            x0 = pos[idx_iftl_all], y0 = i[idx_iftl_all] + boxh,
            x1 = pos[idx_iftl_all], y1 = i[idx_iftl_all] + boxh * 1.3,
            type = "segments", fill = "black", cex = lwd,
            id = "infertile"
        )

        iftl_df_hori <- data.frame(
            x0 = pos[idx_iftl_all] - (boxw / 2) * 0.8,
            y0 = i[idx_iftl_all] + boxh * 1.3,
            x1 = pos[idx_iftl_all] + (boxw / 2) * 0.8,
            y1 = i[idx_iftl_all] + boxh * 1.3,
            type = "segments", fill = "black", cex = lwd,
            id = "infertile"
        )

        plot_df <- rbind.fill(plot_df, iftl_df_vert, iftl_df_hori)

        if (length(idx_iftl) > 0) {
            iftl_df_hori_2 <- data.frame(
                x0 = pos[idx_iftl] - (boxw / 2),
                y0 = i[idx_iftl] + boxh * 1.4,
                x1 = pos[idx_iftl] + (boxw / 2),
                y1 = i[idx_iftl] + boxh * 1.4,
                type = "segments", fill = "black", cex = lwd,
                id = "infertile"
            )
            plot_df <- plyr::rbind.fill(plot_df, iftl_df_hori_2)
        }
    }

    #### Add miscarriage symbols ####
    miscarriage <- ped_df[id[idx], "miscarriage"]
    idx_mscr <- idx[miscarriage %in% c("ECT", "TOP")]
    if (length(idx_mscr) > 0) {
        mscr_df <- data.frame(
            x0 = pos[idx_mscr] - 0.5 * boxw, y0 = i[idx_mscr] + 1 * boxh,
            x1 = pos[idx_mscr] + 0.5 * boxw, y1 = i[idx_mscr],
            type = "segments", fill = "black", cex = lwd,
            id = "ECT-TOP"
        )
        plot_df <- plyr::rbind.fill(plot_df, mscr_df)
    }

    #### Add ectopic pregnancy symbol symbols ####
    idx_mscr_ect <- idx[miscarriage %in% c("ECT")]
    if (length(idx_mscr_ect) > 0) {
        mscr_ect_df <- data.frame(
            x0 = pos[idx_mscr_ect], y0 = i[idx_mscr_ect] + boxh,
            label = "ECT", fill = "black",
            type = "text", cex = cex * 0.8,
            adjx = 0.5, adjy = 1,
            id = "ECT"
        )
        plot_df <- plyr::rbind.fill(plot_df, mscr_ect_df)
    }

    #### Add deceased status ####
    deceased <- ped_df[id[idx], "deceased"]
    idx_dead <- idx[deceased == 1 & !is.na(deceased)]

    if (length(idx_dead) > 0) {
        dead_df <- data.frame(
            x0 = pos[idx_dead] - 0.6 * boxw, y0 = i[idx_dead] + 1.1 * boxh,
            x1 = pos[idx_dead] + 0.6 * boxw, y1 = i[idx_dead] - 0.1 * boxh,
            type = "segments", fill = "black", cex = lwd,
            id = "dead"
        )

        plot_df <- plyr::rbind.fill(plot_df, dead_df)
    }

    #### Add evaluated status ####
    evaluated <- ped_df[id[idx], "evaluated"]
    idx_eval <- idx[evaluated]

    if (length(idx_eval) > 0) {
        eval_df <- data.frame(
            x0 = pos[idx_eval] + (boxw / 2) + (boxw / 5),
            y0 = i[idx_eval] - boxh / 10, fill = "black",
            label = "*", type = "text", cex = cex * 1.5,
            adjx = 0.5, adjy = 0.5, id = "evaluated"
        )

        plot_df <- plyr::rbind.fill(plot_df, eval_df)
    }

    #### Add consultband and proband status ####
    consultand <- ped_df[id[idx], "consultand"]
    proband <- ped_df[id[idx], "proband"]
    idx_cons <- idx[consultand | proband]

    if (length(idx_cons) > 0) {
        cons_df <- data.frame(
            x0 = pos[idx_cons] - boxw * 0.8,
            y0 = i[idx_cons] + boxh * 1.4,
            x1 = pos[idx_cons] - (boxw / 2),
            y1 = i[idx_cons] + boxh * 1.075,
            type = "arrows", cex = lwd,
            id = "consultand-proband", fill = "black"
        )

        plot_df <- plyr::rbind.fill(plot_df, cons_df)
    }

    idx_prob <- idx[proband]
    if (length(idx_prob) > 0) {
        prob_df <- data.frame(
            x0 = pos[idx_prob] - boxw,
            y0 = i[idx_prob] + boxh * 1.3,
            fill = "black",
            label = "P", type = "text", cex = cex,
            adjx = 0.5, adjy = 0.5, id = "proband"
        )

        plot_df <- plyr::rbind.fill(plot_df, prob_df)
    }

    #### Add carriers status ####
    carrier <- ped_df[id[idx], "carrier"]
    idx_carrier <- idx[carrier & !is.na(carrier)]
    if (length(idx_carrier) > 0) {
        carrier_df <- data.frame(
            x0 = pos[idx_carrier], y0 = i[idx_carrier] + (boxh / 2),
            type = "points", fill = "black", lty = 19,
            cex = lwd * (boxh + boxw) / 2 * 5,
            id = "carrier"
        )

        plot_df <- plyr::rbind.fill(plot_df, carrier_df)
    }

    #### Add asymptomatic status ####
    asymptomatic <- ped_df[id[idx], "asymptomatic"]
    idx_asym <- idx[asymptomatic & !is.na(asymptomatic)]
    if (length(idx_asym) > 0) {
        asym_df <- data.frame(
            x0 = pos[idx_asym], y0 = i[idx_asym] + boxh,
            x1 = pos[idx_asym], y1 = i[idx_asym],
            type = "segments", fill = "black",
            cex = lwd * 2.5,
            id = "asymptomatic"
        )

        plot_df <- plyr::rbind.fill(plot_df, asym_df)
    }

    #### Add adopted status ####
    adopted <- ped_df[id[idx], "adopted"]
    idx_adop <- idx[adopted]
    if (length(idx_asym) > 0) {
        h1 <- 0.8
        v1 <- 1.1
        v2 <- -0.1
        h2 <- 0.6
        adop_df_v <- data.frame(
            x0 = rep(pos[idx_adop], each = 2) + boxw * c(-h1, h1),
            y0 = rep(i[idx_adop], each = 2) + boxh * c(v1, v1),
            x1 = rep(pos[idx_adop], each = 2) + boxw * c(-h1, h1),
            y1 = rep(i[idx_adop], each = 2) + boxh * c(v2, v2),
            type = "segments", fill = "black",
            cex = lwd,
            id = "adoption"
        )

        adop_df_h <- data.frame(
            x0 = rep(pos[idx_adop], each = 4) + boxw * c(h1, h1, -h1, -h1),
            y0 = rep(i[idx_adop], each = 4) + boxh * c(v1, v2, v1, v2),
            x1 = rep(pos[idx_adop], each = 4) + boxw * c(h2, h2, -h2, -h2),
            y1 = rep(i[idx_adop], each = 4) + boxh * c(v1, v2, v1, v2),
            type = "segments", fill = "black",
            cex = lwd,
            id = "adoption"
        )

        plot_df <- plyr::rbind.fill(plot_df, adop_df_v, adop_df_h)
    }

    #### Add ids ####
    id_pos <- 1.4
    id_df <- data.frame(
        x0 = pos[idx], y0 = i[idx] + boxh * id_pos + labh,
        label = ped_df[id[idx], id_lab], fill = "black",
        type = "text", cex = cex, adjx = 0.5, adjy = 1,
        id = "id", tips = ped_df[id[idx], "tips"]
    )
    plot_df <- plyr::rbind.fill(plot_df, id_df)

    #### Add dates ####
    dates <- ped_df[id[idx], c("id", "dateofbirth", "dateofdeath")]
    idx_dates <- idx[!is.na(dates$dateofbirth) | !is.na(dates$dateofdeath)]

    if (length(idx_dates) > 0) {
        dates_char <- with(ped_df[id[idx_dates], ], paste(
            ifelse(
                is.na(dateofbirth), "",
                format(as.Date(dateofbirth), "%Y")
            ),
            ifelse(
                is.na(dateofdeath), "",
                format(as.Date(dateofdeath), "%Y")
            ), sep = " - "
        ))
        dates_df <- data.frame(
            x0 = pos[idx_dates], y0 = i[idx_dates] + boxh * id_pos + labh * 3,
            label = dates_char, fill = "black",
            type = "text", cex = cex * 0.7, adjx = 0.5, adjy = 1,
            id = "id", tips = ped_df[id[idx_dates], "tips"]
        )
        plot_df <- plyr::rbind.fill(plot_df, dates_df)
    }

    #### Add a label if given ####
    if (!is.null(label)) {
        check_columns(ped_df, label)
        label <- data.frame(
            x0 = pos[idx], y0 = i[idx] + boxh * id_pos + labh * 5,
            label = ped_df[id[idx], label],
            fill = "black", adjy = 1, adjx = 0.5,
            type = "text", cex = cex,
            id = "label", tips = ped_df[id[idx], "tips"]
        )
        plot_df <- plyr::rbind.fill(plot_df, label)
    }

    #### Add lines between spouses ####
    spouses <- which(plist$spouse > 0)
    l_spouses_i <- i[spouses] + boxh / 2
    pos_sp1 <- pos[spouses] + boxw / 2
    pos_sp2 <- pos[spouses + maxlev] - boxw / 2

    l_spouses <- data.frame(
        x0 = pos_sp1, y0 = l_spouses_i,
        x1 = pos_sp2, y1 = l_spouses_i,
        type = "segments", fill = "black", cex = lwd,
        id = "line_spouses"
    )
    plot_df <- plyr::rbind.fill(plot_df, l_spouses)

    #### Add doubles mariage ####
    spouses2 <- which(plist$spouse == 2)
    if (length(spouses2) > 0) {
        l_spouses2_i <- i[spouses2] + boxh / 2 + boxh / 10
        pos_sp21 <- pos[spouses2]
        pos_sp22 <- pos[spouses2 + maxlev]
        l_spouses2 <- data.frame(
            x0 = pos_sp21 + boxw / 2,
            y0 = l_spouses2_i,
            x1 = pos_sp22 - boxw / 2,
            y1 = l_spouses2_i,
            type = "segments", fill = "black", cex = lwd,
            id = "line_spouses2"
        )
        plot_df <- plyr::rbind.fill(plot_df, l_spouses2)
    }

    #### Children to parents lines ####
    for (gen in seq_len(maxlev)) {
        zed <- unique(plist$fam[gen, ])
        zed <- zed[zed > 0]  # list of family ids
        for (fam in zed) {
            xx <- pos[gen - 1, fam + 0:1]
            parentx <- mean(xx)  # midpoint of parents

            # Get the horizontal end points of the childrens
            who <- (plist$fam[gen, ] == fam)  # The kids of interest
            if (is.null(plist$twins)) {
                # If no twins, just use the position of the children
                target <- plist$pos[gen, who]
            } else {
                # If twins, use the midpoint of the twins
                twin_to_left <- (c(0, plist$twins[gen, who])[seq_len(sum(who))])
                # increment if no twin to the left
                temp <- cumsum(twin_to_left == 0)
                # 5 sibs, middle 3 are triplets gives 1,2,2,2,3 twin, twin,
                # singleton gives 1,1,2,2,3
                tcount <- table(temp)
                target <- rep(tapply(plist$pos[gen, who], temp, mean), tcount)
            }
            yy <- rep(gen, sum(who)) # Vertical start height

            ## Add the vertical lines from children to midline
            vert <- data.frame(
                x0 = pos[gen, who], y0 = yy,
                x1 = target, y1 = yy - legh,
                type = "segments", fill = "black", cex = lwd,
                id = "line_children_vertical"
            )
            plot_df <- plyr::rbind.fill(plot_df, vert)

            ## Draw horizontal MZ twin line
            if (any(plist$twins[gen, who] == 1)) {
                who2 <- which(plist$twins[gen, who] == 1)
                temp1 <- (pos[gen, who][who2] + target[who2]) / 2
                temp2 <- (pos[gen, who][who2 + 1] + target[who2]) / 2
                # Horizontal line at mid point of leg height
                yy <- rep(gen, length(who2)) - legh / 2
                twin_l <- data.frame(
                    x0 = temp1, y0 = yy,
                    x1 = temp2, y1 = yy,
                    type = "segments", fill = "black", cex = lwd,
                    id = "line_children_twin1"
                )
                plot_df <- plyr::rbind.fill(plot_df, twin_l)
            }

            # Add a question aff_mark for those of unknown zygosity
            if (any(plist$twins[gen, who] == 3)) {
                who2 <- which(plist$twins[gen, who] == 3)
                temp1 <- (pos[gen, who][who2] + target[who2]) / 2
                temp2 <- (pos[gen, who][who2 + 1] + target[who2]) / 2
                yy <- rep(gen, length(who2)) - legh / 2
                twin_lab <- data.frame(
                    x0 = (temp1 + temp2) / 2, y0 = yy,
                    label = "?", fill = "black",
                    type = "text", cex = cex,
                    adjx = 0.5, adjy = 0.5,
                    id = "label_children_twin3"
                )
                plot_df <- plyr::rbind.fill(plot_df, twin_lab)
            }

            # Add the horizontal line
            hori <- data.frame(
                x0 = min(target), y0 = gen - legh,
                x1 = max(target), y1 = gen - legh,
                type = "segments", fill = "black", cex = lwd,
                id = "line_children_horizontal"
            )
            plot_df <- plyr::rbind.fill(plot_df, hori)

            # Draw line to parents.  The original rule corresponded to
            # pconnect a large number, forcing the bottom of each
            # parent-child line to be at the center of the bar uniting
            # the children.
            if (diff(range(target)) < 2 * pconnect) {
                x1 <- mean(range(target))
            } else {
                x1 <- pmax(min(target) + pconnect,
                    pmin(max(target) - pconnect, parentx)
                )
            }
            y1 <- gen - legh
            ## Add the parent to mid line
            if (branch == 0) {
                l_child_par <- data.frame(
                    x0 = x1, y0 = y1,
                    x1 = parentx, y1 = (gen - 1) + boxh / 2,
                    type = "segments", fill = "black", cex = lwd,
                    id = "line_parent_mid"
                )
            } else {
                y2 <- (gen - 1) + boxh / 2
                x2 <- parentx
                ydelta <- ((y2 - y1) * branch) / 2
                l_child_par <- data.frame(
                    x0 = c(x1, x1, x2), y0 = c(y1, y1 + ydelta, y2 - ydelta),
                    x1 = c(x1, x2, x2), y1 = c(y1 + ydelta, y2 - ydelta, y2),
                    type = "segments", fill = "black", cex = lwd,
                    id = "line_parent_mid"
                )
            }
            plot_df <- plyr::rbind.fill(plot_df, l_child_par)
        }
    }  ## end of parent-child lines

    uid_all <- unique(plist$nid[plist$nid > 0])
    ## JPS 4/27/17: unique above only applies to rows unique added to
    ## for loop iterator
    uid <- 8
    for (uid in uid_all) {
        indx <- which(plist$nid == uid)
        if (length(indx) > 1) {
            # subject is a multiple
            tx <- plist$pos[indx]
            ty <- ((row(plist$pos))[indx])[order(tx)]
            tx <- sort(tx)
            for (j in seq_len(length(indx) - 1)) {
                arc <- data.frame(
                    x0 = tx[j + 0], y0 = ty[j + 0],
                    x1 = tx[j + 1], y1 = ty[j + 1],
                    type = "arc", fill = "black", cex = lwd,
                    id = "arc"
                )
                plot_df <- plyr::rbind.fill(plot_df, arc)
            }
        }
    }

    #### Keep only significant numbers ####
    x0 <- y0 <- x1 <- y1 <- numeric()
    plot_df <- plot_df %>%
        mutate(
            x0 = signif(x0, precision), y0 = signif(y0, precision),
            x1 = signif(x1, precision), y1 = signif(y1, precision)
        )


    list(df = plot_df, par_usr = params_plot)
})
