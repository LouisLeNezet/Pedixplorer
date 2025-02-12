test_that("check_columns", {
    df <- data.frame(
        ColN1 = c(1, 2), ColN2 = 4,
        ColU1 = "B", ColU2 = "1",
        ColTU1 = "A", ColTU2 = 3,
        ColNR1 = 4, ColNR2 = 5
    )
    # Test with cols_used_del = FALSE
    expect_error(suppressWarnings(check_columns(
        df, c("ColN1", "ColN2"), c("ColU1", "ColU2"),
        c("ColTU1", "ColTU2", "ColTU3")
    )))
    df_result <- data.frame(
        ColN1 = c(1, 2), ColN2 = 4, ColTU1 = "A", ColTU2 = 3
    )
    df_get <- suppressWarnings(check_columns(
        df, c("ColN1", "ColN2"), c("ColU1", "ColU2"),
        c("ColTU1", "ColTU2"), others_cols = FALSE, cols_used_del = TRUE
    ))
    expect_equal(df_get, df_result)

    df <- data.frame(
        ColN1 = c(1, 2), ColN2 = 4, ColTU1 = "A",
        ColTU2 = 3, ColNR1 = 4, ColNR2 = 5
    )
    # Test with others_cols = TRUE
    df_get <- suppressWarnings(check_columns(
        df, c("ColN1", "ColN2"), c("ColU1", "ColU2"),
        c("ColTU1", "ColTU2"), others_cols = TRUE
    ))
    df_result <- data.frame(
        ColN1 = c(1, 2), ColN2 = 4,
        ColTU1 = "A", ColTU2 = 3, ColNR1 = 4, ColNR2 = 5
    )
    expect_equal(df_get, df_result)

    # Test with cols_used_init = TRUE
    df_get <- suppressWarnings(check_columns(
        df, c("ColN1", "ColN2"), c("ColU1", "ColU2"),
        c("ColTU1", "ColTU2"), cols_used_init = TRUE
    ))
    df_result <- data.frame(
        ColN1 = c(1, 2), ColN2 = 4,
        ColTU1 = "A", ColTU2 = 3, ColU1 = NA, ColU2 = NA
    )
    expect_equal(df_get, df_result)

    # Test with cols_to_use_init = TRUE
    df_get <- suppressWarnings(check_columns(
        df, c("ColN1", "ColN2"), c("ColU1", "ColU2"),
        c("ColTU1", "ColTU2", "ColTU3"), cols_to_use_init = TRUE
    ))
    df_result <- data.frame(
        ColN1 = c(1, 2), ColN2 = 4,
        ColTU1 = "A", ColTU2 = 3, ColTU3 = NA
    )
    expect_equal(df_get, df_result)
})

test_that("check_num_na", {
    var <- c(45, "NA", "Test", "46.2", -2, "-46", "2NA")
    get_b_na <- check_num_na(var)
    expect_equal(get_b_na, c(TRUE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE))
    get_b <- check_num_na(var, na_as_num = FALSE)
    expect_equal(get_b, c(TRUE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE))
})

test_that("get_families_table", {
    df <- data.frame(
        famid = c(1, 1, 2, 3, 3, 3),
        health = c("A", "B", "A", "A", "B", "B"),
        age = c(45, 23, 12, 45, 23, 45)
    )
    expect_snapshot(get_families_table(df, "health"))
    expect_snapshot(get_families_table(df, "age"))
})

test_that("get_title", {
    t1 <- get_title(1, 1, "health", "A", "All", 3, TRUE, 10, FALSE)
    t2 <- get_title(1, 1, "health", "A", "All", 3, TRUE, 10, TRUE)
    t3 <- get_title(1, 1, "health", "A", "All", 3, FALSE, 10, FALSE)
    expect_equal(
        t1,
        paste(
            "Pedigree trimmed of family N*1 sub-family N*1",
            "(N=10) from All individuals."
        )
    )
    expect_equal(t2, "Ped_F1_K3_T_IAll_SF1")
    expect_equal(t3, paste(
        "Pedigree of family N*1 sub-family N*1",
        "(N=10) from All individuals."
    ))
})

test_that("fertility_to_factor", {
    fertility <- c(
        1, "fertile", TRUE, NA,
        "infertile", "steril", FALSE, 0,
        "infertile_na", "infertile_choice_na", "infertile_choice"
    )
    fertil <- fertility_to_factor(fertility)
    expect_equal(
        fertil,
        factor(c(
            "fertile", "fertile", "fertile", "fertile",
            "infertile", "infertile", "infertile", "infertile",
            "infertile_choice_na", "infertile_choice_na",
            "infertile_choice_na"
        ), levels = c("infertile_choice_na", "infertile", "fertile"),
        ordered = TRUE)
    )
})


test_that("miscarriage_to_factor", {
    miscarriage <- c(
        "spontaneous", "spontaenous abortion", "SAB",
        "termination", "terminated", "termination of pregnancy", "TOP",
        "ectopic", "ectopic pregnancy", "ECT", "ecT",
        "0", "false", "no", "NA", "other", 0, FALSE
    )
    miscarriage <- miscarriage_to_factor(miscarriage)
    expect_equal(
        miscarriage,
        factor(c(
            "SAB", "SAB", "SAB",
            "TOP", "TOP", "TOP", "TOP",
            "ECT", "ECT", "ECT", "ECT",
            "FALSE", "FALSE", "FALSE", "FALSE",
            "FALSE", "FALSE", "FALSE"
        ), levels = c("SAB", "TOP", "ECT", "FALSE"))
    )
})

test_that("vect_to_binary", {
    my_vect <- c(
        0, 1, 2, 3.6,
        "TRUE", "FALSE", "0", "1", "NA", "B",
        TRUE, FALSE, NA
    )
    my_vect_1 <- suppressWarnings(vect_to_binary(my_vect))
    expect_equal(
        my_vect_1, c(
            0, 1, NA, NA,
            1, 0, 0, 1, NA, NA,
            1, 0, NA
        )
    )
    my_vect_1 <- suppressWarnings(vect_to_binary(my_vect, default = FALSE))
    expect_equal(
        my_vect_1, c(
            0, 1, 0, 0,
            1, 0, 0, 1, 0, 0,
            1, 0, 0
        )
    )

    my_vect_1 <- suppressWarnings(vect_to_binary(my_vect, logical = TRUE, default = TRUE))
    expect_equal(
        my_vect_1, c(
            FALSE, TRUE, TRUE, TRUE,
            TRUE, FALSE, FALSE, TRUE, TRUE, TRUE,
            TRUE, FALSE, TRUE
        )
    )
})
