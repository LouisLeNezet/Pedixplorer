setClass("testClass", representation(x = "data.frame", y = "list"))
obj <- new("testClass",
    x = data.frame(A = 1:10, B = LETTERS[1:10]),
    y = list(B = 11:20)
)
setMethod("as.list", c(x = "testClass"), function(x, ...) {
    list(x = x@x, y = x@y)
})

lst <- list(
    W = list(), X = data.frame(a = 1:10),
    Y = 11:20, Z = list(A = 1:10)
)

test_that("check_slot_fd works", {
    expect_error(check_slot_fd(obj, "C", "A"))
    expect_equal(
        check_slot_fd(obj, "x", c("B", "C", "D")),
        "'C', 'D' column(s) is not present in slot x."
    )
    expect_equal(check_slot_fd(lst, "X", "a"), NULL)
    expect_equal(check_slot_fd(lst, "Z", "A"), NULL)
    expect_equal(
        check_slot_fd(lst, "W", "A"),
        "No fields in W slot. See Pedigree documentation."
    )
})

test_that("check_values works", {
    expect_equal(
        check_values(obj@y$B, 1:15),
        paste0("Values '16', '17', '18', '19', '20' ",
            "should be in '1', '2', '3', '4', '5'..."
        )
    )
    expect_equal(check_values(obj@x$A, 1:15), NULL)
    expect_error(check_values(obj@x[c("B", "A")], 1:15))
    expect_equal(
        check_values(obj@x$B, 1:2),
        "Values 'A', 'B', 'C', 'D', 'E'... should be in '1', '2'"
    )
    expect_equal(
        check_values(obj@x$A, 1:5),
        "Values '6', '7', '8', '9', '10' should be in '1', '2', '3', '4', '5'"
    )

    ## test present = FALSE
    expect_equal(
        check_values(obj@x$A, 1:15, present = FALSE),
        paste0("Values '1', '2', '3', '4', '5'... ",
            "should not be in '1', '2', '3', '4', '5'..."
        )
    )
})

test_that("paste0max works", {
    expect_equal(paste0max(1:10), "'1', '2', '3', '4', '5'...")
    expect_equal(paste0max(1:3), "'1', '2', '3'")
})

test_that("is_valid works", {
    data("sampleped")
    data("relped")
    pedi <- Pedigree(sampleped, relped)
    expect_equal(is_valid_scales(pedi@scales), TRUE)
    expect_equal(is_valid_hints(pedi@hints), TRUE)
    expect_equal(is_valid_ped(pedi@ped), TRUE)
    expect_equal(is_valid_rel(pedi@rel), TRUE)
    expect_equal(is_valid_pedigree(pedi), TRUE)
})


test_that("is_valid_hints throw errors", {
    setClass("testClass2", representation(horder = "list", spouse = "list"))
    setMethod("as.list", c(x = "testClass2"), function(x, ...) {
        list(horder = x@horder, spouse = x@spouse)
    })
    obj <- new("testClass2",
        horder = list(A = 1:10),
        spouse = list(B = 11:20)
    )
    expect_equal(
        is_valid_hints(obj),
        c(
            "horder slot must be numeric",
            "spouse slot must be a data.frame",
            "'idl', 'idr', 'anchor' column(s) is not present in slot spouse.",
            "anchor column must be a factor"
        )
    )
    setClass("testClass2", representation(
        horder = "list", spouse = "data.frame"
    ))
    obj <- new("testClass2",
        horder = list(1:10),
        spouse = data.frame(
            idl = c(1, 2, 3), idr = c(1, 3, 2), anchor = c(1, 2, 3)
        )
    )
    expect_equal(
        is_valid_hints(obj),
        c(
            "horder slot must be numeric",
            "horder slot should be named",
            "anchor column must be a factor",
            paste(
                "anchor values '1', '2', '3'",
                "should be in 'left', 'right', 'either'"
            ),
            "idl and idr should be different",
            paste(
                "idl and idr couple should be unique: 2_3 couples",
                "are present more than once in the spouse slot."
            ),
            "All idl and idr should be in the names of horder"
        )
    )
    obj <- new("testClass2",
        horder = list(),
        spouse = data.frame(
            idl = c(1, 2, 3), idr = c(1, 3, 2), anchor = c(1, 2, 3)
        )
    )
    expect_equal(
        is_valid_hints(obj),
        c(
            "horder slot must be numeric",
            "anchor column must be a factor",
            paste(
                "anchor values '1', '2', '3'",
                "should be in 'left', 'right', 'either'"
            ),
            "idl and idr should be different",
            paste(
                "idl and idr couple should be unique: 2_3 couples",
                "are present more than once in the spouse slot."
            ),
            "horder slot should be non empty if spouse slot is non empty"
        )
    )
})

