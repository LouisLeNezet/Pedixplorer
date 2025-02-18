test_that("Evaluate par()", {
    expect_snapshot(par())
})

test_that("Evaluate options()", {
    opts <- options()
    no_check <- c(
        "rlang_trace_top_env", "testthat_topenv",
        "topLevelEnvironment"
    )
    expect_snapshot(opts[!names(opts) %in% no_check])
})
