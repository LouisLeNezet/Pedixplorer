usethis::use_package("shiny")
usethis::use_package("shinyjs")
usethis::use_package("shinyWidgets")
usethis::use_package("dplyr")
usethis::use_package("DT")
usethis::use_package("gridExtra")

#' @include app_health_sel.R
#' @include app_family_sel.R
ped_server <- shiny::shinyServer(function(input, output, session) {
    ## Ped data import --------------------------------------------------------
    ped_df <- data_import_server(
        id = "data_ped_import",
        label = "Select pedigree file :"
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
        label = "Select relationship file :"
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

    ## Families selection -----------------------------------------------------
    lst_fam <- family_sel_server("family_sel", ped_all)
    ped_fam <- shiny::reactive({
        shiny::req(lst_fam())
        if (is.null(lst_fam())) {
            return(NULL)
        }
        lst_fam()[["ped_fam"]]
    })

    ## Health selection -------------------------------------------------------
    lst_health <- health_sel_server("health_sel", ped_fam)

    ## Generate colors creation -----------------------------------------------
    output$health_full_scale_box <- renderUI({
        checkboxInput(
            "health_full_scale",
            label = "Full scale color",
            value = FALSE
        )
    })

    ped_aff <- shiny::reactive({
        shiny::req(lst_fam())
        shiny::req(lst_health())
        if (is.null(lst_fam()) |
                is.null(lst_health()) |
                is.null(input$health_full_scale)
        ) {
            return(NULL)
        }
        if (lst_health()$to_num & is.null(lst_health()$threshold)) {
            return(NULL)
        }
        generate_colors(
            lst_fam()$ped_fam, col_aff = lst_health()$health_var,
            add_to_scale = FALSE, mods_aff = lst_health()$mods_aff,
            threshold = lst_health()$threshold, is_num = lst_health()$to_num,
            sup_thres_aff = lst_health()$threshold_sup,
            keep_full_scale = input$health_full_scale,
            breaks = 3
        )
    })

    ## Family information -----------------------------------------------------
    ped_avaf_infos_server("ped_avaf_infos", ped_aff)

    ## Informative selection --------------------------------------------------
    lst_inf <- inf_sel_server("inf_sel", ped_aff)

    ## Subfamily selection ----------------------------------------------------
    ped_subfamilies <- shiny::reactive({
        shiny::req(lst_inf())
        ped_inf <- lst_inf()[["ped_inf"]]
        if (is.null(lst_inf())) {
            return(NULL)
        }
        make_famid(lst_inf()[["ped_inf"]])
    })
    lst_subfam <- family_sel_server("subfamily_sel", ped_subfamilies)

    ped_subfam <- shiny::reactive({
        shiny::req(lst_subfam())
        if (is.null(lst_subfam())) {
            return(NULL)
        }
        lst_subfam()[["ped_fam"]]
    })

    ## Sub Family information -------------------------------------------------
    ped_avaf_infos_server("subped_avaf_infos", ped_subfam)

    ## Plotting pedigree ------------------------------------------------------
    title_long <- shiny::reactive({
        shiny::req(lst_fam())
        shiny::req(lst_subfam())
        shiny::req(lst_inf())
        get_title(
            family_sel = lst_fam()$famid,
            subfamily_sel = lst_subfam()$famid,
            family_var = lst_health()$health_var,
            mod = lst_health()$mods_aff,
            inf_selected = lst_inf()$inf_sel,
            kin_max = lst_inf()$kin_max,
            keep_parents = lst_inf()$keep_parents,
            nb_rows = length(lst_inf()$ped_inf), short_title = FALSE
        )
    })
    title_short <- shiny::reactive({
        shiny::req(lst_fam())
        shiny::req(lst_subfam())
        shiny::req(lst_inf())
        get_title(
            family_sel = lst_fam()$famid,
            subfamily_sel = lst_subfam()$famid,
            family_var = lst_health()$health_var,
            mod = lst_health()$mods_aff,
            inf_selected = lst_inf()$inf_sel,
            kin_max = lst_inf()$kin_max,
            keep_parents = lst_inf()$keep_parents,
            nb_rows = length(lst_inf()$ped_inf), short_title = TRUE
        )
    })
    plot_ped <- plot_ped_server(
        "ped", ped_subfam, title_long
    )
    plot_download_server("saveped", plot_ped, title_short)

    ## End --------------------------------------------------------------------
    if (!interactive()) {
        session$onSessionEnded(function() {
            shiny::stopApp()
            q("no")
        })
    }
})