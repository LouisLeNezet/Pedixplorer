module_ui <- function(id) {
    ns <- shiny::NS(id)
    tagList(
        uiOutput(ns("var_selector"))
    )
}

module_server <- function(id, pedi, var = NULL, multiple = NULL) {
    ns <- shiny::NS(id)
    shiny::moduleServer(id, function(input, output, session) {
        output$var_selector <- renderUI({
            print("Test server module")
            print(var)
            cols_all <- colnames(as.data.frame(ped(pedi())))
            cols_all <- as.list(setNames(cols_all, cols_all))
            selectInput(
                ns("var_sel"),
                label = h5("Select Variable"),
                choices = cols_all,
                selected = var, multiple = multiple
            )
        })

        lst <- reactive({
            list(var = input$var_sel)
        })

        return(lst)
    })
}

test_server <- function(input, output, session) {
    pedi <- reactive({
        data("sampleped")
        Pedigree(sampleped)
    })
    r_objects <- shiny::reactiveValues(
        var = "sex"
    )

    lst_val2 <- reactive({
        module_server("test", pedi, r_objects$var, input$multiple)()
    }) %>% bindEvent(input$multiple)

    lst_val <- reactive({
        health_sel_server("health", pedi, r_objects$var, input$multiple)()
    }) %>% bindEvent(input$multiple)

    observeEvent(lst_val2(), {
        print("Update test module")
        r_objects$var <- lst_val2()$var
    })
    observeEvent(lst_val(), {
        print("Update health module")
        r_objects$var <- lst_val()$health_var
    })
}

test_ui <- function() {
    tagList(
        module_ui("test"),
        health_sel_ui("health"),
        checkboxInput("multiple", "Multiple?", value = TRUE)
    )
}
shiny::shinyApp(ui = test_ui, server = test_server)

