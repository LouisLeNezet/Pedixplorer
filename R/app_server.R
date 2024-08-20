usethis::use_package("shiny")
usethis::use_package("shinyjs")
usethis::use_package("shinyWidgets")
usethis::use_package("dplyr")
usethis::use_package("DT")
usethis::use_package("gridExtra")

#' @include app_health_sel.R
#' @include app_family_sel.R
#' @include app_inf_sel.R
#' @include app_ped_avaf_infos.R
#' @include app_plot_ped.R
#' @include app_data_import.R
#' @include app_data_col_sel.R
#' @include app_data_download.R
#' @include app_utils.R
#' @include app_plot_download.R
#' @rdname ped_shiny
#' @param input The input object from a Shiny app.
#' @param output The output object from a Shiny app.
#' @param session The session object from a Shiny app.
ped_server <- shiny::shinyServer(function(input, output, session) {
    ## Ped data import --------------------------------------------------------
    ped_df <- data_import_server(
        id = "data_ped_import",
        label = "Select pedigree file :",
        dftest = Pedixplorer::sampleped
    )
    ped_df_rename <- data_col_sel_server(
        "data_ped_col_sel", ped_df,
        list(
            "indId" = c("indid", "indId", "id"),
            "fatherId" = c("dadid", "fatherid", "fatherId"),
            "motherId" = c("momid", "motherid", "motherId"),
            "gender" = c("gender", "sex")
        ),
        list(
            "family" = c("family", "famid"),
            "steril" = c("steril", "sterilization"),
            "available" = c("avail", "available"),
            "status" = c("status", "vitalStatus")
        ),
        "Select columns :", na_omit = TRUE
    )
    ## Rel data import --------------------------------------------------------
    rel_df <- data_import_server(
        id = "data_rel_import",
        label = "Select relationship file :",
        dftest = Pedixplorer::relped
    )
    rel_df_rename <- data_col_sel_server(
        "data_rel_col_sel", rel_df,
        list(
            "id1" = c("id1", "indId1"),
            "id2" = c("id2", "indId2"),
            "code" = c("code")
        ), list(),
        "Select columns :", na_omit = TRUE
    )

    ## Ped families object creation -------------------------------------------
    ped_df_norm <- shiny::reactive({
        shiny::req(ped_df_rename())
        if (is.null(ped_df_rename())) {
            return(NULL)
        }
        ped_df <- ped_df_rename()
        if (!"family" %in% colnames(ped_df_rename())) {
            ped_df$family <- make_famid(
                as.character(ped_df$indId),
                as.character(ped_df$fatherId),
                as.character(ped_df$motherId)
            )
        }
        return(norm_ped(ped_df, cols_used_del = TRUE, missid = c(NA, "0", 0)))
    })
    rel_df_norm <- shiny::reactive({
        if (is.null(rel_df_rename())) {
            return(NULL)
        }
        norm_rel(rel_df_rename())
    })

    ped_all <- shiny::reactive({
        shiny::req(ped_df_norm())
        if (is.null(ped_df_norm())) {
            return(NULL)
        }
        if (any(!is.na(ped_df_norm()$error)) |
                any(!is.na(rel_df_norm()$error))) {
            showNotification(paste(
                "An error is present in the data given.",
                "Please check the data and try again."
            ))
            return(NULL)
        }
        Pedigree(
            ped_df_norm(), rel_df_norm(),
            cols_ren_ped = list(),
            cols_ren_rel = list(),
            normalize = FALSE
        )
    })

    ## Errors download --------------------------------------------------------
    shiny::observeEvent(ped_df_norm(), {
        data_download_server("ped_df_norm",
            shiny::reactive({
                ped_df_norm()[!is.na(ped_df_norm()$error), ]
            }), "Pedigree data errors"
        )
    })

    shiny::observeEvent(rel_df_norm(), {
        data_download_server("rel_errors",
            shiny::reactive({
                rel_df_norm()[!is.na(rel_df_norm()$error), ]
            }), "Relationship data errors"
        )
    })

    ## Reactives values -------------------------------------------------------
    r_objects <- shiny::reactiveValues(
        fam_var = "family",
        fam_sel = 1,
        sub_fam_var = "family",
        sub_fam_sel = 1
    )

    ## Health selection -------------------------------------------------------
    lst_health <- health_sel_server(
        "health_sel", ped_all, var = "affection"
    )

    ## Generate colors creation -----------------------------------------------
    output$health_full_scale_box <- renderUI({
        checkboxInput(
            "health_full_scale",
            label = "Full scale color",
            value = FALSE
        )
    })

    cols_aff <- color_picker_server("col_aff",
        list(
            "LeastAffected" = "yellow",
            "Affected" = "red"
        )
    )

    cols_unaff <- color_picker_server("col_unaff",
        list(
            "Unaffected" = "white",
            "Dubious" = "steelblue4"
        )
    )

    cols_avail <- color_picker_server("col_avail",
        list("Avail" = "green", "Unavail" = "black")
    )

    ## Families selection -----------------------------------------------------
    lst_fam <- family_sel_server(
        "family_sel", ped_all, r_objects$fam_var, r_objects$fam_sel
    )

    ## Pedigree affected ------------------------------------------------------
    ped_aff <- shiny::reactive({
        shiny::req(lst_fam())
        shiny::req(lst_health())
        if (is.null(lst_fam()) |
                is.null(lst_health()) |
                is.null(input$health_full_scale)
        ) {
            return(NULL)
        }
        if (lst_health()$health_as_num &
                is.null(lst_health()$health_threshold)
        ) {
            return(NULL)
        }
        generate_colors(
            lst_fam()$ped_fam, col_aff = lst_health()$health_var,
            add_to_scale = FALSE, mods_aff = lst_health()$health_mods_aff,
            threshold = lst_health()$health_threshold,
            is_num = lst_health()$health_as_num,
            sup_thres_aff = lst_health()$health_sup_threshold,
            keep_full_scale = input$health_full_scale,
            colors_aff = unname(unlist(
                cols_aff()[c("LeastAffected", "Affected")]
            )),
            colors_unaff = unname(unlist(
                cols_unaff()[c("Unaffected", "Dubious")]
            )),
            colors_na = "grey",
            colors_avail = unname(unlist(
                cols_avail()[c("Avail", "Unavail")]
            )),
            breaks = 3
        )
    })

    ## Family information -----------------------------------------------------
    ped_avaf_infos_server("ped_avaf_infos", ped_aff)

    ## Informative selection --------------------------------------------------
    lst_inf <- inf_sel_server("inf_sel", ped_all)

    ## Subfamily selection ----------------------------------------------------
    ped_subfamilies <- shiny::reactive({
        shiny::req(lst_inf())
        shiny::req(ped_aff())
        pedi_inf <- useful_inds(
            ped_aff(), lst_inf()$inf_sel,
            keep_infos = lst_inf()$keep_parents,
            max_dist = lst_inf()$kin_max, reset = TRUE
        )
        pedi_inf <- subset(
            pedi_inf, useful(ped(pedi_inf)),
            del_parents = "both"
        )
        make_famid(pedi_inf)
    })

    lst_subfam <- family_sel_server(
        "subfamily_sel", ped_subfamilies,
        fam_var="family", fam_sel = 1
    )

    ped_subfam <- shiny::reactive({
        shiny::req(lst_subfam())
        if (is.null(lst_subfam())) {
            return(NULL)
        }
        lst_subfam()$ped_fam
    })

    ## Sub Family information -------------------------------------------------
    ped_avaf_infos_server("subped_avaf_infos", ped_subfam)

    ## Plotting pedigree ------------------------------------------------------
    title <- function(short = TRUE) {
        shiny::reactive({
            shiny::req(lst_fam())
            shiny::req(lst_subfam())
            shiny::req(lst_inf())
            get_title(
                family_sel = lst_fam()$famid,
                subfamily_sel = lst_subfam()$famid,
                family_var = lst_health()$health_var,
                mod = lst_health()$health_mods_aff,
                inf_selected = lst_inf()$inf_sel,
                kin_max = lst_inf()$kin_max,
                keep_parents = lst_inf()$keep_parents,
                nb_rows = length(lst_inf()$ped_inf), short_title = short
            )
        })
    }
    
    plot_ped <- plot_ped_server(
        "ped", ped_subfam, title(FALSE)
    )
    plot_download_server("saveped", plot_ped, title())

    ## End --------------------------------------------------------------------
    if (!interactive()) {
        session$onSessionEnded(function() {
            shiny::stopApp()
            q("no")
        })
    }
})