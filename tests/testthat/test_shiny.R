test_that("color_picker works", {
    app <- AppDriver$new(
        color_picker_demo(), name = "color_picker",
        variant = platform_variant()
    )
    app$set_window_size(width = 1611, height = 956)
    # Check the initial values
    app$expect_values(export = TRUE)
    # Update output value
    app$set_inputs(`colors-select_Val1` = "#060A24")
    # Update output value
    app$set_inputs(`colors-select_Val2` = "#FF00DD")
    # Check the exported values
    app$expect_values(export = TRUE)
})

test_that("data_col_sel works", {
    app <- AppDriver$new(
        data_col_sel_demo(), name = "data_col_sel",
        variant = platform_variant()
    )
    app$set_window_size(width = 1611, height = 956)
    # Check the initial values
    app$expect_values(export = TRUE)
    # Update output value
    app$set_inputs(`datafile-select_Need2` = "hp")
    # Update output value
    app$set_inputs(`datafile-select_Supl1` = "drat")
    # Check the exported values
    app$expect_values(export = TRUE)
})

test_that("data_download works", {
    app <- AppDriver$new(
        data_download_demo(), name = "data_download",
        variant = platform_variant()
    )
    app$set_window_size(width = 1611, height = 956)
    # Check download
    app$expect_download("datafile-data_dwld")
})

test_that("data_import with default data", {
    app <- AppDriver$new(
        data_import_demo(), name = "data_import",
        variant = platform_variant()
    )
    app$set_window_size(width = 1611, height = 956)
    # Uploaded file outside of: ./tests/testthat
    app$upload_file(`my_data_import-fileinput` = "sampleped.tab")
    # Update output value
    app$set_inputs(`my_data_import-sep` = " ")
    # Update output value
    app$click("my_data_import-options")
    app$set_inputs(`my_data_import-stringsAsFactors` = TRUE)
    app$set_inputs(`my_data_import-heading` = FALSE)
    app$set_inputs(`my_data_import-to_char` = TRUE)
    app$set_inputs(`my_data_import-quote` = "'")
    app$click("my_data_import-close")
    # Update output value
    app$expect_values(export = TRUE)
    app$click("my_data_import-testdf")
    # Update output value
    app$expect_values(export = TRUE)
})
