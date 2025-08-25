test_that("Pedigree plotting test", {
    ped2mat <- matrix(
        c(
            1, 1, 0, 0, 1, 1, 0,
            1, 2, 0, 0, 2, 0, 1,
            1, 3, 1, 2, 1, 0, 1,
            1, 4, 1, 2, 2, 1, 0,
            1, 5, 0, 0, 2, 1, 1,
            1, 6, 0, 0, 1, 0, 1,
            1, 7, 3, 5, 2, 0, 0,
            1, 8, 6, 4, 1, 1, 1,
            1, 9, 6, 4, 1, 0, 1,
            1, 10, 8, 7, 2, 0, 0
        ), ncol = 7, byrow = TRUE
    )
    ped2df <- as.data.frame(ped2mat)
    names(ped2df) <- c("famid", "id", "dadid", "momid",
        "sex", "affected", "avail"
    )

    ped2df$disease <- c(NA, NA, 1, 0, 0, 0, 0, 1, 1, 1)
    ped2df$smoker <- c(0, NA, 0, 0, 1, 1, 1, 0, 0, 0)
    ped2df$deceased <- c(1, 1, 1, 0, 1, 0, 0, 8, 0, 0)

    rel_df <- data.frame(id1 = 8, id2 = 9, code = 3, famid = 1)
    pedi <- Pedigree(ped2df, rel_df, missid = "0")
    vdiffr::expect_doppelganger("Ped simple affection",
        function() plot(pedi)
    )
    lst <- plot(
        pedi, label = "smoker",
        aff_mark = FALSE, ggplot_gen = TRUE,
        precision = 4
    )
    vdiffr::expect_doppelganger("Ped simple affection ggplot",
        function() plot(lst$ggplot)
    )

    pedi <- generate_colors(pedi, add_to_scale = TRUE,
        col_aff = "smoker", colors_aff = c("#00e6ee", "#c300ff")
    )

    lst <- ped_to_plotdf(pedi, precision = 4)
    expect_equal(length(lst), 3)
    expect_equal(dim(lst$df), c(82, 17))
    expect_snapshot(lst)
    expect_equal(
        round(lst$par_usr$usr, 3),
        c(-0.064, 3.064, 4.248, 1.000)
    )

    p <- plot(pedi, title = "Pedigree", ggplot_gen = TRUE, precision = 4)

    vdiffr::expect_doppelganger("Ped 2 affections ggplot",
        function() plot(p$ggplot)
    )
})

test_that("Pedigree fails to line up", {
    # Here is a case where the levels fail to line up properly
    data(sampleped)
    df1 <- sampleped[sampleped$famid == "1", ]
    ped1 <- Pedigree(df1)
    vdiffr::expect_doppelganger("ped1",
        function() suppressWarnings(plot(ped1, precision = 4))
    )

    expect_equal(
        suppressWarnings(plot(ped1, precision = 4))$ind_not_plot,
        c("1_113")
    )

    # With reordering it's better
    df1reord <- df1[c(35:41, 1:34), ]
    ped1reord <- Pedigree(df1reord)
    vdiffr::expect_doppelganger("ped1reorder",
        function() plot(ped1reord, precision = 4)
    )
})

test_that("Fix of vertical scaling", {
    # Simple trio with multiline labels
    pedi <- Pedigree(
        1:3, dadid = c(0, 0, 1), momid = c(0, 0, 2), sex = c(1, 2, 1),
        na_strings = 0
    )
    mcols(pedi)$labels <- c("1", "2", "3\n1/1\n1/1\n1/1\n1/1\n1/1\n1/1")

    vdiffr::expect_doppelganger("Ped scaling multiple label",
        function() {
            # Plot
            op <- par(mar = rep(2, 4), oma = rep(1, 4))
            plot(
                pedi, id_lab = "labels",
                ped_par = list(mar = rep(2, 4), oma = rep(1, 4))
            )
            par(op)
        }
    )
})

test_that("Tooltip works", {
    data(sampleped)
    pedi <- Pedigree(sampleped)
    p <- plot(
        pedi, ggplot_gen = TRUE, precision = 4,
        label = "num", tips = c("momid"), symbolsize = 1.5
    )$ggplot

    html_plot <- ggplotly(p, tooltip = "text") %>%
        plotly::layout(hoverlabel = list(bgcolor = "darkgrey"))

    expect_snapshot(html_plot)
})

test_that("Unpacked pedigree works", {
    data(sampleped)
    pedi <- Pedigree(sampleped)
    vdiffr::expect_doppelganger("Ped packed vs unpacked",
        function() {
            # Plot
            op <- par(mar = rep(0.75, 4), oma = rep(0.75, 4), mfrow = c(1, 2))
            plot(pedi, precision = 4, packed = FALSE, title = "Unpacked")
            par(new = TRUE)
            plot(pedi, precision = 4, packed = TRUE, title = "Packed")
            par(op)
        }
    )
})

