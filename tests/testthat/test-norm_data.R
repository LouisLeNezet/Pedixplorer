test_that("Norm ped", {
    ped_df <- c(
        1, 3, 4, 2, FALSE, NA, "1", "None", "SAB",
        2, 0, 0, 1, TRUE, 1, 2, "A", NA,
        3, 8, 7, "man", "infertile_choice", 0, "2", "E",
        "no",
        4, 6, 5, "woman", 1, "A", 3, "A", "NA",
        5, 0, 0, "f", "fertile", NA, 7, "E", "ecT",
        6, "None", 0, "m", "steril", 0, "NA", "D", "TOP",
        7, 0, "0", 1, FALSE, "NA", 6, "A", "FALSE",
        8, 0, 0, 1, 1, "0", "3", "D", FALSE,
        8, 2, 0, 2, TRUE, "None", "3", "A", 0,
        9, 9, 8, 3, NA, "Ab", "5", "B", "spontaneous"
    )
    ped_df <- matrix(ped_df, ncol = 9, byrow = TRUE)
    dimnames(ped_df) <- list(NULL, c(
        "id", "dadid", "momid", "sex",
        "fertility", "avail", "NumOther", "AffMod",
        "miscarriage"
    ))
    ped_df <- data.frame(ped_df)
    ped_df <- suppressWarnings(norm_ped(
        ped_df, na_strings = c("None", "NA")
    ))
    expect_equal(dim(ped_df), c(10, 18))
    expect_snapshot(ped_df)
    expect_equal(sum(is.na(ped_df$error)), 2)

    ped_df <- data.frame(
        id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
        dadid = c("A", 0, 1, 3, 0, 4, 1, 0, 6, 6),
        momid = c(0, 0, 2, 2, 0, 5, 2, 0, 8, 8),
        famid = c(1, 1, 1, 1, 1, 1, 1, 2, 2, 2),
        sex = c(1, 2, "m", "man", "f", "male", "m", 3, NA, "f"),
        fertility = c(
            "TRUE", "FALSE", TRUE, FALSE, 1,
            0, "fertile", "infertile", 1, "TRUE"
        ),
        miscarriage = c("TOB", "SAB", NA, FALSE, "ECT", "other", 1, 0, 1, 0),
        deceased = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, 1, 0, 1, 0),
        avail = c("A", "1", 0, NA, 1, 0, 1, 0, 1, 0),
        evaluated = c(
            "TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"
        ),
        consultand = c(
            "TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"
        ),
        proband = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"),
        carrier = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"),
        asymptomatic = c(
            "TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"
        ),
        adopted = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0")
    )
    ped_df <- suppressWarnings(norm_ped(
        ped_df, na_strings = c("None", "NA")
    ))
    expect_equal(ped_df$sex, factor(
        c(
            "male", "female", "male", "male", "female",
            "male", "male", "female", "unknown", "female"
        ), levels = c("male", "female", "unknown"),
        ordered = TRUE
    ))
    expect_equal(ped_df$miscarriage, factor(
        c(
            "FALSE", "SAB", "FALSE", "FALSE", "ECT",
            "FALSE", "FALSE", "FALSE", "FALSE", "FALSE"
        ), levels = c("SAB", "TOP", "ECT", "FALSE")
    ))
    expect_equal(ped_df$deceased, c(
        TRUE, FALSE, TRUE, FALSE, TRUE,
        FALSE, TRUE, FALSE, TRUE, FALSE
    ))
    expect_equal(ped_df$avail, c(
        NA, TRUE, FALSE, NA, TRUE,
        FALSE, TRUE, FALSE, TRUE, FALSE
    ))
    expect_equal(ped_df$evaluated, c(
        TRUE, FALSE, TRUE, FALSE, TRUE,
        FALSE, FALSE, FALSE, FALSE, FALSE
    ))
    expect_equal(ped_df$consultand, c(
        TRUE, FALSE, TRUE, FALSE, TRUE,
        FALSE, FALSE, FALSE, FALSE, FALSE
    ))
    expect_equal(ped_df$proband, c(
        TRUE, FALSE, TRUE, FALSE, TRUE,
        FALSE, FALSE, FALSE, FALSE, FALSE
    ))
    expect_equal(ped_df$carrier, c(
        TRUE, FALSE, TRUE, FALSE, TRUE,
        FALSE, NA, NA, NA, FALSE
    ))
    expect_equal(ped_df$asymptomatic, c(
        TRUE, FALSE, TRUE, FALSE, TRUE,
        FALSE, NA, NA, NA, FALSE
    ))
    expect_equal(ped_df$adopted, c(
        TRUE, FALSE, TRUE, FALSE, TRUE,
        FALSE, FALSE, FALSE, FALSE, FALSE
    ))
})

test_that("Norm rel", {
    rel_df <- c(
        1, 2, 1, 1,
        1, 3, 2, 1,
        2, 3, 3, 1,
        1, 2, 4, 2,
        3, 4, "MZ twin", 2,
        6, 7, "Other", 2,
        8, "8", "spo Use", 2,
        9, "0", "4", 1,
        NA, "B", NA, 1
    )

    rel_df <- matrix(rel_df, ncol = 4, byrow = TRUE)
    dimnames(rel_df) <- list(NULL, c("id1", "id2", "code", "famid"))
    rel_df <- data.frame(rel_df)

    rel_df <- norm_rel(rel_df)
    expect_equal(dim(rel_df), c(9, 5))
    expect_snapshot(rel_df)
    expect_equal(sum(is.na(rel_df$error)), 6)

    rel_df <- c(
        1, 2, 1,
        1, 3, 2,
        2, 3, 3,
        1, 2, 4,
        3, 4, "MZ twin",
        6, 7, "Other",
        8, "8", "spo Use",
        9, "0", "4"
    )
    rel_df <- matrix(rel_df, ncol = 4, byrow = TRUE)
    dimnames(rel_df) <- list(NULL, c("id1", "id2", "code", "family"))
    rel_df <- data.frame(rel_df)
    expect_snapshot(norm_rel(rel_df, missid = "0"))
})
