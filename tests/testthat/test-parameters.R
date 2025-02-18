test_that("Evaluate par()", {
    expect_snapshot(par())
})

test_that("Evaluate options()", {
    opts <- options()
    no_check <- c(
        "rlang_trace_top_env", "testthat_topenv",
        "topLevelEnvironment",
        "callr.condition_handler_cli_message",
        "page_viewer", "viewer",
        "device", "diffobj\\.*",
        "devtools.ellipsis_action",
        "vsc\\.*", "HTTPUserAgent",
        "bitmapType", "browser",
        "devtools\\.*", "dvipscmd",
        "editor", "help_type",
        "install.packages.compile.from.source",
        "printcmd", "rl_word_breaks",
        "texi2dvi", "windowsTimeouts",
        "testthat.snapshotter",
        "datatable\\.*"
    )
    opts$str$formatNum <- NA
    for (i in seq_along(no_check)) {
        opts <- opts[!stringr::str_detect(names(opts), no_check[i])]
    }
    expect_snapshot(opts)
})
