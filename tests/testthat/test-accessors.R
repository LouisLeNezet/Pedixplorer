test_that("Get Ped's acessors works", {
    data("sampleped")
    data("relped")
    pedi <- Pedigree(sampleped, relped)
    expect_equal(id(ped(pedi))[1], "1_101")
    expect_equal(dadid(ped(pedi))[1], NA_character_)
    expect_equal(momid(ped(pedi))[1], NA_character_)
    expect_equal(famid(ped(pedi))[1], "1")
    expect_equal(as.character(sex(ped(pedi))[1]), "male")
    expect_equal(as.character(fertility(ped(pedi))[1]), "fertile")
    expect_equal(as.character(miscarriage(ped(pedi))[1]), "FALSE")
    expect_equal(deceased(ped(pedi))[1], NA)
    expect_equal(avail(ped(pedi))[1], FALSE)
    expect_equal(evaluated(ped(pedi))[1], TRUE)
    expect_equal(consultand(ped(pedi))[1], FALSE)
    expect_equal(proband(ped(pedi))[1], FALSE)
    expect_equal(carrier(ped(pedi))[1], NA)
    expect_equal(asymptomatic(ped(pedi))[1], NA)
    expect_equal(adopted(ped(pedi))[1], FALSE)
    expect_equal(affected(ped(pedi))[1], FALSE)
    expect_equal(dateofbirth(ped(pedi))[1], "1968-01-22")
    expect_equal(dateofdeath(ped(pedi))[1], NA_character_)
    expect_equal(isinf(ped(pedi))[1], NA)
    expect_equal(kin(ped(pedi))[1], NA_real_)
    expect_equal(useful(ped(pedi))[1], NA)
})

test_that("Assignment for Ped works", {
    data("sampleped")
    data("relped")
    pedi <- Pedigree(sampleped, relped)
    expect_error(
        horder(hints(pedi)) <- "A",
        "horder must be named"
    )
    expect_error(
        miscarriage(ped(pedi)) <- c("A", "B"),
        "The length of the new values for 'miscarriage' should be"
    )
    expect_error(
        deceased(ped(pedi)) <- c(0, 1),
        "The length of the new values for 'deceased' should be"
    )
    expect_error(
        consultand(ped(pedi)) <- c(0, 1),
        "The length of the new values for 'consultand' should be"
    )
    expect_error(
        proband(ped(pedi)) <- c(0, 1),
        "The length of the new values for 'proband' should be"
    )
    expect_error(
        carrier(ped(pedi)) <- c(0, 1),
        "The length of the new values for 'carrier' should be"
    )
    expect_error(
        asymptomatic(ped(pedi)) <- c(0, 1),
        "The length of the new values for 'asymptomatic' should be"
    )
    expect_error(
        adopted(ped(pedi)) <- c(0, 1),
        "The length of the new values for 'adopted' should be"
    )
    expect_error(
        affected(ped(pedi)) <- c(0, 1),
        "The length of the new values for 'affected' should be"
    )
    expect_error(
        dateofbirth(ped(pedi)) <- c("0", "1"),
        "The length of the new values for 'dateofbirth' should be"
    )
    expect_error(
        dateofdeath(ped(pedi)) <- c("0", "1"),
        "The length of the new values for 'dateofdeath' should be"
    )
    expect_error(
        isinf(ped(pedi)) <- c(0, 1),
        "The length of the new values for 'isinf' should be"
    )
    expect_error(
        kin(ped(pedi)) <- c(0, 1),
        "The length of the new values for 'kin' should be"
    )
    expect_error(
        useful(ped(pedi)) <- c(0, 1),
        "The length of the new values for 'useful' should be"
    )

    expect_no_error(
        carrier(ped(pedi))[1] <- TRUE
    )
    expect_no_error(
        asymptomatic(ped(pedi))[1] <- TRUE
    )
    expect_no_error(
        dateofbirth(ped(pedi))[1] <- "1982-02-28"
    )
    expect_no_error(
        dateofdeath(ped(pedi))[12] <- "1983-02-28"
    )
    expect_no_error(
        isinf(ped(pedi))[12] <- TRUE
    )
    expect_no_error(
        kin(ped(pedi))[12] <- 1
    )
    expect_no_error(
        useful(ped(pedi))[12] <- 1
    )
})

test_that("Get Rel's acessors works", {
    data("sampleped")
    data("relped")
    pedi <- Pedigree(sampleped, relped)
    expect_equal(id1(rel(pedi))[1], "1_140")
    expect_equal(id2(rel(pedi))[1], "1_141")
    expect_equal(famid(rel(pedi))[1], "1")
    expect_equal(as.character(code(rel(pedi))[1]), "MZ twin")
})

test_that("Assignment for Rel works", {
    data("sampleped")
    data("relped")
    pedi <- Pedigree(sampleped, relped)
    expect_error(
        famid(rel(pedi)) <- c("A", "B"),
        "The length of the new values for 'famid' should be"
    )
    expect_no_error(famid(rel(pedi))[1] <- "1")
})

test_that("Assignment for Pedigree works", {
    data("sampleped")
    data("relped")
    pedi <- Pedigree(sampleped, relped)
    expect_error(
        ped(pedi, slot = "adopted") <- c(TRUE, FALSE),
        "The length of the new value should be"
    )
    expect_error(
        rel(pedi, slot = "famid") <- c(TRUE, FALSE),
        "The length of the new value should be"
    )
    expect_no_error(
        ped(pedi, slot = "adopted")[1] <- TRUE
    )
    expect_no_error(
        rel(pedi, slot = "famid")[1] <- "1"
    )
    expect_no_error(
        rel(pedi) <- Rel()
    )
})

test_that("Assignment for Scales works", {
    data("sampleped")
    data("relped")
    pedi <- Pedigree(sampleped, relped)
    expect_no_error(
        border(pedi) <- Scales()@border
    )
})

test_that("Assignment for Hints works", {
    data("sampleped")
    data("relped")
    pedi <- Pedigree(sampleped, relped)
    expect_error(
        horder(pedi) <- c(0, 1),
        "horder must be named"
    )
    expect_error(
        horder(pedi) <- c("1_140" = 0),
        "Length for horder component should be equal to Pedigree"
    )
    expect_error(
        spouse(pedi) <- data.frame(
            idl = "1_140", idr = "1_141", anchor = "right"
        ),
        "horder slot should be non empty if spouse slot is non empty"
    )
})
