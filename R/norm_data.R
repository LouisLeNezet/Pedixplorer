#' Normalise a Ped object dataframe
#'
#' @description Normalise dataframe for a Ped object
#'
#' @details Normalise a dataframe and check for columns correspondance
#' to be able to use it as an input to create a Ped object.
#' Multiple test are done and errors are checked.
#'
#' Will be considered available any individual with no 'NA' values in the
#' `available` column.
#' Duplicated `id` will nullify the relationship of the individual.
#' All individuals with errors will be remove from the dataframe and will
#' be transfered to the error dataframe.
#'
#' A number of checks are done to ensure the dataframe is correct:
#'
#' ## On identifiers:
#'
#' - All ids (id, dadid, momid, famid) are not empty (`!= ""`)
#' - All `id` are unique (no duplicated)
#' - All `dadid` and `momid` are unique in the id column
#' (no duplicated)
#' - id is not the same as dadid or momid
#' - Either have both parents or none
#'
#' ## On sex:
#'
#' - All sex code are either `male`, `female`,
#' or `unknown`.
#' - No parents are infertile or aborted
#' - All fathers are male
#' - All mothers are female
#'
#' @param ped_df A data.frame with the individuals informations.
#' The minimum columns required are:
#'
#' - `id` individual identifiers
#' - `dadid` biological fathers identifiers
#' - `momid` biological mothers identifiers
#' - `sex` of the individual
#'
#' The `famid` column, if provided, will be merged to
#' the *ids* field separated by an underscore using the
#' [upd_famid()] function.
#'
#' The following columns are also recognize and will be transformed with the
#' [vect_to_binary()] function:
#'
#' - `deceased` status -> is the individual dead
#' - `avail` status -> is the individual available
#' - `evaluated` status -> has the individual a documented evaluation
#' - `consultand` status -> is the individual the consultand
#' - `proband` status -> is the individual the proband
#' - `carrier` status -> is the individual a carrier
#' - `asymptomatic` status -> is the individual asymptomatic
#' - `adopted` status -> is the individual adopted
#'
#' The values recognized for those columns are `1` or `0`,
#' `TRUE` or `FALSE`.
#'
#' The `fertility` column will be transformed to an ordered factor using the
#' [fertility_to_factor()] function.
#' `infertile_choice_na` < `infertile` < `fertile`
#'
#' The `miscarriage` column will be transformed to a using the
#' [miscarriage_to_factor()] function.
#' `SAB`, `TOP`, `ECT`, `FALSE`
#'
#' @param na_strings Vector of strings to be considered as NA values.
#' @param try_num Boolean defining if the function should try to convert
#' all the columns to numeric.
#' @inheritParams Ped
#'
#' @return A dataframe with different variable correctly standardized
#' and with the errors identified in the `error` column
#'
#' @include utils.R
#' @examples
#' df <- data.frame(
#'     id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
#'     dadid = c("A", 0, 1, 3, 0, 4, 1, 0, 6, 6),
#'     momid = c(0, 0, 2, 2, 0, 5, 2, 0, 8, 8),
#'     famid = c(1, 1, 1, 1, 1, 1, 1, 2, 2, 2),
#'     sex = c(1, 2, "m", "man", "f", "male", "m", 3, NA, "f"),
#'     fertility = c(
#'       "TRUE", "FALSE", TRUE, FALSE, 1,
#'       0, "fertile", "infertile", 1, "TRUE"
#'     ),
#'     miscarriage = c("TOB", "SAB", NA, FALSE, "ECT", "other", 1, 0, 1, 0),
#'     deceased = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, 1, 0, 1, 0),
#'     avail = c("A", "1", 0, NA, 1, 0, 1, 0, 1, 0),
#'     evalutated = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"),
#'     consultand = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"),
#'     proband = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"),
#'     carrier = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"),
#'     asymptomatic = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0"),
#'     adopted = c("TRUE", "FALSE", TRUE, FALSE, 1, 0, NA, "NA", "other", "0")
#' )
#' tryCatch(
#'     norm_ped(df),
#'     error = function(e) print(e)
#' )
#'
#' @seealso
#' [Ped()]
#' [Ped-class]
#' [Pedigree()]
#' @export
#' @importFrom dplyr mutate_if mutate_at mutate
#' @importFrom tidyr unite
norm_ped <- function(
    ped_df, na_strings = c("NA", ""), missid = NA_character_, try_num = FALSE,
    cols_used_del = FALSE
) {
    err_cols <- c(
        "sexErrMoFa", "sexErrFa", "sexErrMo", "sexErrFer", "sexErrMis",
        "sexErrMisFer", "sexNA",
        "sexError", "idErr", "idErrFa", "idErrMo", "idErrSelf",
        "idErrOwnParent", "idErrBothParent", "idError",
        "error"
    )
    err <- data.frame(matrix(NA, nrow = nrow(ped_df), ncol = length(err_cols)))
    colnames(err) <- err_cols
    cols_need <- c("id", "dadid", "momid", "sex")
    cols_used <- c("error")
    cols_to_use <- c(
        "famid", "fertility", "miscarriage", "deceased",
        "avail", "evaluated", "consultand", "proband", "carrier",
        "asymptomatic", "adopted"
    )
    ped_df <- check_columns(
        ped_df, cols_need, cols_used, cols_to_use, others_cols = TRUE,
        cols_to_use_init = TRUE, cols_used_init = TRUE,
        cols_used_del = cols_used_del
    )

    ped_df$famid[is.na(ped_df$famid)] <- missid

    if (nrow(ped_df) > 0) {
        ped_df <- dplyr::mutate_if(
            ped_df, is.character, ~replace(., . %in% na_strings, NA_character_)
        )

        #### Id #### Check id type
        for (id in c("id", "dadid", "momid")) {
            ped_df[[id]] <- as.character(ped_df[[id]])
        }
        err$idErr <- lapply(
            as.data.frame(t(ped_df[, c(
                "id", "dadid", "momid", "famid"
            )])),
            function(x) {
                if (any(x == "" & !is.na(x))) {
                    "one_id_is_empty"
                } else {
                    NA_character_
                }
            }
        )
        ## Make a new id from the family and subject pair
        ped_df$id <- upd_famid(ped_df$id, ped_df$famid, missid)
        ped_df$dadid <- upd_famid(ped_df$dadid, ped_df$famid, missid)
        ped_df$momid <- upd_famid(ped_df$momid, ped_df$famid, missid)

        ## Set all missid to NA
        ped_df <- dplyr::mutate_at(ped_df, c("id", "dadid", "momid", "famid"),
            ~replace(., . %in% c(na_strings, missid), NA_character_)
        )

        #### Sex ####
        ped_df$sex <- sex_to_factor(ped_df$sex)

        is_father <- ped_df$id %in% ped_df$dadid & !is.na(ped_df$id)
        is_mother <- ped_df$id %in% ped_df$momid & !is.na(ped_df$id)

        ## Add missing sex due to parenthood
        ped_df$sex[is_father] <- "male"
        ped_df$sex[is_mother] <- "female"

        if (!"fertility" %in% colnames(ped_df)) {
            ped_df$fertility <- NA_character_
        }

        ## Normalize infertility column and check for infertile parents
        ped_df$fertility <- fertility_to_factor(
            ped_df$fertility
        )
        err$sexErrFer[ped_df$fertility != "fertile"
            & (is_father | is_mother)
        ] <- "is-infertile-but-is-parent"

        ## Normalize miscarriage column and check for infertile parents
        ped_df$miscarriage <- miscarriage_to_factor(
            ped_df$miscarriage
        )
        err$sexErrMis[ped_df$miscarriage != "FALSE"
            & (is_father | is_mother)
        ] <- "is-aborted-but-is-parent"

        err$sexErrMisFer[ped_df$miscarriage != "FALSE"
            & ped_df$fertility != "fertile"
        ] <- "is-aborted-but-has-fertility"


        ## Check error between sex and parentality
        err$sexNA[!ped_df$sex %in%
                c("male", "female", "unknown")
        ] <- "sex-not-recognise"
        err$sexErrMoFa[is_father & is_mother] <- "is-mother-and-father"
        err$sexErrFa[
            is_father & ped_df$sex != "male"
        ] <- "is-father-but-not-male"
        err$sexErrMo[
            is_mother & ped_df$sex != "female"
        ] <- "is-mother-but-not-female"

        ## Unite all sex errors in one column
        err <- tidyr::unite(
            err, "sexError",
            c(
                "sexNA", "sexErrMoFa", "sexErrMo", "sexErrFa",
                "sexErrFer", "sexErrMis", "sexErrMisFer"
            ), na.rm = TRUE, sep = "_", remove = TRUE
        )
        err$sexError[err$sexError == ""] <- NA


        #### Continue to check id #####
        ## Get duplicated id key
        id_duplicated <- ped_df$id[base::duplicated(ped_df$id)]

        ## OwnParent
        id_own_parent <- ped_df$id[
            ped_df$id == ped_df$dadid | ped_df$id == ped_df$momid
        ]

        ## Register errors
        err$idErrFa[ped_df$dadid %in% id_duplicated &
                !is.na(ped_df$dadid)
        ] <- "dadid-duplicated"
        err$idErrMo[ped_df$momid %in% id_duplicated &
                !is.na(ped_df$momid)
        ] <- "momid-duplicated"
        err$idErrSelf[ped_df$id %in% id_duplicated &
                !is.na(ped_df$id)
        ] <- "self-id-duplicated"
        err$idErrOwnParent[ped_df$id %in% id_own_parent] <- "is-its-own-parent"
        err$idErrBothParent[
            (ped_df$dadid %in% missid & (!ped_df$momid %in% missid))
            | ((!ped_df$dadid %in% missid) & ped_df$momid %in% missid)
        ] <- "one-parent-missing"

        ## Unite all id errors in one column
        err <- tidyr::unite(
            err, "idError", c(
                "idErr", "idErrFa", "idErrMo", "idErrSelf",
                "idErrOwnParent", "idErrBothParent"
            ), na.rm = TRUE, sep = "_", remove = TRUE
        )
        err$idError[err$idError == ""] <- NA

        #### Deceased, Avail, Evaluated, Consultand, Proband, Carrier, Asymptomatic, Adopted ####
        ped_df$deceased <- vect_to_binary(ped_df$deceased, logical = TRUE)
        ped_df$avail <- vect_to_binary(ped_df$avail, logical = TRUE)
        ped_df$evaluated <- vect_to_binary(ped_df$evaluated, logical = TRUE, default = FALSE)
        ped_df$consultand <- vect_to_binary(ped_df$consultand, logical = TRUE, default = FALSE)
        ped_df$proband <- vect_to_binary(ped_df$proband, logical = TRUE, default = FALSE)
        ped_df$carrier <- vect_to_binary(ped_df$carrier, logical = TRUE)
        ped_df$asymptomatic <- vect_to_binary(ped_df$asymptomatic, logical = TRUE)
        ped_df$adopted <- vect_to_binary(ped_df$consultand, logical = TRUE, default = FALSE)

        #### Convert to num ####
        if (try_num) {
            col_to_num <- colnames(ped_df)[
                !colnames(ped_df) %in%
                    c(cols_need, cols_to_use)
            ]
            for (i in col_to_num) {
                is_num <- lapply(ped_df[[i]], check_num_na, na_as_num = TRUE)
                if (all(is_num)) {
                    ped_df[i] <- as.numeric(ped_df[[i]])
                }
            }
        }

        ped_df$error <- tidyr::unite(
            err, "error", c("idError", "sexError"),
            na.rm = TRUE, sep = "_", remove = TRUE
        )$error
        ped_df$error[ped_df$error == ""] <- NA
    }
    ped_df
}

