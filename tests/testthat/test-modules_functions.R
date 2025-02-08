test_that("read_data works", {
    df_path <- paste0(testthat::test_path(), "/testdata/sampleped.rda")
    df <- read_data(df_path, df_name = "sampleped")
    expect_equal(dim(df), c(55, 7))

    df_path <- paste0(testthat::test_path(), "/testdata/sampleped.ped")
    df <- read_data(df_path, sep = "\t")
    expect_equal(dim(df), c(5, 6))

    df_path <- paste0(testthat::test_path(), "/testdata/sampleped.tab")
    df <- read_data(df_path, sep = " ")
    expect_equal(dim(df), c(55, 7))
})
