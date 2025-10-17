#' False_det_filter UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_False_det_filter_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      # CSV Upload label + tooltip
             div(
               tags$label(
                 "CSV Upload ",
                 shiny::icon("circle-question") |>
                   bslib::tooltip(
                     HTML(
                       paste0(
                         "Upload a detections CSV from a GLATOS data export.<br>",
                         'Click <a href="https://ocean-tracking-network.r-universe.dev/glatos/doc/manual.html#false_detections" target="_blank" style="color:#007bff; text-decoration:underline;">here</a> for more information.'
                       )
                     ),
                     allow_html = TRUE
                   )
               ),
               fileInput(
                 ns("upload"), NULL,
                 buttonLabel = "Upload...", multiple = TRUE, accept = ".csv"
               )
             ),
            # Threshold label + tooltip
            div(
                tags$label(
            "Threshold time interval (seconds) ",
            shiny::icon("circle-question") |>
            bslib::tooltip("Researchers often select a threshold of 30 times the nominal delay (e.g. 3600 for a tag with 120 second nominal delay)")
                      ),
            numericInput(ns("lag"), NULL, value = 0, min = 0, max = 180000)
              ),
             #button for running filter
             actionButton(ns("runfilter"), "Run false detections filter", class = "btn-lg btn-success"),
             #button to download filtered detections
             downloadButton(ns("download1"), "Download filtered detections"),
             # Plot in a card
             bslib::card(
               full_screen = TRUE,
               bslib::card_header("Proportion of detections exceeding the threshold time interval"),
               plotOutput(ns("plot_dets"))
             ),
             # Table in a card below
             bslib::card(
               full_screen = TRUE,
               bslib::card_header("Filtered Detections"),
               DT::dataTableOutput(ns("Preview_dets"))
             )
      )
    )
}

#' False_det_filter Server Functions
#'
#' @noRd
mod_False_det_filter_server <- function(id, datasets){
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

    # Reactive for filtered detections
    filtered_results <- eventReactive(input$runfilter, {
      req(data())  # Ensure data is available

      # Run false_detections() without plotting (Shiny will handle the plotting separately)
      #filtered_data <-
      glatos::false_detections(det = data(), tf = input$lag, show_plot = TRUE)

      #return(filtered_data)
    })

    # Render plot inside Shiny
    output$plot_dets <- renderPlot({
      req(filtered_results())
      # Run false_detections() again, but only for the plot
      glatos::false_detections(det = filtered_results(), tf = input$lag, show_plot = TRUE)
    })
    # Render filtered data
    output$Preview_dets <- DT::renderDataTable({
      req(filtered_results())  # Ensure filtered results are available
      filtered_results()
    })
    # Download filtered detections
    output$download1 <- downloadHandler(
      filename = function() {
        paste0(tools::file_path_sans_ext(input$upload$name), "_filtered.csv")
      },
      content = function(file) {
        req(filtered_results())  # Ensure filtered results are available
        write.csv(filtered_results(), file, row.names = FALSE)
      }
    )
    # Add filtered dataset to shared object
    observeEvent(filtered_results(), {
      datasets$falsedet_filtered <- filtered_results()
    })
  })
}

## To be copied in the UI
# mod_False_det_filter_ui("False_det_filter_1")

## To be copied in the server
# mod_False_det_filter_server("False_det_filter_1")
