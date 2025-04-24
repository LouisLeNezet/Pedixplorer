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
    expect_equal(length(lst), 2)
    expect_equal(dim(lst$df), c(82, 16))
    expect_snapshot(lst)
    expect_equal(
        round(lst$par_usr$usr, 3),
        c(-0.063, 3.063, 4.248, 1.000)
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
        function() plot(ped1, precision = 4)
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
