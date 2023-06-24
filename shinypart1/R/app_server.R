#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom dplyr filter
#' @importFrom rlang sym
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  my_mtcars <- reactive({
    mtcars %>%
      filter(!!sym("cyl") == input$filter_cyl)
  })

  output$tbl_mtcars <- renderTable(({ my_mtcars() }))
}
