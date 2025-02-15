new_par <- list(
    bg = "transparent",
    usr = c(0, 1, 0, 1),
    fig = c(0, 1, 0, 1),
    mai = c(0, 0, 0, 0),
    mar = c(0, 0, 0, 0),
    pin = c(7, 7),
    plt = c(0, 1, 0, 1),
    xaxp = c(0, 4, 4),
    xpd = FALSE,
    yaxp = c(2, 2, 1),
    fin = c(7, 7),
    pty = "m"
)

test_that("Pedigree legend works", {
    data("sampleped")
    sampleped$val_num <- as.numeric(sampleped$id)
    pedi <- Pedigree(sampleped[-c(13, 15)])
    pedi <- pedi[ped(pedi, "famid") == "1"]
    famid(ped(pedi))[13] <- "1"
    ped2 <- pedi[ped(pedi, "id") != "1_113"]

    p1 <- align(pedi)
    p2 <- align(ped2)

    # TODO expect_equal(p1, p2)

    pedi <- generate_colors(pedi, add_to_scale = TRUE, "avail", mods_aff = TRUE)
    pedi <- generate_colors(pedi,
        add_to_scale = TRUE, "val_num", threshold = 115,
        colors_aff = c("pink", "purple"), keep_full_scale = TRUE
    )
    lst <- ped_to_legdf(pedi, boxh = 1, boxw = 1, cex = 0.8)
    expect_snapshot(lst)

    vdiffr::expect_doppelganger("Legend alone",
        function() {
            suppressWarnings(plot_legend(
                pedi, boxh = 0.07, boxw = 0.07, cex = 0.7,
                leg_loc = c(0, 0.9, 0, 0.9), adjx = 0, adjy = 0
            ))
        }
    )

    vdiffr::expect_doppelganger("Plot with legend",
        function() {
            suppressWarnings(plot(
                pedi[!is.na(famid(ped(pedi)))],
                cex = 0.8, symbolsize = 1.5, aff_mark = FALSE,
                legend = TRUE, leg_cex = 0.8, leg_symbolsize = 0.01,
                leg_loc = c(0.1, 1.6, 3.9, 3), leg_usr = c(0, 2, 4, 0),
                ped_par = list(oma = c(12, 1, 1, 1), mar = rep(0.5, 4)),
                leg_par = list(oma = c(1, 1, 1, 1), mar = rep(0.2, 4))
            ))
        }
    )
})
