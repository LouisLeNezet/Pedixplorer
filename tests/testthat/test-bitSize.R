test_that("bit_size works", {
    data(minnbreast)
    minnped <- Pedigree(minnbreast, cols_ren_ped = list(
        "dadid" = "fatherid", "momid" = "motherid"
    ), missid = "0")
    bs_pedi <- bit_size(minnped)
    bs_char <- bit_size(
        as.character(minnbreast$fatherid),
        as.character(minnbreast$motherid),
        missid = "0"
    )

    pedi <- with(minnbreast,
        Ped(id, fatherid, motherid, sex = sex, missid = "0")
    )
    bs_ped <- bit_size(pedi)

    expect_equal(bs_ped, bs_char)
    expect_equal(bs_pedi, bs_char)
})
