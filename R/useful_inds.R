#' Usefulness of individuals
#'
#' @description Compute the usefulness of individuals
#'
#' @details Check for the informativeness of the individuals based on the
#' informative parameter given, the number of children and the usefulness
#' of their parents. A `useful` slot is added to the Ped object with the
#' usefulness of the individual.
#'
#' @param num_child_tot A numeric vector of the number of children of each
#' individuals
#' @param keep_infos Boolean to indicate if parents with unknown status
#' but available or reverse should be kept
#' @param id_inf An identifiers vector of informative individuals.
#' @param max_dist The maximum distance to informative individuals
#' @inheritParams Ped
#'
#' @return
#' ## When obj is a vector
#' A vector of useful individuals identifiers
#'
#' ## When obj is a Pedigree or Ped object
#' The Pedigree or Ped object with the slot 'useful' containing `TRUE` for
#' useful individuals and `FALSE` otherwise.
#' @keywords shrink
#' @export
#' @usage NULL
setGeneric("useful_inds", signature = "obj",
    function(obj, ...) standardGeneric("useful_inds")
)

#' @include is_informative.R
#' @rdname useful_inds
#' @export
setMethod("useful_inds", "character",
    function(obj, dadid, momid, avail, affected, num_child_tot,
        id_inf, keep_infos = FALSE
    ) {
        id <- obj
        isinf <- id %in% id_inf

        # Get parents of individuals to be kept
        parents <- parent_of(id, dadid, momid, id_inf)

        # Keep individual affected or available
        if (keep_infos) {
            isinf <- isinf | ((
                (!is.na(affected) & affected == 1) |
                    (!is.na(avail) & avail == 1)
            ) & id %in% parents)
        }

        # Check if parents contribute to more than 1 child
        par_part <- num_child_tot > 1 & id %in% parents

        # Keep individuals and informative parents
        to_kept <- isinf | par_part
        id[to_kept]
    }
)

#' @rdname useful_inds
#' @param reset Boolean to indicate if the `useful` column should be reset
#' @examples
#'
#' data(sampleped)
#' ped1 <- Pedigree(sampleped[sampleped$famid == "1",])
#' ped1 <- is_informative(ped1, informative = "AvAf", col_aff = "affection")
#' ped(useful_inds(ped1))
#' @export
setMethod("useful_inds", "Pedigree", function(obj,
    keep_infos = FALSE,
    reset = FALSE, max_dist = NULL
) {
    new_ped <- useful_inds(ped(obj),
        keep_infos,
        reset, max_dist
    )

    obj@ped <- new_ped
    validObject(obj)
    obj
})

#' @rdname useful_inds
#' @export
setMethod("useful_inds", "Ped", function(obj,
    keep_infos = FALSE,
    reset = FALSE, max_dist = NULL
) {
    min_dist <- min_dist_inf(obj, reset)
    if (!is.null(max_dist)) {
        id_in_dist <- id(min_dist)[kin(min_dist) <= max_dist]
    } else {
        id_in_dist <- id(min_dist)[!is.infinite(kin(min_dist))]
    }
    useful <- useful_inds(id(min_dist), dadid(min_dist), momid(min_dist),
        avail(min_dist), affected(min_dist), obj@num_child_tot,
        id_in_dist, keep_infos
    )

    if (!reset & any(!is.na(useful(obj)))) {
        stop(
            "The useful slot already has values in the Ped object",
            " and reset is set to FALSE"
        )
    }
    useful[is.na(useful)] <- FALSE
    min_dist@useful <- vect_to_binary(
        ifelse(id(min_dist) %in% useful, 1, 0), logical = TRUE
    )
    validObject(min_dist)
    min_dist
})
