test_that("Evaluate par()", {
    expect_snapshot(par())
})

test_that("Evaluate options()", {
    expect_snapshot(options())
})
