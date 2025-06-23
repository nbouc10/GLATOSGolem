#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  mod_False_det_filter_server("False_det_filter_1")
  mod_Events_filter_server("Events_filter_1")
  mod_Abacus_plot_server("Abacus_plot_1")
}
