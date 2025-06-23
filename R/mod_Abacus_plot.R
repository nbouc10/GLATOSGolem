#' Abacus_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_Abacus_plot_ui <- function(id) {
    ns <- NS(id)
    tagList(
      fluidRow(
        column(4,
               #Button for file upload
               fileInput(ns("upload"), NULL, buttonLabel = "Upload...", multiple = TRUE, accept = ".csv"),
               #Set tf
               numericInput(ns("x_res"), "X axis resolution", value = 5, min = 1, max = 1000),
               #button for running filter
               actionButton(ns("runplot"), "Generate abacus plot", class = "btn-lg btn-success"),
               #button to download filtered detections
               downloadButton(ns("download1"), "Download abacus plot")
        ),
        column(8,
               #plot showing proportion of detections exceeding filter
               plotOutput(ns("plot_abacus"), height = "500px")
        )

      ))
}


#' Abacus_plot Server Functions
#'
#' @noRd
mod_Abacus_plot_server <- function(id){
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

    # Render the base R plot in UI
    output$plot_abacus <- renderPlot({
      req(data())
      glatos::abacus_plot(
        det = data(),
        location_col = "glatos_array",
        x_res = input$x_res
      )
    })

    # Download handler to save plot as JPEG
    output$download1 <- downloadHandler(
      filename = function() {
        paste0(tools::file_path_sans_ext(input$upload$name), "_abacus_plot.jpg")
      },
      content = function(file) {
        req(data())
        jpeg(filename = file, width = 1200, height = 800, quality = 100)
        glatos::abacus_plot(
          det = data(),
          location_col = "glatos_array",
          x_res = input$x_res
        )
        dev.off()
      }
    )
  })
}



## To be copied in the UI
# mod_Abacus_plot_ui("Abacus_plot_1")

## To be copied in the server
# mod_Abacus_plot_server("Abacus_plot_1")
