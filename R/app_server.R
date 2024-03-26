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
        c("indId", "fatherId", "motherId", "gender"),
        c("family", "steril", "available", "status"),
        "Select columns :", na_omit = TRUE
    )
    ## Rel data import --------------------------------------------------------
    rel_df <- data_import_server(
        id = "data_rel_import",
        label = "Select relationship file :"
    )
    rel_df_rename <- data_col_sel_server(
        "data_rel_col_sel", rel_df,
        c("id1", "id2", "code"), c(),
        "Select columns :", na_omit = TRUE
    )

    ## Ped object creation ----------------------------------------------------
    ped_df_norm <- shiny::reactive({
        if (is.null(ped_df_rename())) {
            return(NULL)
        }
        norm_ped(ped_df_rename())
    })
    rel_df_norm <- shiny::reactive({
        if (is.null((rel_df_rename()))) {
            return(NULL)
        }
        norm_rel(rel_df_rename())
    })

    ped_all <- shiny::reactive({
        if (any(!is.na(ped_df_norm()$error)) |
                any(!is.na(rel_df_norm()$error))) {
            showNotification(paste(
                "An error is present in the data given.",
                "Please check the data and try again."
            ))
            return(NULL)
        }
        if (is.null(ped_df_norm())) {
            return(NULL)
        }
        print("Bal: ped_all2")
        print(ped_df_norm())
        ped <- Pedigree(ped_df_norm(), rel_df_norm())
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
    ped_fam <- family_sel_server("family_sel", ped_all)

    ## Health selection -------------------------------------------------------
    lst_health <- health_sel_server("health_sel", ped_fam)

    output$health_full_scale_box <- renderUI({
        if (!is.null(input$health_var_sel)) {
            checkboxInput(
                "health_full_scale",
                label = "Full scale color",
                value = FALSE
            )
        } else {
            NULL
        }
    })

    ## Ped object creation ----------------------------------------------------
    ped_aff <- shiny::reactive({
        shiny::req(ped_fam())
        generate_colors(
            ped_fam(), col_aff = lst_health()$health_var,
            add_to_scale = FALSE, mods_aff = lst_health()$mods_aff,
            threshold = lst_health()$threshold,
            sup_thres_aff = lst_health()$threshold_sup,
            keep_full_scale = input$health_full_scale, breaks = 3
        )
    })

    ## Family information -----------------------------------------------------
    output$family_info_table <- renderTable({
        shiny::req(ped_aff())
        print("Bal: family_info_table")
        df <- ped_aff()$df
        if (!is.null(df)) {
            base::table(
                df$avail, df$mods_aff,
                useNA = "ifany",
                dnn = c("Availability", input$health_var_sel)
            ) %>%
                as.data.frame() %>%
                tidyr::spread(Availability, Freq)
        } else {
            NULL
        }
    })
    output$family_infos_title <- renderText({
        print("Bal: family_infos_title")
        if (!is.null(ped_fam())) {
            paste(
                "Health & Availability data representation for family",
                unique(famid(ped_fam()))
            )
        } else {
            NULL
        }
    })


    ## Informative individuals selection -------
    #Informative individuals custom selection
    output$inf_var_selector <- renderUI({
        if (!is.null(ped_aff())) {
            selectInput(
                "inf_selected",
                label = h5(strong("Select informative individuals")),
                choices = list(
                    "All individuals" = "All",
                    "Available or Affected" = "AvOrAf",
                    "Available only" = "Av",
                    "Affected only" = "Af",
                    "Available and Affected" = "AvAf",
                    "Custom" = "Cust"
                ), selected = "All"
            )
        } else {
            NULL
        }
    })
    output$inf_custvar_selector <- renderUI({
        shiny::req(input$inf_selected == "Cust")
        df <- ped_aff()$df
        if (input$inf_selected == "Cust" & !is.null(df)) {
            col_present <- colnames(df)
            selectInput(
                "inf_custvar_sel",
                label = "Select Variable to use to select informative individuals",
                choices = as.list(setNames(col_present, col_present))
            )
        } else {
            NULL
        }
    })
    output$inf_custvar_textinput <- renderUI({
        shiny::req(input$inf_selected == "Cust")
        if (input$inf_selected == "Cust") {
            textAreaInput(
                "inf_custvar_val", label = h5("Custom selection"),
                placeholder = "Please enter individuals values separate by a comma"
            )
        } else {
            NULL
        }
    })
    #Informative individuals selection
    inf_inds_selected <- reactive({
        shiny::req(ped_aff())
        print("Bal: inf_inds_selected")
        shiny::req(input$inf_selected)
        if (input$inf_selected != "Cust") {
            return(input$inf_selected)
        }
        print("Bal: inf_inds_selected custom")
        shiny::req(input$inf_custvar_val)
        shiny::req(input$inf_custvar_sel)
        if (!identical(input$inf_custvar_val, "")) {
            inf_custvar_sel <- input$inf_custvar_sel
            inf_custvar_val <- unlist(strsplit(input$inf_custvar_val, ","))

            df <- ped_aff()$df
            index <- which(df[, inf_custvar_sel] %in% inf_custvar_val)
            if (any(is.na(index))) {
                showNotification(paste(
                    "Values", inf_custvar_val[is.na(index)],
                    "not present in", inf_custvar_sel
                ))
                NULL
            } else {
                df$id[index[!is.na(index)]]
            }
        } else {
            showNotification("Custom option selected but no individual id given")
            NULL
        }
    })
    inf_inds_sel_txt <- function() {
        isolate({
            if (input$inf_selected == "Cust") {
                paste(
                    input$InfCustVariable, "(id ",
                    paste(inf_inds_selected(), collapse = ","),
                    ")"
                )
            } else {
                inf_inds_selected()
            }
        })
    }
    ped_df_inf <- reactive({
        shiny::req(inf_inds_selected())
        shiny::req(input$trim_ped)
        shiny::req(input$keep_infos)
        shiny::req(ped_aff())
        print("Bal: ped_df_inf")
        df <- ped_aff()$df
        inf_inds <- inf_inds_selected()

        if (!is.null(df) & !any(is.na(inf_inds))) {
            tryCatch({
                df_from_inf <- select_from_inf(
                    df,
                    inf_inds = inf_inds, kin_max = input$kin_max
                )
                df_from_inf <- num_child(
                    df_from_inf,
                    relation = rel_df_norm()$norm
                )
                if (input$trim_ped) {
                    df_from_inf$useful <- useful_inds(
                        df_from_inf, inf_inds,
                        input$keep_infos
                    )
                    df_from_inf <- fix_parents.data.frame(
                        df_from_inf,
                        delete = FALSE, filter = "useful"
                    )
                    df_from_inf <- fix_parents.data.frame(
                        df = df_from_inf,
                        delete = TRUE
                    )
                }
                df_from_inf
            },
            error = function(e) {
                message(paste("Error in ped_df_inf", e))
                NULL
            })
        } else {
            NULL
        }
    })
    ## Subfamily selection ---------------------
    subfamilies_table <- reactive({
        print("Bal: subfamilies_table")
        shiny::req(ped_df_inf())
        ped_df <- ped_df_inf()
        if (!is.null(ped_df) & !is.null(input$families_var_sel)) {
            get_families_table(ped_df, input$families_var_sel)
        } else {
            NULL
        }
    })
    output$subfamilies_table <- DT::renderDataTable({
        subfamilies_table()
    }, options = list(
        paging = FALSE, scrollX = TRUE,
        scrollY = "200px", scrollCollapse = TRUE
    ),
    rownames = FALSE)
    output$subfamily_selector <- renderUI({
        print("Bal: subfamily_sel")
        if (!is.null(subfamilies_table())) {
            fam_nb <- as.numeric(subfamilies_table()$FamilyNum)
            if (max(fam_nb) > 0) {
                numericInput(
                    "subfamily_sel",
                    label = h5(strong("Select subfamily to use")),
                    value = 1, min = min(fam_nb), max = max(fam_nb)
                )
            } else {
                textOutput("No family present (only unconnected individuals)")
            }
        } else {
            NULL
        }
    })

    ## Final ped_df ---------------------------
    ped_df_final <- reactive({
        print("Bal: ped_df_final")
        shiny::req(ped_df_inf())
        shiny::req(input$subfamily_sel)
        ped_df <- ped_df_inf()
        if (!is.null(ped_df) & !is.null(input$subfamily_sel)) {
            ped_df <- ped_df[ped_df$family == input$subfamily_sel, ]
        }
        ped_df
    })

    ped_gens <- reactive({
        ped <- with(ped_df_final(), pedigree(id, dadid, momid, sex, affected))
        align(ped)$n
    })

    ## Plotting -------------------------------
    plotped_obj <- plot_ped_server(
        "plot_ped", ped_df_final, get_title_app(short = FALSE)
    )

    output$legend_plot <- renderPlot({
        shiny::req(ped_aff())
        cols <- ped_aff()$scales
        legend <- create_legend(cols, size = 0.8)
        gridExtra::grid.arrange(legend$A, legend$B, ncol = 2)
    }, height = 150)

    ## Download pedigree-----------------------
    get_title_app <- function(short = FALSE) {
        df <- families_table()
        get_title(
            input$family_sel, input$subfamily_sel,
            input$families_var_sel,
            df[df$FamilyNum == input$family_sel, "Major mod"],
            inf_inds_sel_txt(), input$kin_max,
            input$trim_ped, input$keep_infos,
            nrow(ped_df_final()),
            short_title = short
        )
    }
    data_download_server(
        "plot_data_dwnl", ped_df_final,
        filename = get_title_app(short = TRUE), label = "Subfamily data",
        helper = FALSE
    )

    shiny::observeEvent(ped_gens(), {
        plot_download_server(
            "plot_ped_dwnl", plotped_obj,
            filename = get_title_app(short = TRUE), label = "Subfamily plot",
            width = max(c(ped_gens() * 80, 500)),
            height = max(c(length(ped_gens()) * 150, 500))
        )
    })

    ## End ------------------------------------
    if (!interactive()) {
        session$onSessionEnded(function() {
            shiny::stopApp()
            q("no")
        })
    }
})