test_that("Supplementary graphical representations", {
    data("sampleped")
    pedi <- Pedigree(sampleped)

    sex(ped(pedi))[id(ped(pedi)) %in% c("1_121")] <- "unknown"

    ## Fertility
    fertility(ped(pedi))[
        match(c("1_139", "1_129", "1_131", "1_111"), id(ped(pedi)))
    ] <- c(
        "infertile", "infertile",
        "infertile_choice_na", "infertile_choice_na"
    )

    ## Miscarriage
    miscarriage(ped(pedi))[
        match(c("1_124", "1_140", "1_133"), id(ped(pedi)))
    ] <- c("SAB", "TOP", "ECT")

    ## Evaluation
    evaluated(ped(pedi))[
        match(c("1_124", "1_140", "1_133"), id(ped(pedi)))
    ] <- TRUE

    consultand(ped(pedi))[
        match(c("1_104"), id(ped(pedi)))
    ] <- TRUE

    proband(ped(pedi))[
        match(c("1_111"), id(ped(pedi)))
    ] <- TRUE

    carrier(ped(pedi))[
        match(c("1_115"), id(ped(pedi)))
    ] <- TRUE
    plot(pedi)

    asymptomatic(ped(pedi))[
        match(c("1_130", "1_126"), id(ped(pedi)))
    ] <- TRUE

    adopted(ped(pedi))[
        match(c("1_130", "1_116"), id(ped(pedi)))
    ] <- TRUE

    vdiffr::expect_doppelganger("Ped with all annotations",
        function() {
            plot(pedi)
        }
    )

    vdiffr::expect_doppelganger("Ped with all annotations ggplot",
        function() {
            plot(pedi, ggplot_gen = TRUE)$ggplot
        }
    )
})

test_that("Pedigree example of Pascale - alone individual", {
    df_path <- paste0(testthat::test_path(), "/testdata/other_test.txt")
    df <- read_data(df_path, sep = "\t")

    df_fix <- fix_parents(df)
    pedi <- Pedigree(df_fix, missid = "0")

    pedi1 <- pedi[famid(ped(pedi)) == "1"]

    set.seed(123)
    hints(pedi1) <- best_hint(
        pedi1,
        align_parents = FALSE, force = TRUE,
        tolerance = 3000
    )
    vdiffr::expect_doppelganger("Ped Pascale",
        function() plot(pedi1, force = TRUE, align_parents = FALSE)
    )
})

test_that("Pedigree plot with different label distances & label cex", {
    data(sampleped)
    pedi <- Pedigree(sampleped)
    pedi1 <- pedi[famid(ped(pedi)) == "1"]

    expect_error(
        plot(pedi1, label = "num", label_dist = 0.5),
        "label_dist must be a vector of length 3"
    )
    expect_error(
        plot(pedi1, label = "num", label_dist = c(1, 2, "3")),
        "label_dist must be a numeric vector"
    )
    expect_error(
        plot(pedi1, label = "num", label_cex = 0.5),
        "label_cex must be a vector of length 3"
    )
    expect_error(
        plot(pedi1, label = "num", label_cex = c(1, 2, "3")),
        "label_cex must be a numeric vector with positive values"
    )
    expect_error(
        plot(pedi1, label = "num", label_cex = c(1, 2, -1)),
        "label_cex must be a numeric vector with positive values"
    )

    vdiffr::expect_doppelganger("Ped with different label distances",
        function() {
            plot(
                pedi1, cex = 0.7, label = "num",
                label_cex = c(0.8, 0.6, 2), # Change labels text size
                label_dist = c(1, 5, 2.5) # Change labels distance + order
            )
        }
    )
})

test_that("Pedigree ggplot with legend", {
    data(sampleped)
    pedi <- Pedigree(sampleped)
    pedi1 <- pedi[famid(ped(pedi)) == "1"]

    plot_lst <- plot_legend(pedi1, ggplot_gen = TRUE, add_to_existing = FALSE)
    plot_lst$ggplot
    vdiffr::expect_doppelganger("Ped with legend default",
        function() {
            plot_lst$ggplot
        }
    )

    vdiffr::expect_doppelganger("Ped with legend custom",
        function() {
            plot(
                pedi1, legend = TRUE,
                leg_cex = 0.5, leg_symbolsize = 0.3,
                leg_loc = c(0, 2, 0, 2),
                leg_adjx = 0.2, leg_adjy = -0.2
            )
        }
    )

    vdiffr::expect_doppelganger("Ped with legend ggplot",
        function() {
            plot(
                pedi1, legend = TRUE,
                ggplot_gen = TRUE
            )$ggplot
        }
    )
})