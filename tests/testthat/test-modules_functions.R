#### Test read_data ####
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

#### Test check_col_config ####
test_that("check_col_config works", {
    ## Valid col_config
    col_config <- list(
        Column1 = list(alternate = c("A", "B"), mandatory = TRUE),
        Column2 = list(alternate = c("C", "D"), mandatory = FALSE)
    )
    expect_true(check_col_config(col_config))

    ## col_config must be a list
    col_config <- "not_a_list"
    expect_error(check_col_config(col_config), "col_config must be a list.")

    ## No column name duplicate
    col_config <- list(
        Column1 = list(alternate = c("A", "B"), mandatory = TRUE),
        Column1 = list(alternate = c("C", "D"), mandatory = FALSE)
    )
    expect_error(
        check_col_config(col_config),
        "Ensure each column is defined only once."
    )

    ## Missing 'mandatory' field fails
    # No mandatory field
    col_config <- list(Column1 = list(alternate = c("A", "B")))
    expect_error(check_col_config(col_config), "Issue with: Column1")

    ## Missing 'alternate' field fails
    # No alternate field
    col_config <- list(Column1 = list(mandatory = TRUE))
    expect_error(check_col_config(col_config), "Issue with: Column1")

    ## 'alternate' field must be a character vector
    # Not a character vector
    col_config <- list(Column1 = list(alternate = 123, mandatory = TRUE))
    expect_error(
        check_col_config(col_config),
        paste(
            "The 'alternate' field for Column1 must be a non-empty",
            "character vector."
        )
    )

    ## 'mandatory' field must be TRUE/FALSE
    # Not a logical value
    col_config <- list(
        Column1 = list(alternate = c("A", "B"), mandatory = "yes")
    )
    expect_error(
        check_col_config(col_config),
        paste(
            "The 'mandatory' field for Column1 must be a single",
            "TRUE/FALSE value."
        )
    )

    ## Duplicate column names in 'alternate' fail
    # "B" is duplicated
    col_config <- list(
        Column1 = list(alternate = c("A", "B"), mandatory = TRUE),
        Column2 = list(alternate = c("B", "C"), mandatory = FALSE)
    )
    expect_error(
        check_col_config(col_config),
        "B are/is duplicated in alternate configuration."
    )
})

test_that("validate_and_rename_df works", {
    # Sample dataframe
    df <- data.frame(A = 1:3, B = 4:6, C = 7:9, D = 10:12)

    # Valid column configuration
    col_config <- list(
        Column1 = list(alternate = c("A", "B"), mandatory = TRUE),
        B = list(alternate = c("C", "D"), mandatory = FALSE),
        A = list(alternate = c(), mandatory = FALSE),
        other = list(alternate = c(), mandatory = FALSE)
    )

    # Valid selections (matching col_config)
    selections <- list(Column1 = "D", B = "C", A = NA, other = NA)
    df_renamed <- validate_and_rename_df(df, selections, col_config)
    expect_true(is.data.frame(df_renamed))
    expect_equal(colnames(df_renamed), c("Column1", "B", "A", "other"))

    # Missing mandatory column
    selections <- list(Column2 = "C")
    expect_null(validate_and_rename_df(df, selections, col_config))

    # Duplicate column selection
    selections <- list(Column1 = "A", Column2 = "A")
    expect_error(
        validate_and_rename_df(df, selections, col_config),
        "You have selected the same column multiple times."
    )

    # Selecting a column that doesn't exist
    selections <- list(Column1 = "X", Column2 = "C")
    expect_error(
        validate_and_rename_df(df, selections, col_config),
        "X selected column(s) are/is not in the dataframe!"
    )

    # Input df is not a dataframe
    expect_error(
        validate_and_rename_df("not_a_dataframe", selections, col_config),
        "The input 'df' must be a data frame or data table."
    )

    # selections is not a named list
    expect_error(
        validate_and_rename_df(df, c("A", "B"), col_config),
        "The 'selections' argument must be a named list."
    )

    # others_cols = FALSE (Only selected columns should be returned)
    selections <- list(Column1 = "A", Column2 = "C")
    df_filtered <- validate_and_rename_df(
        df, selections, col_config, others_cols = FALSE
    )
    expect_equal(colnames(df_filtered), c("Column1", "Column2"))
})

test_that("distribute_by correctly distributes elements", {

    # Test row-wise distribution (by_row = TRUE)
    expect_equal(
        distribute_by(3, 10, TRUE),
        c(1, 2, 3, 1, 2, 3, 1, 2, 3, 1)
    )
    expect_equal(
        distribute_by(2, 7, TRUE),
        c(1, 2, 1, 2, 1, 2, 1)
    )

    # Test column-wise distribution (by_row = FALSE)
    expect_equal(
        distribute_by(3, 10, FALSE),
        c(1, 1, 1, 1, 2, 2, 2, 3, 3, 3)
    )
    expect_equal(
        distribute_by(3, 15, FALSE),
        c(1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3)
    )
    expect_equal(
        distribute_by(4, 10, FALSE),
        c(1, 1, 1, 2, 2, 2, 3, 3, 4, 4)
    )

    # Edge case: Only one column
    expect_equal(distribute_by(1, 5, FALSE), rep(1, 5))

    # Edge case: More columns than elements
    expect_equal(distribute_by(10, 5, FALSE), c(1, 2, 3, 4, 5))

    # Edge case: Zero elements
    expect_equal(distribute_by(3, 0, FALSE), integer(0))

    # Edge case: Single element
    expect_equal(distribute_by(3, 1, FALSE), 1)
})
