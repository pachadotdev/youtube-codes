#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom dplyr distinct pull
#' @importFrom rlang sym
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      h1("shinypart1"),
      selectInput(
        "filter_cyl",
        "Select a number of cylinders",
        selected = 4,
        choices = datasets::mtcars %>%
          distinct(!!sym("cyl")) %>%
          pull() %>%
          sort()
      ),
      tableOutput("tbl_mtcars")
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
      app_title = "shinypart1"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
