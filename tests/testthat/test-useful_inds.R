test_that("useful_inds works", {
    data("sampleped")
    colnames(sampleped) <- c(
        "ped", "id", "dadid", "momid", "sex", "affected", "avail"
    )
    sampleped[c("id", "dadid", "momid")] <- as.data.frame(
        lapply(sampleped[c("id", "dadid", "momid")], as.character)
    )

    numdf <- with(sampleped,
        num_child(id, dadid, momid)
    )[c("id", "num_child_tot")]

    df <- merge(sampleped, numdf)
    use_id_avaff <- with(df,
        useful_inds(
            id, dadid, momid, avail,
            affected, num_child_tot, id[avail == 1]
        )
    )
    expect_equal(df$id[!df$id %in% use_id_avaff],
        c(
            "101", "102", "107", "108", "111", "117",
            "121", "122", "123", "131", "132", "134", "135",
            "136", "139", "205", "210", "213"
        )
    )
})

test_that("useful_inds works with Pedigree", {
    data("sampleped")
    ped <- Pedigree(sampleped)
    ped <- is_informative(ped, informative = "Av")
    ped <- useful_inds(ped, max_dist = 2)
    expect_equal(id(ped(ped))[useful(ped(ped)) == FALSE],
        c("1_107", "1_108")
    )

    expect_snapshot_error(
        suppressWarnings(useful_inds(ped))
    )
    ped <- is_informative(
        ped, informative = "AvOrAf",
        reset = TRUE, col_aff = "affection"
    )
    ped <- useful_inds(ped, max_dist = 2, reset = TRUE)
    expect_equal(id(ped(ped))[useful(ped(ped)) == 0], c("1_108"))

    data("minnbreast")
    pedi <- Pedigree(
        minnbreast,
        cols_ren_ped = c(
            indId = "id",
            fatherId = "fatherid",
            motherId = "motherid",
            family = "famid",
            gender = "sex"
        ), missid = "0"
    )
    pedi219 <- suppressWarnings(pedi[famid(ped(pedi)) == "219"])
    pedi219 <- generate_colors(
        pedi219, "cancer", is_num = FALSE, mods_aff = "1",
        add_to_scale = FALSE
    )

    pedi219 <- is_informative(pedi219, informative = "Af", col_aff = "cancer")
    pedi219 <- useful_inds(pedi219, max_dist = 3, reset = TRUE)
    pedi219u <- suppressWarnings(pedi219[useful(ped(pedi219))])

    id_inf <- c("219_26990", "219_8669")
    pedi219 <- is_informative(pedi219, informative = id_inf, reset = TRUE)
    pedi219 <- useful_inds(pedi219, max_dist = 1, reset = TRUE)
    pedi219u <- pedi219[useful(ped(pedi219))]
    pedi219u <- make_famid(pedi219u)
    expect_equal(length(pedi219), 382)
    expect_equal(length(pedi219u), 10)
    expect_equal(length(pedi219u[famid(ped(pedi219u)) == "1"]), 5)
})
