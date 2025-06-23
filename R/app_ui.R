#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    navbarPage(
      titlePanel("GLATOS Shiny"),
      tabPanel("False detection filter", mod_False_det_filter_ui("False_det_filter_1")),
      tabPanel("Events filter", mod_Events_filter_ui("Events_filter_1")),
      tabPanel("Abacus plot", mod_Abacus_plot_ui("Abacus_plot_1"))
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "GLATOSshiny"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
