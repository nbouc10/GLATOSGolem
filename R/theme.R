#' App Theme
#'
#' @return a bs_theme object
#' @export
app_theme <- function() {
  bslib::bs_theme(
    preset = "shiny",
    version = 5,
    #fg = "#000",
    #bg = "#ace0f0",
    primary = "#ace0f0",
    secondary = "#005194",
    base_font = bslib::font_google("Lato"),
    heading_font = bslib::font_google("Lato"),
    font_scale = 1.05
  )
}
