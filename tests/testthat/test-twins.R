test_that("Incomplete twins set", {
    ped_df <- data.frame(
        id = c(1, 2, 3, 4, 5),
        dadid = c(0, 0, 1, 1, 1),
        momid = c(0, 0, 2, 2, 2),
        sex = c(1, 2, 1, 1, 1)
    )
    rel_df <- data.frame(
        id1 = c(3, 3),
        id2 = c(4, 5),
        code = c(1, 1)
    )
    pedi <- Pedigree(ped_df, rel_df, missid = 0)
    vdiffr::expect_doppelganger("Ped twins",
        function() {
            plot(pedi)
        }
    )
})
