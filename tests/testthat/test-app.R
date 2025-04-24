if (Sys.getenv("SKIP_SHINY_TESTS") == "TRUE") {
    skip("Skipping shiny test")
}


test_that("ped_shiny works", {
    app <- shinytest2::AppDriver$new(
        ped_shiny(precision = 4), name = "ped_shiny",
        variant = shinytest2::platform_variant()
    )
    app$set_window_size(width = 1611, height = 956)

    # Import data
    app$click("data_ped_import-testdf")
    app$click("data_rel_import-testdf")

    # Set affection and color
    app$wait_for_idle(timeout = 30000)
    df <- app$wait_for_value(export = "df")
    app$set_inputs(`health_sel-health_as_num` = FALSE)
    app$wait_for_idle()
    app$set_inputs(`health_sel-health_aff_mods` = "1")
    app$wait_for_idle()
    app$set_inputs(`col_aff-select_Affected` = "#63005B")
    df <- app$set_inputs(`col_avail-select_Avail` = "#00FFFF")
    app$wait_for_idle()
    app$set_inputs(
        `family_sel-families_table_rows_selected` = 2,
        allow_no_input_binding_ = TRUE
    )
    app$set_inputs(
        `family_sel-families_table_row_last_clicked` = 2,
        allow_no_input_binding_ = TRUE, priority_ = "event"
    )
    app$set_inputs(
        `family_sel-families_table_cell_clicked` = c(2, 2, 14),
        allow_no_input_binding_ = TRUE, priority_ = "event"
    )
    app$wait_for_idle()
    # Download plot ped
    app$click("saveped-download")
    app$wait_for_idle()
    app$set_inputs(`saveped-width` = 1000)
    app$expect_download(
        "saveped-plot_dwld",
        compare = function(old, new) {
            old_name <- unlist(stringr::str_split(as.character(old), "-"))
            new_name <- unlist(stringr::str_split(as.character(new), "-"))
            old_name[length(old_name)] == new_name[length(new_name)]
        }
    )
    app$click("saveped-close")

    # Select family
    app$set_inputs(
        `family_sel-families_table_rows_selected` = 1,
        allow_no_input_binding_ = TRUE
    )

    app$wait_for_idle()
    app$set_inputs(`inf_sel-inf_selected` = "Cust")
    app$wait_for_idle()
    app$set_inputs(`inf_sel-inf_custvar_val` = "1_121,1_131")
    app$set_inputs(`inf_sel-kin_max` = 2)
    app$set_inputs(`inf_sel-keep_parents` = FALSE)
    df <- app$wait_for_value(export = "df", ignore = df)
    app$set_inputs(
        `subfamily_sel-families_table_rows_selected` = 2,
        allow_no_input_binding_ = TRUE
    )
    # Download plot ped
    app$wait_for_idle()
    app$expect_download("plot_data_dwnl-data_dwld")
})
