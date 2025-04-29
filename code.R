# Install required packages if not already installed
# install.packages("shiny")
# install.packages("ggplot2")

library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Interactive Data Explorer"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV (optional)", accept = ".csv"),
      uiOutput("xvar"),
      uiOutput("yvar"),
      checkboxInput("showSummary", "Show Summary", TRUE)
    ),
    
    mainPanel(
      plotOutput("plot"),
      verbatimTextOutput("summary")
    )
  )
)

server <- function(input, output, session) {
  dataset <- reactive({
    if (is.null(input$file)) {
      iris  # Default dataset
    } else {
      read.csv(input$file$datapath)
    }
  })
  
  output$xvar <- renderUI({
    selectInput("x", "X-axis", choices = names(dataset()))
  })
  
  output$yvar <- renderUI({
    selectInput("y", "Y-axis", choices = names(dataset()))
  })
  
  output$plot <- renderPlot({
    req(input$x, input$y)
    ggplot(dataset(), aes_string(x = input$x, y = input$y)) +
      geom_point(color = "steelblue", size = 3) +
      theme_minimal()
  })
  
  output$summary <- renderPrint({
    if (input$showSummary) {
      summary(dataset())
    }
  })
}

shinyApp(ui, server)
