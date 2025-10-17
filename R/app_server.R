#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Shared reactive container for all datasets
  datasets <- reactiveValues()

  # Pass datasets to modules that read/write shared data
  mod_False_det_filter_server("False_det_filter_1", datasets)
  mod_Events_filter_server("Events_filter_1", datasets)
  mod_data_manager_server("data_manager_1", datasets)

  #modules
  #mod_False_det_filter_server("False_det_filter_1")
  mod_read_glatos_detections_server("read_glatos_detections_1")
  mod_read_glatos_receivers_server("read_glatos_receivers_1")
 #mod_Events_filter_server("Events_filter_1")
  mod_Abacus_plot_server("Abacus_plot_1")
  mod_detection_bubble_plot_server("detection_bubble_plot_1")
  #mod_data_manager_server("data_manager_1")
}
