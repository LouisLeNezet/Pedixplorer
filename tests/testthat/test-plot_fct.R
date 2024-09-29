test_that("subregion works", {
    df <- data.frame(x2 = 1:10, y0 = 1:10, x1 = 2:11, y1 = 2:11)
    expect_equal(subregion(df), df)
    expect_error(subregion(df, c(1, 2, 3, 4, 5)))
    df <- data.frame(x0 = 1:10, y0 = 1:10, x1 = 2:11, y1 = 2:11)
    expect_equal(nrow(subregion(df, c(1, 5, 3, 5))), 2)

    data("sampleped")
    pedi <- Pedigree(sampleped[sampleped$famid == 1, ])
    lst <- ped_to_plotdf(pedi, precision = 2)
    expect_snapshot(lst$df)
    df_subreg <- subregion(lst$df, c(6, 14, 2, 3))
    expect_equal(max(df_subreg$x1, na.rm = TRUE), 14)
    expect_true(max(df_subreg$y1, na.rm = TRUE) < 3)
    expect_equal(min(df_subreg$x0, na.rm = TRUE), 6)
    expect_equal(min(df_subreg$y0, na.rm = TRUE), 2)
    vdiffr::expect_doppelganger(
        "subregion", function() plot(pedi, subreg = c(7, 14.5, 1.5, 3.5))
    )
})

test_that("circfun works", {
    expect_equal(length(circfun(1)), 1)
    expect_equal(length(circfun(2)), 2)
    expect_equal(length(circfun(1)[[1]]$x), 51)
    expect_equal(length(circfun(3, 70)[[2]]$x), 25)
})

test_that("polyfun works", {
    coor <- list(
        x = c(-0.5, -0.5, 0.5, 0.5),
        y = c(-0.5, 0.5, 0.5, -0.5),
        theta = -c(3, 5, 7, 9) * pi / 4
    )
    expect_equal(length(polyfun(1, coor)), 1)
    expect_equal(length(polyfun(2, coor)), 2)
})

test_that("polygons works", {
    expect_equal(
        names(polygons(1)),
        c("square", "circle", "diamond", "triangle")
    )
    expect_equal(length(polygons(2)$square), 2)
})

test_that("plotting functions works", {
    plot(c(0, 10), c(0, 10))
    p <- ggplot() +
        ggplot2::geom_point(aes(x = seq(1, 10), y = seq(1, 10)))
    p <- draw_segment(
        0, 0, 2, 2, p = p, ggplot_gen = TRUE
    )
    p <- draw_segment(
        0, 0, 2, 0,
        col = "red", lwd = 2, lty = 3,
        p = p, ggplot_gen = TRUE
    )
    p <- draw_polygon(
        c(2, 2, 3, 3), c(2, 3, 3, 2),
        density = 5, p = p, ggplot_gen = TRUE
    )
    p <- draw_polygon(
        c(5, 6, 6, 7), c(8, 9, 10, 9),
        fill = "brown", border = "green",
        density = 5, p = p, ggplot_gen = TRUE
    )

    p <- draw_text(
        4, 5, "text",
        col = "blue", cex = 2,
        p = p, ggplot_gen = TRUE
    )
    p <- draw_arc(
        4, 6, 8, 8,
        col = "green", lwd = 4,
        p = p, ggplot_gen = TRUE
    )
    vdiffr::expect_doppelganger("plotting functions works", p)
})

test_that("set_plot_area works", {
    expect_snapshot(set_plot_area(2, c("Test", "Test2"), 3, c(0, 10), 1))
})
