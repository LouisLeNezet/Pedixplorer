health_var_lev <- levels(as.factor(df_aff()))
                if (length(health_var_lev) == 0) {
                    h5(paste(
                        "No value found for", input$health_var_sel
                    ))
                }
                var_to_use <- as.list(setNames(
                    health_var_lev, health_var_lev
                ))
                shinyWidgets::pickerInput(
                    ns("health_aff_mods"),
                    label = "Selection of affected modalities",
                    choices = var_to_use,
                    options = list(`actions-box` = TRUE),
                    multiple = TRUE, selected = health_var_lev
                )