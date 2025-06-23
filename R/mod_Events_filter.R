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
      column(4,
             #Button for file upload
             fileInput(ns("upload"), NULL, buttonLabel = "Upload detections...", multiple = TRUE, accept = ".csv"),
             #Set tf
             numericInput(ns("time_sep"), "Time threshold (seconds)", value = Inf, min = 0, max = Inf),
             #checkbox to condense
             checkboxInput(ns("condense"), "Condense to one event per row?"),
             #button for running function
             actionButton(ns("runevents"), "Classify discrete events", class = "btn-lg btn-success"),
             #button to download filtered events
             downloadButton(ns("download1"), "Download discrete detection events")
              )
            )
  )
}

#' Events_filter Server Functions
#'
#' @noRd
mod_Events_filter_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    # Read in uploaded CSV
    data <- reactive({
      req(input$upload)  # Ensure a file is uploaded

      # Check if the uploaded file is a .csv
      ext <- tools::file_ext(input$upload$name)
      if (ext != "csv") {
        showModal(modalDialog(
          title = "Invalid File Type",
          "Please upload a valid .csv file.",
          easyClose = TRUE,
          footer = NULL
        ))
        return(NULL)  # Return NULL if file is not a .csv
      }

      # Proceed with reading the .csv file
      glatos::read_glatos_detections(input$upload$datapath)
    })

    # Reactive for filtered events
    filtered_events <- eventReactive(input$runevents, {
      req(data())  # Ensure data is available

      # Run detection_events
      filtered_events <- glatos::detection_events(det = data(),
                                                  time_sep = input$time_sep,
                                                  location_col = "glatos_array",
                                                  condense = input$condense)

      return(filtered_events)
    })

    # Download classified evevnts
    output$download1 <- downloadHandler(
      filename = function() {
        paste0(tools::file_path_sans_ext(input$upload$name), "_classified.csv")
      },
      content = function(file) {
        req(filtered_events())  # Ensure filtered results are available
        write.csv(filtered_events(), file, row.names = FALSE)
      }
    )
  })
}

## To be copied in the UI
# mod_Events_filter_ui("Events_filter_1")

## To be copied in the server
# mod_Events_filter_server("Events_filter_1")