test_that("is_valid_scales throw errors", {
    setClass("testClass3", representation(fill = "list", border = "list"))
    setMethod("as.list", c(x = "testClass3"), function(x, ...) {
        list(fill = x@fill, border = x@border)
    })
    obj <- new("testClass3",
        fill = list(A = 1:10),
        border = list(B = 11:20)
    )
    expect_equal(
        is_valid_scales(obj),
        c(
            paste(
                "'order', 'column_values', 'column_mods', 'mods',",
                "'labels'... column(s) is not present in slot fill."
            ),
            paste(
                "'column_values', 'column_mods', 'mods', 'labels',",
                "'border' column(s) is not present in slot border."
            ),
            "Fill slot affected column(s) must be logical",
            "Fill slot density, angle, order, mods column(s) must be numeric",
            paste(
                "Fill slot column_values, column_mods, labels, fill",
                "column(s) must be character"
            ),
            paste(
                "Border slot column_values, column_mods, labels,",
                "border column(s) must be character"
            ),
            "Border slot mods column(s) must be numeric"
        )
    )
    setClass("testClass2", representation(
        horder = "list", spouse = "data.frame"
    ))
    obj <- new("testClass2",
        horder = list(1:10),
        spouse = data.frame(
            idl = c(1, 2, 3), idr = c(1, 3, 2), anchor = c(1, 2, 3)
        )
    )
    expect_equal(
        is_valid_hints(obj),
        c(
            "horder slot must be numeric",
            "horder slot should be named",
            "anchor column must be a factor",
            paste(
                "anchor values '1', '2', '3'",
                "should be in 'left', 'right', 'either'"
            ),
            "idl and idr should be different",
            paste(
                "idl and idr couple should be unique: 2_3 couples",
                "are present more than once in the spouse slot."
            ),
            "All idl and idr should be in the names of horder"
        )
    )
    obj <- new("testClass2",
        horder = list(),
        spouse = data.frame(
            idl = c(1, 2, 3), idr = c(1, 3, 2), anchor = c(1, 2, 3)
        )
    )
    expect_equal(
        is_valid_hints(obj),
        c(
            "horder slot must be numeric",
            "anchor column must be a factor",
            paste(
                "anchor values '1', '2', '3'",
                "should be in 'left', 'right', 'either'"
            ),
            "idl and idr should be different",
            paste(
                "idl and idr couple should be unique: 2_3 couples",
                "are present more than once in the spouse slot."
            ),
            "horder slot should be non empty if spouse slot is non empty"
        )
    )
})

test_that("is_valid_ped throw errors", {
    data("sampleped")
    pedi <- Ped(sampleped)

    expect_error(
        id(pedi)[2] <- "101",
        "Id in ped slot must be unique"
    )

    pedi@dateofbirth[1] <- "2020/01-01"
    pedi@dateofdeath[1] <- "2020/01-01"
    pedi@sex[1] <- "female"
    pedi@sex[2] <- "male"
    pedi@dadid[3] <- NA
    pedi@fertility[1] <- "infertile"
    pedi@fertility[2] <- "infertile"
    pedi@miscarriage[1] <- "TOP"
    pedi@miscarriage[2] <- "SAB"
    pedi@proband[2] <- TRUE
    pedi@consultand[2] <- TRUE

    expect_equal(
        is_valid_ped(pedi),
        c(
            "101 has a date of birth but it is not a date",
            "101 has a date of death but it is not a date",
            "101 is dad but not male",
            "102 is mom but not female",
            "103 should have both parents or none",
            "101 is dad but not fertile",
            "102 is mom but not fertile",
            "101 is dad have a miscarriage status",
            "102 is mom have a miscarriage status",
            paste(
                "101 is infertile and has a miscarriage status",
                "only one of the two should be present"
            ),
            paste(
                "102 is infertile and has a miscarriage status",
                "only one of the two should be present"
            ),
            "102 is consultand and proband",
            "101 is not deceased but has a date of death"
        )
    )

    pedi <- Ped(sampleped)

    pedi@proband[2] <- TRUE
    pedi@affected[2] <- FALSE

    expect_warning(
        test <- is_valid_ped(pedi),
        regex = "102 individual\\(s\\) are/is proband but not affected"
    )

    pedi <- Ped(sampleped)
    pedi@asymptomatic[1] <- TRUE
    pedi@affected[1] <- TRUE
    expect_warning(
        test <- is_valid_ped(pedi),
        regex = "101 individual\\(s\\) are/is asymptomatic but affected"
    )
})


test_that("is_valid_rel throw errors", {
    data("relped")
    reli <- Rel(relped)

    reli@id2[1] <- "1_140"
    reli@id1[2] <- "1_140"
    reli@id2[2] <- "1_139"
    reli@id1[3] <- "2_204"
    reli@id2[3] <- "2_208"
    expect_equal(
        is_valid_rel(reli),
        c(
            "id1 '1_140' should be different to id2 '1_140'",
            "id1 '1_140' should be smaller than id2 '1_139'",
            "Pairs of individuals should be unique ('2_204-2_208')"
        )
    )

})

test_that("is_valid_pedigree throw errors", {
    data("relped")
    data("sampleped")
    pedi <- Pedigree(sampleped, relped)

    pedi@ped@dadid[40] <- "1_103"
    pedi@ped@momid[40] <- "1_104"
    pedi@ped@sex[40] <- "male"
    pedi@scales@fill <- rbind(pedi@scales@fill, "1")
    pedi@scales@border <- rbind(pedi@scales@border, "1")
    pedi@scales@fill$mods[1] <- "NotPresent"
    pedi@hints@horder <- c(A = 1)
    pedi@hints@spouse <- rbind(
        pedi@hints@spouse,
        data.frame(idl = "A", idr = "B", anchor = "left")
    )
    expect_equal(
        is_valid_pedigree(pedi),
        c(
            "twins found with different mothers",
            "twins found with different fathers",
            "MZ twins with different genders",
            paste(
                c("fill", "fill", "border"),
                c("column_values", "column_mods", "column_values"),
                "values '1' should be in 'id', 'dadid',",
                "'momid', 'famid', 'sex'..."
            ),
            paste(
                "fill column affection_mods values '0' should be in",
                "'NotPresent', '1', 'NA'"
            ),
            "Length for horder component should be equal to Pedigree length",
            "Hints horder id A not present in the Ped object",
            "Hints spouse(s) A not present in the Ped object",
            "Hints spouse(s) B not present in the Ped object",
            "Hints spouse(s) A_B not female, male"
        )
    )
})
