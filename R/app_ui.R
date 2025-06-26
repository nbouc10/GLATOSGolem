#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
thematic::thematic_shiny()
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),

    # Your application UI logic
    bslib::page_sidebar(
      title = div("GLATOS Shiny Application",
                  img(src ="www/glatosFish.png", height = "45px", width = "45px",
                      style = "position: absolute;
                           top: 1px;
                           right: 2%;")),
      theme = app_theme(),
      sidebar = NULL, #or actual sidebar content
      bslib::navset_card_underline(
        bslib::nav_panel("False detection filter", mod_False_det_filter_ui("False_det_filter_1")),
        bslib::nav_panel("Events filter", mod_Events_filter_ui("Events_filter_1")),
        bslib::nav_panel("Abacus plot", mod_Abacus_plot_ui("Abacus_plot_1"))
      )
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
