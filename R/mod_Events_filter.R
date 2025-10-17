#' Events_filter UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_Events_filter_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
             # Choose source of data
             uiOutput(ns("data_source_ui")),

             # UI placeholder to conditionally show fileInput
             uiOutput(ns("conditional_upload")),
             #Set tf + tooltip
             div(
             tags$label(
               "Time threshold (seconds)",
               shiny::icon("circle-question") |>
               bslib::tooltip( HTML(
                 paste0(
                   "Threshold time between detection events. This will depend on the analysis you're performing.<br>",
                   'Click <a href="https://ocean-tracking-network.r-universe.dev/glatos/doc/manual.html#detection_events" target="_blank" style="color:#007bff; text-decoration:underline;">here</a> for more information.'
                          )
                        ),
                 allow_html = TRUE
               )
             ),
             numericInput(ns("time_sep"), NULL, value = 0, min = 0, max = Inf)
             ),
             #checkbox to condense
             checkboxInput(ns("condense"), "Condense to one event per row?"),
             #button for running function
             actionButton(ns("runevents"), "Classify discrete events", class = "btn-lg btn-success"),
             #button to download filtered events
             downloadButton(ns("download1"), "Download discrete detection events"),
             # Table in a card below
             bslib::card(
               full_screen = TRUE,
               bslib::card_header("Filtered Events"),
               DT::dataTableOutput(ns("events"))
             )
            )
           )
}

#' Events_filter Server Functions
#'
#' @noRd
mod_Events_filter_server <- function(id, datasets) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    #UI For data selection
    output$data_source_ui <- renderUI({
      datasets_list <- reactiveValuesToList(datasets)
      dataset_names <- names(datasets_list)

      # Add the default "Upload new file" option
      choices <- c("Upload new file", dataset_names)

      selectInput(ns("data_source"), "Detection data source", choices = choices)
    })

    # Conditionally show fileInput only if user selects "Upload new file"
    output$conditional_upload <- renderUI({
      if (input$data_source == "Upload new file") {
        fileInput(ns("upload"), "Upload detection CSV file", accept = ".csv")
      } else {
        NULL
      }
    })

    data <- reactive({
      if (input$data_source == "Upload new file") {
        req(input$upload)
        ext <- tools::file_ext(input$upload$name)
        if (ext != "csv") {
          showModal(modalDialog(
            title = "Invalid File Type",
            "Please upload a valid .csv file.",
            easyClose = TRUE,
            footer = NULL
          ))
          return(NULL)
        }
        glatos::read_glatos_detections(input$upload$datapath)
      } else {
        # Pull from shared reactiveValues
        datasets_list <- reactiveValuesToList(datasets)
        req(datasets_list$falsedet_filtered)
        datasets_list$falsedet_filtered
      }
    })

    filtered_events <- eventReactive(input$runevents, {
      req(data())  # Ensure data is available

      glatos::detection_events(
        det = data(),
        time_sep = input$time_sep,
        location_col = "glatos_array",
        condense = input$condense
      )
    })

    output$events <- DT::renderDataTable({
      req(filtered_events())
      filtered_events()
    })

    output$download1 <- downloadHandler(
      filename = function() {
        # If user didn't upload a file, fallback to generic name
        if (input$data_source == "Upload new file" && !is.null(input$upload$name)) {
          paste0(tools::file_path_sans_ext(input$upload$name), "_classified.csv")
        } else {
          "classified_events.csv"
        }
      },
      content = function(file) {
        req(filtered_events())
        write.csv(filtered_events(), file, row.names = FALSE)
      }
    )

    # Save results into the shared datasets list
    observeEvent(filtered_events(), {
      datasets$events_filtered <- filtered_events()
    })
  })
}

## To be copied in the UI
# mod_Events_filter_ui("Events_filter_1")

## To be copied in the server
# mod_Events_filter_server("Events_filter_1")
