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
      sidebar = mod_data_manager_ui("data_manager_1"),
      bslib::navset_card_underline(
        bslib::nav_panel("Landing Page", bslib::card(full_screen=TRUE,
                                                     bslib::card_header("TESTING"))),
        bslib::nav_panel("Loading Data",
                bslib::layout_columns(
                col_widths = c(6, 6),
                         bslib::card(
                           full_screen=TRUE,
                           bslib::card_header("Read GLATOS Detections"),
                           bslib::card_body(
                             mod_read_glatos_detections_ui("read_glatos_detections_1")
                           )
                         ),
                         bslib::card(
                           full_screen=TRUE,
                           bslib::card_header("Read GLATOS Receivers"),
                           bslib::card_body(
                             mod_read_glatos_receivers_ui("read_glatos_receivers_1")
                             )
                           )
                          )
                         ),
        bslib::nav_panel("Filtering and summarizing data",
                         bslib::layout_columns(
                           col_widths = c(6, 6),
                         bslib::card(full_screen=TRUE,
                         bslib::card_header("False detection filter"),
                         bslib::card_body(mod_False_det_filter_ui("False_det_filter_1")
                           )
                         ),
                         bslib::card(
                           full_screen=TRUE,
                           bslib::card_header("Events Filter"),
                           bslib::card_body(mod_Events_filter_ui("Events_filter_1")
                           )
                          )
                        )
                      ),
        bslib::nav_panel("Data Visualization",
                         bslib::layout_columns(
                           col_widths = c(6, 6),
                           bslib::card(full_screen=TRUE,
                                       bslib::card_header("Abacus Plot"),
                                       bslib::card_body(mod_Abacus_plot_ui("Abacus_plot_1")
                                       )
                           ),
                           bslib::card(
                             full_screen=TRUE,
                             bslib::card_header("Detections Bubble Plot"),
                             bslib::card_body(mod_detection_bubble_plot_ui("detection_bubble_plot_1")
                             )
                            )
                           )
                          )
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