#' Normalise a Rel object dataframe
#'
#' @description Normalise a dataframe and check for columns correspondance
#' to be able to use it as an input to create a Ped object.
#'
#' @details
#' The `famid` column, if provided, will be merged to the
#' *ids* field separated by an underscore using the
#' [upd_famid()] function.
#' The `code` column will be transformed with the
#' [rel_code_to_factor()].
#' Multiple test are done and errors are checked.
#'
#' A number of checks are done to ensure the dataframe is correct:
#'
#' ## On identifiers:
#'    - All ids (id1, id2) are not empty (`!= ""`)
#'    - `id1` and `id2` are not the same
#'
#' ## On code
#'   - All code are recognised as either "MZ twin", "DZ twin", "UZ twin" or
#'  "Spouse"
#'
#' @inheritParams norm_ped
#' @inheritParams Pedigree
#'
#' @examples
#' df <- data.frame(
#'     id1 = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
#'     id2 = c(2, 3, 4, 5, 6, 7, 8, 9, 10, 1),
#'     code = c("MZ twin", "DZ twin", "UZ twin", "Spouse",
#'         1, 2, 3, 4, "MzTwin", "sp oUse"),
#'     famid = c(1, 1, 1, 1, 1, 1, 1, 2, 2, 2)
#' )
#' norm_rel(df)
#'
#' @return A dataframe with the errors identified
#' @importFrom dplyr mutate_if mutate_at mutate across
#' @export
norm_rel <- function(rel_df, na_strings = c("NA", ""), missid = NA_character_) {

    if (is.matrix(rel_df)) {
        rel_df <- as.data.frame(rel_df)
        colnames(rel_df) <- c(
            "id1", "id2", "code", "famid"
        )[seq_len(ncol(rel_df))]
    }

    #### Check columns ####
    err_cols <- c("codeErr", "sameIdErr", "id1Err", "id2Err", "error")
    err <- data.frame(matrix(NA, nrow = nrow(rel_df), ncol = length(err_cols)))
    colnames(err) <- err_cols
    cols_needed <- c("id1", "id2", "code")
    cols_used <- c("error")
    cols_to_use <- c("famid")
    rel_df <- check_columns(
        rel_df, cols_needed, cols_used, cols_to_use,
        others_cols = FALSE, cols_to_use_init = TRUE, cols_used_init = TRUE
    )
    rel_df$famid[is.na(rel_df$famid)] <- missid
    if (nrow(rel_df) > 0) {
        rel_df <- dplyr::mutate_if(
            rel_df, is.character,
            ~replace(., . %in% na_strings, NA)
        )

        #### Check for code ####
        rel_df$code <- rel_code_to_factor(rel_df$code)
        err$codeErr[!rel_df$code %in%
                c("MZ twin", "DZ twin", "UZ twin", "Spouse")
        ] <- "code-not-recognise"

        #### Check for id errors #### Set ids as characters
        rel_df <- rel_df %>%
            dplyr::mutate(dplyr::across(c("id1", "id2", "famid"), as.character))

        ## Check for non null ids
        len1 <- nchar(rel_df$id1)
        len2 <- nchar(rel_df$id2)
        err$id1Err[is.na(len1) | len1 %in% missid] <- "id1-length0"
        err$id2Err[is.na(len2) | len2 %in% missid] <- "id2-length0"

        ## Compute id with family id
        rel_df$id1 <- upd_famid(rel_df$id1, rel_df$famid, missid)
        rel_df$id2 <- upd_famid(rel_df$id2, rel_df$famid, missid)

        rel_df <- dplyr::mutate_at(rel_df, c("id1", "id2", "famid"),
            ~replace(., . %in% c(na_strings, missid), NA_character_)
        )

        err$sameIdErr[rel_df$id1 == rel_df$id2] <- "same-id"

        ## Unite all id errors in one column
        rel_df$error <- unite(err, "error",
            c("sameIdErr", "id1Err", "id2Err", "codeErr"),
            na.rm = TRUE, sep = "_", remove = TRUE
        )$error
        rel_df$error[rel_df$error == ""] <- NA
    }
    rel_df
}
