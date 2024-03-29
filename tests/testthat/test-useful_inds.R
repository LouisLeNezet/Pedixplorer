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
        useful_inds(id, dadid, momid, avail, affected, num_child_tot)
    )
    expect_equal(df$id[!df$id %in% use_id_avaff],
        c("101", "102", "107", "108", "113", "117")
    )
})

test_that("useful_inds works with Pedigree", {
    data("sampleped")
    ped <- Pedigree(sampleped)

    ped <- useful_inds(ped, informative = "Av")
    expect_equal(id(ped(ped))[useful(ped(ped)) == 0],
        c("1_101", "1_102", "1_107", "1_108", "1_117")
    )

    expect_snapshot_error(useful_inds(ped, informative = "AvOrAf"))

    ped <- useful_inds(ped, informative = "AvOrAf", reset = TRUE)
    expect_equal(id(ped(ped))[useful(ped(ped)) == 0], c("1_101", "1_108"))

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
    pedi219 <- pedi[famid(ped(pedi)) == "219"]
    mcols(pedi219)
    pedi219 <- generate_colors(
        pedi219, "cancer", is_num = FALSE, mods_aff = "1",
        add_to_scale = FALSE
    )
    fill(pedi219)
    pedi219 <- useful_inds(pedi219, "Af", max_dist = 3, reset = TRUE)
    pedi219u <- pedi219[useful(ped(pedi219))]

    id_inf <- c("219_26990", "219_8669")
    pedi219 <- useful_inds(pedi219, id_inf, max_dist = 1, reset = TRUE)
    pedi219u <- pedi219[useful(ped(pedi219))]
    make_famid(pedi219u)
    plot(pedi219u)
})
